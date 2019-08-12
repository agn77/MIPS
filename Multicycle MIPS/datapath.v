`timescale 1ns / 1ps

module datapath(input clk, reset,
					 input pcEnable, IRWrite,
					 input RegWrite,
					 input alusrca, iord, MemtoReg, regDST,
					 input [1:0] alusrcb, pcsrc,
					 input [2:0] alucontrol,
					 output [5:0] op, funct,
					 output zero,
					 output [31:0] adr, WriteData,
					 input  [31:0] ReadData);
					 
// Datapath signals 
wire [4:0] WriteReg;
wire [31:0] pcnext, pc;
wire [31:0] instr, data, srca, srcb;
wire [31:0] a;
wire [31:0] aluresult, aluout;
wire [31:0] signimm; // sign-extended immediate
wire [31:0] signimmsh; // sign-extended immediate & shift left by 2
wire [31:0] wd3, rd1, rd2;

// op and funct fields to controller
assign op = instr[31:26];
assign funct = instr[5:0];

//datapth
flopenr #(32) pcreg(clk, reset, pcEnable, pcnext, pc);
mux2    #(32) adrmux(pc, aluout,iord, adr);
flopenr #(32) instrreg(clk, reset, IRWrite, ReadData, instr);

//assign adr = iord ? aluout : pc;

flopr   #(32) datareg(clk, reset, ReadData, data);
mux2    #(5)  regdstmux(instr[20:16], instr[15:11], regDST, WriteReg);

//assign wd3 = MemtoReg ? data : aluout;/* Assign the value to write into the register file on datapath */
//assign writereg = regDST ? instr[15:11] : instr[20:16];  /* Assign the A3 value going into the register file */ 

mux2    #(32) wdmux(aluout, data, MemtoReg, wd3);
regfile		     rf(clk, RegWrite, instr[25:21], instr[20:16], WriteReg, wd3, rd1, rd2);
signext			  se(instr[15:0], signimm);
sl2              immsh(signimm, signimmsh);
flopr   #(32) areg(clk, reset, rd1, a);
flopr   #(32) breg(clk, reset, rd2, WriteData);
mux2    #(32) srcamux(pc, a, alusrca, srca);
mux4    #(32) srcbmux(WriteData, 32'b100, signimm, signimmsh, alusrcb, srcb);
//assign srca = alusrca ? a : pc;
alu               alu(srca, srcb, alucontrol, aluresult, zero);
flopr   #(32) alureg(clk, reset, aluresult, aluout);
mux3    #(32) pcmux(aluresult, aluout, {pc[31:28], instr[25:0], 2'b00}, pcsrc, pcnext);


endmodule
