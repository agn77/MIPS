`timescale 1ns / 1ps

module maindec(input clk, reset, 
					input [5:0] op,
					output pcWrite, MemWrite, IRWrite, RegWrite,
					output alusrca, branch, iord, MemtoReg, regDST,
					output [1:0] alusrcb, pcsrc,
					output [1:0] aluop);
					
reg [4:0] state, nextstate;
reg [14:0] controls;


parameter FETCH   = 5'b00000; // State 0
parameter DECODE  = 5'b00001; // State 1
parameter MEMADR  = 5'b00010; // State 2
parameter MEMRD   = 5'b00011; // State 3
parameter MEMWB   = 5'b00100; // State 4
parameter MEMWR   = 5'b00101; // State 5
parameter RTYPEEX = 5'b00110; // State 6
parameter RTYPEWB = 5'b00111; // State 7
parameter BEQEX   = 5'b01000; // State 8
parameter ADDIEX  = 5'b01001; // State 9
parameter ADDIWB  = 5'b01010; // State A
parameter JEX     = 5'b01011; // State B

//op codes
parameter LW    = 6'b100011; // LW
parameter SW    = 6'b101011; // SW
parameter RTYPE = 6'b000000; // R-Type
parameter BEQ   = 6'b000100; // BEQ
parameter ADDI  = 6'b001000; // ADDI
parameter J     = 6'b000010; // J

// state register
always @(posedge clk or posedge reset)
	if(reset) 
		state <= FETCH;
	else state <= nextstate;


	
// next state logic
always@(*)
	case(state)
	FETCH: nextstate <= DECODE;
	DECODE: case(op)
				LW:	   nextstate <= MEMADR;
				SW:	   nextstate <= MEMADR;
				RTYPE:	nextstate <= RTYPEEX;
				BEQ:	   nextstate <= BEQEX;
				ADDI: 	nextstate <= ADDIEX;
				J:	      nextstate <= JEX;
				// should never happen
				default: nextstate <= FETCH;
				endcase
				
	MEMADR: case(op)
				LW:	   nextstate <= MEMRD;
				SW:	   nextstate <= MEMWR;
				// should never happen
				default: nextstate <= FETCH;
				endcase
				
	MEMRD:	nextstate <= MEMWB;
	MEMWB:	nextstate <= FETCH;
	MEMWR:	nextstate <= FETCH;
	RTYPEEX: nextstate <= RTYPEWB;
	RTYPEWB: nextstate <= FETCH;
	BEQEX:   nextstate <= FETCH;
	ADDIEX:	nextstate <= ADDIWB;
	ADDIWB:  nextstate <= FETCH;
	JEX:	   nextstate <= FETCH;
	// should never happen
	default: nextstate <= FETCH;
	endcase
	
	// output logic
	assign {pcWrite, MemWrite, IRWrite, RegWrite, alusrca, branch, iord,
	MemtoReg, regDST, alusrcb, pcsrc, aluop} = controls;
	
	always @(*)
	case(state)
		FETCH:	controls <= 15'b1010_00000_0100_00;
		DECODE:  controls <= 15'b0000_00000_1100_00;
		MEMADR:  controls <= 15'b0000_10000_1000_00;
		MEMRD:   controls <= 15'b0000_00100_0000_00;
		MEMWB:   controls <= 15'b0001_00010_0000_00;
		MEMWR:   controls <= 15'b0100_00100_0000_00;
		RTYPEEX: controls <= 15'b0000_10000_0000_10;
		RTYPEWB: controls <= 15'b0001_00001_0000_00;
		BEQEX:   controls <= 15'b0000_11000_0001_01;
		ADDIEX:  controls <= 15'b0000_10000_1000_00;
		ADDIWB:  controls <= 15'b0001_00000_0000_00;
		JEX:     controls <= 15'b1000_00000_0010_00;
		default: controls <= 15'b0000_xxxxx_xxxx_xx;
		
	endcase

endmodule
