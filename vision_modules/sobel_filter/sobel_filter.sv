module sobel_filter #(
    parameter int H = 720,
    parameter int W = 1280,
    parameter int DATA_W = 8
)
(
    input   logic clk,
    input   logic resetn,

    input   logic [DATA_W - 1 : 0]      s_axis_tdata,
    input   logic                       s_axis_tvalid,
    output  logic                       s_axis_tready,

    output  logic [DATA_W - 1 : 0]      m_axis_tdata,
    output  logic                       m_axis_tvalid,
    input   logic                       m_axis_tready
);

    localparam CONTEXT_H = 3;
    localparam CONTEXT_W = 3;
    localparam int PROD_W  = DATA_W + 2;   // context multiplied by sobel weights
    localparam int GRAD_W  = PROD_W + 3;   // |Gx| + |Gy|   

    logic [DATA_W - 1 : 0]      context_m_axis_tdata [CONTEXT_H][CONTEXT_W];
    logic                       context_m_axis_tvalid;
    wire                        context_m_axis_tready = m_axis_tready;

    // ------------------ stage 1 - context generation
    swu #(
        .H(H), .W(W),
        .WINDOW_H(CONTEXT_H), .WINDOW_W(CONTEXT_W),
        .IN_W(DATA_W)
    ) context_generator (
        .clk, .resetn,
        .s_axis_tdata, .s_axis_tvalid, .s_axis_tready,
        .m_axis_tdata(context_m_axis_tdata), .m_axis_tvalid(context_m_axis_tvalid), .m_axis_tready(context_m_axis_tready)
    );

    // ------------------- stage 2 - kernel elementwise multiplication
    localparam int signed SOBEL_KERNEL_X [CONTEXT_H][CONTEXT_W] = '{
        '{-1,  0, +1},
        '{-2,  0, +2},
        '{-1,  0, +1}
    };
 
    localparam int signed SOBEL_KERNEL_Y [CONTEXT_H][CONTEXT_W] = '{
        '{-1, -2, -1},
        '{ 0,  0,  0},
        '{+1, +2, +1}
    };
    logic signed [PROD_W - 1 : 0]      weighted_context_x [CONTEXT_H][CONTEXT_W];
    logic signed [PROD_W - 1 : 0]      weighted_context_y [CONTEXT_H][CONTEXT_W];

    // asynchronously multiply context by sobel weights
    // simple operations, negations and bitshifts (multiplication by 2)
    always_comb begin
        for(int row = 0; row < CONTEXT_H; row++) begin
            for(int col = 0; col < CONTEXT_W; col++) begin
                weighted_context_x[row][col] = context_m_axis_tdata[row][col] * SOBEL_KERNEL_X[row][col];
                weighted_context_y[row][col] = context_m_axis_tdata[row][col] * SOBEL_KERNEL_Y[row][col];
            end
        end
    end

    // --------------------- stage 3 - weighted context summation
    localparam int SUMMATION_PIPELINE_DEPTH = 3;
    logic signed [(PROD_W + 1) - 1 : 0] summation_x_stage1 [3];
    logic signed [(PROD_W + 1) - 1 : 0] summation_y_stage1 [3];
    logic signed [(PROD_W + 2) - 1 : 0] summation_x_stage2 [2];
    logic signed [(PROD_W + 2) - 1 : 0] summation_y_stage2 [2];
    logic signed [GRAD_W - 1 : 0] gradient_x;
    logic signed [GRAD_W - 1 : 0] gradient_y;
    logic [1 : SUMMATION_PIPELINE_DEPTH] data_valid_chain = 0;

    always_ff @(posedge clk) begin
        // pipeline stage 1
        summation_x_stage1[0] <= weighted_context_x[0][0] + weighted_context_x[0][2];
        summation_x_stage1[1] <= weighted_context_x[1][0] + weighted_context_x[1][2];
        summation_x_stage1[2] <= weighted_context_x[2][0] + weighted_context_x[2][2];

        summation_y_stage1[0] <= weighted_context_y[0][0] + weighted_context_y[2][0];
        summation_y_stage1[1] <= weighted_context_y[0][1] + weighted_context_y[2][1];
        summation_y_stage1[2] <= weighted_context_y[0][2] + weighted_context_y[2][2];

        // pipeline stage 2
        summation_x_stage2[0] <= summation_x_stage1[0] + summation_x_stage1[1];
        summation_x_stage2[1] <= summation_x_stage1[2];

        summation_y_stage2[0] <= summation_y_stage1[0] + summation_y_stage1[1];
        summation_y_stage2[1] <= summation_y_stage1[2];

        // pipeline stage 3
        gradient_x <= summation_x_stage2[0] + summation_x_stage2[1];
        gradient_y <= summation_y_stage2[0] + summation_y_stage2[1];

        // delay valid signal
        data_valid_chain <= {context_m_axis_tvalid, data_valid_chain[1 : SUMMATION_PIPELINE_DEPTH - 1]};
    end

    // ----------------------- stage 4 - final gradient computation: |gradient_x| + |gradient_y|
    wire [GRAD_W : 0]       abs_gradient_x = gradient_x < 0 ? -gradient_x : gradient_x;
    wire [GRAD_W : 0]       abs_gradient_y = gradient_y < 0 ? -gradient_y : gradient_y;
    logic [GRAD_W + 1 : 0]  gradient;
    logic                   gradient_valid = 0;

    always_ff @(posedge clk) begin
        gradient <= abs_gradient_x + abs_gradient_y;
        gradient_valid <= data_valid_chain[SUMMATION_PIPELINE_DEPTH];
    end

    assign m_axis_tvalid = gradient_valid;
    assign m_axis_tdata = gradient[DATA_W - 1 -: DATA_W];

endmodule: sobel_filter