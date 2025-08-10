module ALSU(clk,rst,A,B,cin,serial_in,red_op_A,red_op_B,
	opcode,bypass_A,bypass_B,direction,leds,out);

parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";

input clk,rst,cin,serial_in,red_op_A,red_op_B,bypass_A,bypass_B,direction;
input [2:0] A,B,opcode;
output reg [15:0] leds;
output reg [5:0] out;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		out <= 0;
		leds <= 0;
	end
	else if (bypass_A || bypass_B) begin
		case({bypass_B,bypass_A})
			2'b00: out <= 0;
			2'b01: out <= A;
			2'b10: out <= B;
			2'b11: begin
				if(INPUT_PRIORITY == "A")
					out <= A;
	 			 else
					out <= B;
	 			 end
		endcase
	end
	else begin
		if(opcode == 3'b000) begin
			case({red_op_A,red_op_B})
				2'b00: out <= A & B;
				2'b10: out <= &A;
				2'b01: out <= &B;
				2'b11: begin
					if(INPUT_PRIORITY == "A")
						out <= &A;
					else
						out <= &B;
					end
			endcase
		end
		else if(opcode == 3'b001) begin
			case({red_op_A,red_op_B})
				2'b00: out <= A ^ B;
				2'b10: out <= ^A;
				2'b01: out <= ^B;
				2'b11: begin
					if(INPUT_PRIORITY == "A")
						out <= ^A;
					else
						out <= ^B;
					end
			endcase
		end
		else if(opcode == 3'b010) begin
			if (red_op_A || red_op_B) begin
				leds <= ~leds;
				case({bypass_B,bypass_A})
					2'b00: out <= 0;
					2'b01: out <= A;
					2'b10: out <= B;
					2'b11: begin
					 if(INPUT_PRIORITY == "A")
						out <= A;
	 				 else
						out <= B;
	 				 end
				endcase
			end
			else begin
				if (FULL_ADDER == "ON") begin
					out <= A + B + cin;
				end
				else if (FULL_ADDER == "OFF") begin
					out <= A + B;
				end
			end
		end
		else if(opcode == 3'b011) begin
			if (red_op_A || red_op_B) begin
				leds <= ~leds;
				case({bypass_B,bypass_A})
					2'b00: out <= 0;
					2'b01: out <= A;
					2'b10: out <= B;
					2'b11: begin
					 if(INPUT_PRIORITY == "A")
						out <= A;
	 				 else
						out <= B;
	 				 end
				endcase
			end
			else begin
				out <= A * B;
			end
		end
		else if(opcode == 3'b100) begin
			if (red_op_A || red_op_B) begin
				leds <= ~leds;
				case({bypass_B,bypass_A})
					2'b00: out <= 0;
					2'b01: out <= A;
					2'b10: out <= B;
					2'b11: begin
					 if(INPUT_PRIORITY == "A")
						out <= A;
	 				 else
						out <= B;
	 				 end
				endcase
			end
			else begin
				if (direction == 1) begin
					out <= {out[4:0],serial_in};
				end
				else if (direction == 0) begin
					out <= {serial_in,out[5:1]};
				end
			end
		end
		else if(opcode == 3'b101) begin
			if (red_op_A || red_op_B) begin
				leds <= ~leds;
				case({bypass_B,bypass_A})
					2'b00: out <= 0;
					2'b01: out <= A;
					2'b10: out <= B;
					2'b11: begin
					 if(INPUT_PRIORITY == "A")
						out <= A;
	 				 else
						out <= B;
	 				 end
				endcase
			end
			else begin
				if (direction == 1) begin
					out <= {out[4:0],out[5]};
				end
				else if (direction == 0) begin
					out <= {out[0],out[5:1]};
				end
			end
		end
		else begin
			leds <= ~leds;
			case({bypass_B,bypass_A})
				2'b00: out <= 0;
				2'b01: out <= A;
				2'b10: out <= B;
				2'b11: begin
				 if(INPUT_PRIORITY == "A")
					out <= A;
	 			 else
					out <= B;
	 			 end
			endcase
		end
	end
end

endmodule
