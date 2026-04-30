`timescale 1ns / 1ps

module binfile2axis #(
    parameter IMG_PATH = "",
    parameter height = 224,
    parameter width = 224,
    parameter FOLDING = 1,
    parameter channels = 3,
    parameter datawidth = 8,
    parameter TO_SEND = 1,
    parameter RANDOM_INTERRUPTS = 0,
    parameter ONE_IN_X_INTERRUPT_CHANCE = 20,

    localparam bytes_per_num = datawidth / 8,
    localparam TOTAL_BYTES = height * width * channels * bytes_per_num,
    localparam PARALLEL_BYTES = (channels / FOLDING) * bytes_per_num,
    localparam BYTES_CNT_WIDTH = $clog2(TOTAL_BYTES) + 1
)
(
    input logic clk,
    input logic resetn,
    
    //master axis interface
    output reg [(PARALLEL_BYTES * 8) - 1 : 0] m_axis_0_tdata = 0,
    output reg m_axis_0_tvalid = 0,
    input m_axis_0_tready,
    output reg [BYTES_CNT_WIDTH - 1 : 0] bytes_cnt = 0
); 

integer file;
string filepath = IMG_PATH;
string file_idx_s;
int len_filepath = filepath.len();

initial begin
    for(int unsigned frame = 0; frame < TO_SEND; frame++) begin
        m_axis_0_tdata = 'x;
        m_axis_0_tvalid = 0;
        @(posedge clk iff resetn);

        if(TO_SEND > 1)
        begin
            $sformat(file_idx_s, "%0d", frame);
            filepath = {filepath.substr(0, len_filepath-6), file_idx_s, ".bin"};
        end
        $display("FILEPATH %s", filepath);
        file = $fopen(filepath,"rb");
        
        for(int unsigned bytes_cnt = 0; bytes_cnt < TOTAL_BYTES; bytes_cnt += PARALLEL_BYTES) begin
            if(RANDOM_INTERRUPTS)
                while($urandom() % ONE_IN_X_INTERRUPT_CHANCE == 0) @(posedge clk);
            for(integer i = 0; i < PARALLEL_BYTES; i = i + 1)
                m_axis_0_tdata[(PARALLEL_BYTES-i)*8 - 1 -: 8] <= $fgetc(file);
            m_axis_0_tvalid <= 1;

            @(posedge clk iff m_axis_0_tready);
            m_axis_0_tdata <= 'x;
            m_axis_0_tvalid <= 0;
        end
    end
end

// assign m_axis_0_tvalid = !skip_header;

endmodule

