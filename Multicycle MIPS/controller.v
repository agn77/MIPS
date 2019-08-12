`timescale 1ns / 1ps

module controller(input clk, reset,
						input [5:0] op, funct,
						input zero, 
						output pcEnable, MemWrite, IRWrite, RegWrite,
						output alusrca, iord, MemtoReg, regDST,
						output [1:0] alusrcb, 
						output [1:0] pcsrc,
						output [2:0] alucontrol);
wire [1:0] aluop;
wire branch, pcWrite;

assign pcEnable = (pcWrite | (branch & zero));

maindec md(clk, reset, op, pcWrite, MemWrite, IRWrite, RegWrite, 
alusrca, branch, iord, MemtoReg, regDST, alusrcb, pcsrc, aluop);

aludec ad(funct, aluop, alucontrol);

endmodule
