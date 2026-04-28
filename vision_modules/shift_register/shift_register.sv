module shift_register #(
    parameter WIDTH = 8,
    parameter DELAY = 4
)
(
    input  logic clk,
    input  logic resetn,

    input  logic                    shift_en,
    input  logic [WIDTH - 1 : 0]    data_in,
    output logic [WIDTH - 1 : 0]    data_out  
);
    localparam DEPTH = DELAY + 1;

    typedef logic [$clog2(DEPTH) - 1 : 0]   ptr_t;
    typedef logic [WIDTH - 1 : 0]           data_t;

    data_t  mem [DEPTH];
    ptr_t   wr_ptr = 0;
    ptr_t   rd_ptr = 1;

    always_ff @(posedge clk) begin
        if(shift_en) begin
            data_out <= mem[rd_ptr];
            mem[wr_ptr] <= data_in;
        end
    end

    always_ff @(posedge clk) begin
        if(!resetn) begin
            wr_ptr <= 0;
            rd_ptr <= 1;
        end
        else if(shift_en) begin
            wr_ptr <= (wr_ptr == DELAY - 1) ? 0 : wr_ptr + 1;
            rd_ptr <= (rd_ptr == DELAY - 1) ? 0 : rd_ptr + 1;
        end
    end

endmodule: shift_register