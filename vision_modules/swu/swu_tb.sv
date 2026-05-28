module swu_tb;

    localparam IMG_H = 480;
    localparam IMG_W = 640;
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

    logic [7 : 0] features_m_axis_tdata = 'x;
    logic features_m_axis_tvalid = 0;
    logic features_m_axis_tready;
    logic [$clog2(IMG_H) - 1 : 0] y_cnt = 0;
    logic [$clog2(IMG_W) - 1 : 0] x_cnt = 0;
    logic [0 : IMG_H - 1][0 : IMG_W - 1][7 : 0] img;
    initial begin
        for(int row = 0; row < IMG_H; row++) begin
            for(int col = 0; col < IMG_W; col++) begin
                img[row][col] = $urandom();
            end
        end

        // print corners
        $display("Top left corner of the image:");
        for(int row = 0; row < 10; row++) begin
            for(int col = 0; col < 10; col++) begin
                $write("%d ", img[row][col]);
            end
            $write("\n");
        end

        $display("Top right corner of the image:");
        for(int row = 0; row < 10; row++) begin
            for(int col = IMG_W - 10; col < IMG_W; col++) begin
                $write("%d ", img[row][col]);
            end
            $write("\n");
        end
    end



    // binfile2axis #(
    //     .IMG_PATH("../../../../../bytearray_dummy.bin"), //paths are relative to <project_directory>/<project_name>.sim/sim_1/behav/xsim/
    //     .FOLDING(FOLDING),
    //     .height(IMG_H),
    //     .width(IMG_W),
    //     .channels(CHANNELS),
    //     .datawidth(DATA_W),
    //     .TO_SEND(1),
    //     .RANDOM_INTERRUPTS(1)
    // )
    // file_input (
    //     .clk, .resetn,
    //     .m_axis_0_tdata(features_m_axis_tdata),
    //     .m_axis_0_tvalid(features_m_axis_tvalid),
    //     .m_axis_0_tready(features_m_axis_tready)
    // );
    initial begin
        @(posedge clk iff resetn);
        for(int row = 0; row < IMG_H; row++) begin
            for(int col = 0; col < IMG_W; col++) begin
                while($urandom() % 5 == 0) @(posedge clk);
                features_m_axis_tvalid <= 1;
                features_m_axis_tdata <= img[row][col];
                do @(posedge clk); while(!features_m_axis_tready);
                features_m_axis_tvalid <= 0;
                features_m_axis_tdata <= 'x;
            end
        end
    end

    logic [DATA_W - 1 : 0] window_m_axis_tdata [WINDOW_H][WINDOW_W];
    logic window_m_axis_tvalid;
    logic window_m_axis_tready = 0;
    logic window_m_axis_tlast;

    // send only R channel to the swu
    swu #(
        .WINDOW_H(WINDOW_H), .WINDOW_W(WINDOW_W),
        .H(IMG_H), .W(IMG_W),
        .IN_W(DATA_W)
    ) dut (
        .clk, .resetn,
        .s_axis_tdata(features_m_axis_tdata), .s_axis_tvalid(features_m_axis_tvalid), .s_axis_tready(features_m_axis_tready),
        .m_axis_tdata(window_m_axis_tdata), .m_axis_tvalid(window_m_axis_tvalid), .m_axis_tready(window_m_axis_tready), .m_axis_tlast(window_m_axis_tlast)
    );

    // count output window position
    always @(posedge clk) begin
        if(window_m_axis_tvalid && window_m_axis_tready) begin
            x_cnt <= (x_cnt == IMG_W - WINDOW_W) ? 0 : x_cnt + 1;
            if(x_cnt == IMG_W - WINDOW_W)
                y_cnt <= (y_cnt == IMG_H - WINDOW_H) ? 0 : y_cnt + 1;
        end
    end

    // read and verify output
    logic [DATA_W - 1 : 0] expected [WINDOW_H][WINDOW_W];
    logic [2 : 0] s_axis_tvalid_seq = 'x;
    logic [2 : 0] m_axis_tready_seq = 'x;
    initial begin
        @(posedge clk iff resetn);
        @(posedge clk iff window_m_axis_tvalid);    // test if DUT isn't waiting for downstream ready
        forever begin
            window_m_axis_tready <= 0;
            while($urandom()%5 == 0) @(posedge clk);
            window_m_axis_tready <= 1;
            @(posedge clk iff window_m_axis_tvalid);

            for(int r = 0; r < WINDOW_H; r++) begin
                for(int c = 0; c < WINDOW_W; c++) begin
                    expected[r][c] = img[y_cnt + r][x_cnt + c];
                end
            end
            assert(window_m_axis_tdata === expected) else begin
                $error("Data mismatch at window position (x, y) = (%d, %d)", x_cnt, y_cnt);
                $stop;
            end
            assert(window_m_axis_tlast == (y_cnt == IMG_H - WINDOW_H && x_cnt == IMG_W - WINDOW_W)) else begin
                $error("TLast mismatch at window position (x, y) = (%d, %d)", x_cnt, y_cnt);
                $stop;
            end
            if(x_cnt == IMG_W - WINDOW_W && y_cnt == IMG_H - WINDOW_H) begin
                $display("ALL PASS. Finished.");
                $finish;
            end
        end
    end

    // always_ff @(posedge clk) begin
    //     s_axis_tvalid_seq <= {s_axis_tvalid_seq[1 : 0], features_m_axis_tvalid};
    //     m_axis_tready_seq <= {m_axis_tready_seq[1 : 0], window_m_axis_tready};
    // end

    // wire s_trig = s_axis_tvalid_seq == 3'b101;
    // wire m_trig = m_axis_tready_seq == 3'b011;
    // wire sequence_trigger = s_axis_tvalid_seq == 3'b101 && m_axis_tready_seq == 3'b011;

endmodule: swu_tb