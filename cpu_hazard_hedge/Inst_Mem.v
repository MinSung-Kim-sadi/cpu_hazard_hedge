module Inst_Mem(R_addr, inst);

    parameter data_size = 32;

    input [data_size-1:0] R_addr;
    output [data_size-1:0] inst;

    reg [data_size-1:0] inst;

    parameter mem_size = 100;

    reg [data_size/4-1:0] memory_8[0:400];
    reg [data_size-1:0] memory[0:mem_size-1];


    always @(R_addr) begin
        inst <= memory[R_addr >> 2];
    end

endmodule