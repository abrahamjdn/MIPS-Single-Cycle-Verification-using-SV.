module control_unit(
	input [5:0] Opcode,
	
	output reg RegDst, RegWrite, ALUSrc,
	output reg MemtoReg, MemWrite,
	output reg BEQ, BNE, Jump,
  	output reg[1:0] ALUOp
	);
	
	always @(*) begin
		case(Opcode)
			0: begin//R
            Jump		= 0;
				RegDst 		= 1;
				ALUSrc 		= 0;
				MemtoReg	= 0;
				RegWrite	= 1;
				MemWrite	= 0;
				BEQ			= 0;
				BNE			= 0;
				ALUOp		= 2;
			end
			35: begin //LW
            Jump		= 0;
				RegDst 		= 0;
				ALUSrc 		= 1;
				MemtoReg	= 1;
				RegWrite	= 1;
				MemWrite	= 0;
				BEQ			= 0;
				BNE			= 0;
				ALUOp		= 0;
			end
			43: begin //SW
            Jump		= 0;
				RegDst 		= 0;
				ALUSrc 		= 1;
				MemtoReg	= 0;
				RegWrite	= 0;
				MemWrite	= 1;
				BEQ			= 0;
				BNE			= 0;
				ALUOp		= 0;
			end
			4: begin //BEQ
            Jump		= 0;
				RegDst 		= 0;
				ALUSrc 		= 0;
				MemtoReg	= 0;
				RegWrite	= 0;
				MemWrite	= 0;
				BEQ			= 1;
				BNE			= 0;
				ALUOp		= 1;
			end
          	5: begin //BNE
            Jump		= 0;
				RegDst 		= 0;
				ALUSrc 		= 0;
				MemtoReg	= 0;
				RegWrite	= 0;
				MemWrite	= 0;
				BEQ			= 0;
				BNE			= 1;
				ALUOp		= 1;
			end
          	2: begin //JUMP
            Jump		= 1;
				RegDst 		= 0;
				ALUSrc 		= 0;
				MemtoReg	= 0;
				RegWrite	= 0;
				MemWrite	= 0;
				BEQ			= 0;
				BNE			= 0;
				ALUOp		= 0;
			end
		endcase
	end
endmodule