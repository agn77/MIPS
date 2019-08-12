`timescale 1ns / 1ps

module main(input clk, reset,
				output [31:0] WriteData, adr,
				output MemWrite);
				
wire [31:0] readData;

mips mips(clk, reset, adr, WriteData, MemWrite, readData);

mem mem(clk, MemWrite, adr, WriteData, readData);

endmodule
