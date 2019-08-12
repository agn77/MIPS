`timescale 1ns / 1ps

module mips(input clk, reset,
				output [31:0] adr, WriteData,
				output MemWrite,
				input [31:0] readData);
				
wire zero, pcEnable, IRWrite, RegWrite, alusrca, iord, MemtoReg, regDST;
wire [1:0] alusrcb, pcsrc;
wire [2:0] alucontrol; 
wire [5:0] op, funct;

controller c(clk, reset, op, funct, zero, pcEnable, MemWrite, 
IRWrite, RegWrite, alusrca, iord, MemtoReg, regDST, alusrcb, pcsrc, alucontrol);

datapath dp(clk, reset, pcEnable, IRWrite, RegWrite, alusrca, iord, MemtoReg,regDST, 
alusrcb, pcsrc, alucontrol, op, funct, zero, adr, WriteData, readData);

endmodule
