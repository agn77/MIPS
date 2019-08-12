`timescale 1ns / 1ps

module alu(
	input [31:0] srca,	
	input [31:0] srcb,	
	input [2:0] alucontrol, 
	output [31:0] aluout,
	output zero
	);
	
	reg [31:0] aluResult;
	assign aluout = aluResult;
	

always @(srca, srcb, alucontrol)

	case (alucontrol)
		3'b000 : aluResult <= srca & srcb;	//and
		3'b001 : aluResult <= srca | srcb;	//or
		3'b010 : aluResult <= srca + srcb;	//add
		3'b100 : aluResult <= srca & ~srcb;	//nand
		3'b101 : aluResult <= srca | ~srcb;	//nor
	   3'b110 : aluResult <= srca - ~srcb;	//sub
		3'b111 : aluResult <= (srca < srcb) ? 1: 0;	//slt
		default : aluResult <= 32'bxxx;
		
	endcase
		
		assign zero = !(|aluResult);


endmodule 
