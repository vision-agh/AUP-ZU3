module swu_tb;

    localparam IMG_H = 720;
    localparam IMG_W = 1280;
    localparam DATA_W = 8;
    localparam FOLDING = 1;
    localparam CHANNELS = 3;
    localparam channels_per_packet = (CHANNELS / FOLDING);
    localparam packet_width = channels_per_packet * DATA_W;

    localparam WINDOW_H = 3;
    localparam WINDOW_W = 3;

    logic resetn = 0;
    initial
    begin
        #10
        resetn <= 1;
    end
    logic clk = 0;
    always begin
        #1
        clk = !clk;
    end

    logic [packet_width - 1 : 0] features_m_axis_tdata;
    logic features_m_axis_tvalid;
    logic features_m_axis_tready;
    logic [$clog2(IMG_H) - 1 : 0] y_cnt = 0;
    logic [$clog2(IMG_W) - 1 : 0] x_cnt = 0;

    binfile2axis #(
        .IMG_PATH("../../../../../bytearray.bin"), //paths are relative to <project_directory>/<project_name>.sim/sim_1/behav/xsim/
        .FOLDING(FOLDING),
        .height(IMG_H),
        .width(IMG_W),
        .channels(CHANNELS),
        .datawidth(DATA_W),
        .TO_SEND(1)
    )
    file_input (
        .clk, .resetn,
        .m_axis_0_tdata(features_m_axis_tdata),
        .m_axis_0_tvalid(features_m_axis_tvalid),
        .m_axis_0_tready(features_m_axis_tready)
    );

    always @(posedge clk) begin
        if(features_m_axis_tvalid && features_m_axis_tready) begin
            x_cnt <= (x_cnt == IMG_W - 1) ? 0 : x_cnt + 1;
            if(x_cnt == IMG_W - 1)
                y_cnt <= (y_cnt == IMG_H - 1) ? 0 : y_cnt + 1;
        end
    end

    logic [DATA_W - 1 : 0] window_m_axis_tdata [WINDOW_H][WINDOW_W];
    logic window_m_axis_tvalid;
    logic window_m_axis_tready;

    // send only R channel to the swu
    swu #(
        .WINDOW_H(WINDOW_H), .WINDOW_W(WINDOW_W),
        .H(IMG_H), .W(IMG_W),
        .IN_W(DATA_W)
    ) dut (
        .clk, .resetn,
        .s_axis_tdata(features_m_axis_tdata[packet_width - 1 -: DATA_W]), .s_axis_tvalid(features_m_axis_tvalid), .s_axis_tready(features_m_axis_tready),
        .m_axis_tdata(window_m_axis_tdata), .m_axis_tvalid(window_m_axis_tvalid), .m_axis_tready(window_m_axis_tready)
    );

    assign window_m_axis_tready = 1;

endmodule: swu_tb