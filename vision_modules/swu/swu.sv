module swu #(
    parameter int H = 720,
    parameter int W = 1280,
    parameter int WINDOW_H = 3,
    parameter int WINDOW_W = 3,
    parameter int IN_W = 8
)
(
    input   logic clk,
    input   logic resetn,

    input   logic [IN_W - 1 : 0]        s_axis_tdata,
    input   logic                       s_axis_tvalid,
    output  logic                       s_axis_tready,

    output  logic [IN_W - 1 : 0]        m_axis_tdata [WINDOW_H][WINDOW_W],
    output  logic                       m_axis_tvalid,
    input   logic                       m_axis_tready,
    output  logic                       m_axis_tlast
);

    wire                    line_buffer_shift_en = s_axis_tvalid && s_axis_tready;
    logic [IN_W - 1 : 0]    line_buffer_inputs  [WINDOW_H - 1];
    logic [IN_W - 1 : 0]    line_buffer_outputs [WINDOW_H - 1];  
    logic [IN_W - 1 : 0]    window [WINDOW_H][WINDOW_W];
    logic [$clog2(H) - 1 : 0] y_cnt = 0;
    logic [$clog2(W) - 1 : 0] x_cnt = 0;
    logic                   Vld = 0;
    logic                   Lst = 0;

    for(genvar i = 0; i < WINDOW_H - 1; i++) begin
        assign line_buffer_inputs[i] = window[i][WINDOW_W - 1];

        shift_register #(
            .WIDTH(IN_W),
            .DELAY(W - WINDOW_W)
        ) line_buffer (
            .clk, .resetn,
            .data_in(line_buffer_inputs[i]), .data_out(line_buffer_outputs[i]),
            .shift_en(line_buffer_shift_en)
        );
    end

    always_ff @(posedge clk) begin
        if(!resetn) begin
            x_cnt <= 0;
            y_cnt <= 0;
            Vld <= 0;
            Lst <= 0;
        end

        else begin
            // connect window registers and line buffers
            if(line_buffer_shift_en) begin
                for(int row = 0; row < WINDOW_H; row++) begin
                    for(int col = 0; col < WINDOW_W; col++) begin
                        if(col == 0) begin
                            if(row == 0) window[row][col] <= s_axis_tdata;
                            else window[row][col] <= line_buffer_outputs[row - 1];
                        end
                        else begin
                            window[row][col] <= window[row][col - 1];
                        end
                    end
                end

                x_cnt <= (x_cnt == W - 1) ? 0 : x_cnt + 1;
                if(x_cnt == W - 1)
                    y_cnt <= (y_cnt == H - 1) ? 0 : y_cnt + 1;

                if(x_cnt >= (WINDOW_W - 1) && x_cnt <= (W - 1) && y_cnt >= (WINDOW_H - 1) && y_cnt <= (H - 1)) begin
                    Vld <= 1;
                    if(x_cnt == (W - 1) && y_cnt == (H - 1))
                        Lst <= 1;
                    else
                        Lst <= 0;
                end
                else
                    Vld <= 0;
            end

            if(!s_axis_tvalid && Vld)
                Vld <= 0;
        end
    end

    // rewire output so it is not flipped
    for(genvar row = 0; row < WINDOW_H; row++) begin
        for(genvar col = 0; col < WINDOW_W; col++) begin
            assign m_axis_tdata[row][col] = window[WINDOW_H - 1 - row][WINDOW_W - 1 - col];
        end
    end
    assign s_axis_tready = m_axis_tready;
    // assign m_axis_tvalid =  x_cnt >= (WINDOW_W - 1) && x_cnt <= (W - 1) &&
    //                         y_cnt >= (WINDOW_H - 1) && y_cnt <= (H - 1);
    assign m_axis_tvalid = Vld;
    assign m_axis_tlast = Vld && Lst;

endmodule: swu
