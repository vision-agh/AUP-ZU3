module shift_register_tb;

    localparam WIDTH = 8;
    localparam DELAY = 4;

    logic clk = 0;
    always begin
        #1ns
        clk = !clk;
    end
    logic resetn = 0;
    initial begin
        #10ns
        resetn = 1;
    end

    logic [WIDTH - 1 : 0]   data_in;
    logic [WIDTH - 1 : 0]   data_out;
    logic                   shift_en;

    shift_register #(
        .WIDTH(WIDTH),
        .DELAY(DELAY)
    ) dut (
        .clk, .resetn,
        .data_in, .data_out, .shift_en
    );

    initial begin
        data_in = 'x;
        shift_en = 0;
        @(posedge clk iff resetn);

        for(int unsigned i = 0; i < 256; i++) begin
            while($urandom()%19 == 0) @(posedge clk);
            data_in <= i;
            shift_en <= 1;
            @(posedge clk);
            data_in <= 'x;
            shift_en <= 0;
        end
    end

endmodule: shift_register_tb