module sobel_filter_tb;

    localparam IMG_H = 720;
    localparam IMG_W = 1280;
    localparam DATA_W = 8;
    localparam FOLDING = 1;
    localparam CHANNELS = 3;
    localparam channels_per_packet = (CHANNELS / FOLDING);
    localparam packet_width = channels_per_packet * DATA_W;

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

    binfile2axis #(
        .IMG_PATH("../../../../../bytearray.bin"), //paths are relative to <project_directory>/<project_name>.sim/sim_1/behav/xsim/
        .FOLDING(FOLDING),
        .height(IMG_H),
        .width(IMG_W),
        .channels(CHANNELS),
        .datawidth(DATA_W),
        .TO_SEND(1),
        .RANDOM_INTERRUPTS(1)
    )
    file_input (
        .clk, .resetn,
        .m_axis_0_tdata(features_m_axis_tdata),
        .m_axis_0_tvalid(features_m_axis_tvalid),
        .m_axis_0_tready(features_m_axis_tready)
    );

    logic [DATA_W - 1 : 0] sobel_filter_m_axis_tdata;
    logic sobel_filter_m_axis_tvalid;
    logic sobel_filter_m_axis_tready;

    // send only R channel to the sobel_filter
    sobel_filter #(
        .H(IMG_H), .W(IMG_W),
        .DATA_W(DATA_W)
    ) dut (
        .clk, .resetn,
        .s_axis_tdata(features_m_axis_tdata[packet_width - 1 -: DATA_W]), .s_axis_tvalid(features_m_axis_tvalid), .s_axis_tready(features_m_axis_tready),
        .m_axis_tdata(sobel_filter_m_axis_tdata), .m_axis_tvalid(sobel_filter_m_axis_tvalid), .m_axis_tready(sobel_filter_m_axis_tready)
    );

    initial begin
        forever begin
            sobel_filter_m_axis_tready <= 0;
            while($urandom()%20 == 0) @(posedge clk);
            sobel_filter_m_axis_tready <= 1;
            @(posedge clk);
        end
    end

endmodule: sobel_filter_tb