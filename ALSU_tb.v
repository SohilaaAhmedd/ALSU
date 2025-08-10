module ALSU_tb();

reg clk,rst,cin,serial_in,red_op_A,
red_op_B,bypass_A,bypass_B,direction;

reg [2:0] A,B,opcode;
reg [5:0] out_exp;
wire [15:0] leds_dut;
wire [5:0] out_dut;

//DUT instantiation
ALSU DUT(clk,rst,A,B,cin,serial_in,red_op_A,red_op_B,
	opcode,bypass_A,bypass_B,direction,leds_dut,out_dut);

//clk generation
initial begin
	clk = 1'b0;
	forever
		#1 clk = ~clk;
end

//test
integer i;
initial begin
	rst = 1;
	cin = 0;
	serial_in = 0;
	red_op_A = 0;
	red_op_B = 0;
	bypass_A = 0;
	bypass_B = 0;
	direction = 0;
	opcode = 0;
	A = 0;
	B = 0;
	@(negedge clk);
	if(out_dut && (leds_dut != 16'b0)) begin
		$display("error");
		$stop;
	end
	else begin
		$display("Asynchronous rst Functionality validated");
	end
	rst = 0;
	bypass_A = 1;
	bypass_B = 1;
	for(i=0;i<10;i=i+1) begin
		A = $random;
		B = $random;
		opcode = $urandom_range(0,5);
		@(negedge clk);
		@(negedge clk);
		if(out_dut != A) begin
			$display("error");
			$stop;
		end
		else begin
			$display("Bypass Functionality validated");
		end
	end
	bypass_A = 0;
	bypass_B = 0;
	opcode = 0;
	for(i=0;i<10;i=i+1) begin
		A = $random;
		B = $random;
		red_op_A = $random;
		red_op_B = $random;
		@(negedge clk);
		@(negedge clk);
		case({red_op_A,red_op_B})
			2'b00: out_exp = A & B;
			2'b10: out_exp = &A;
			2'b01: out_exp = &B;
			2'b11: out_exp = &A;
		endcase
		if(out_dut != out_exp) begin
			$display("error");
			$stop;
		end
		else begin
			$display("opcode 0 Functionality validated");
		end
	end
	opcode = 1;
	for(i=0;i<10;i=i+1) begin
		A = $random;
		B = $random;
		red_op_A = $random;
		red_op_B = $random;
		@(negedge clk);
		@(negedge clk);
		case({red_op_A,red_op_B})
			2'b00: out_exp = A ^ B;
			2'b10: out_exp = ^A;
			2'b01: out_exp = ^B;
			2'b11: out_exp = ^A;
		endcase
		if(out_dut != out_exp) begin
			$display("error");
			$stop;
		end
		else begin
			$display("opcode 1 Functionality validated");
		end
	end
	opcode = 2;
	red_op_A = 0;
	red_op_B = 0;
	for(i=0;i<10;i=i+1) begin
		A = $random;
		B = $random;
		cin = $random;
		@(negedge clk);
		@(negedge clk);
		out_exp = A + B + cin;
		if(out_dut != out_exp) begin
			$display("error");
			$stop;
		end
		else begin
			$display("opcode 2 Functionality validated");
		end
	end
	opcode = 3;
	for(i=0;i<10;i=i+1) begin
		A = $random;
		B = $random;
		@(negedge clk);
		@(negedge clk);
		out_exp = A * B;
		if(out_dut != out_exp) begin
			$display("error");
			$stop;
		end
		else begin
			$display("opcode 3 Functionality validated");
		end
	end
	opcode = 4;
	for(i=0;i<10;i=i+1) begin
		A = $random;
		B = $random;
		serial_in = $random;
		direction = $random;
		if (direction == 1) begin
			out_exp = {out_exp[4:0],serial_in};
		end
		else if (direction == 0) begin
			out_exp = {serial_in,out_exp[5:1]};
		end
		@(negedge clk);
		if(out_dut != out_exp) begin
			$display("error");
			$stop;
		end
		else begin
			$display("opcode 4 Functionality validated");
		end
	end
	opcode = 5;
	for(i=0;i<10;i=i+1) begin
		A = $random;
		B = $random;
		serial_in = $random;
		direction = $random;
		if (direction == 1) begin
			out_exp = {out_exp[4:0],out_exp[5]};
		end
		else if (direction == 0) begin
			out_exp = {out_exp[0],out_exp[5:1]};
		end
		@(negedge clk);
		if(out_dut != out_exp) begin
			$display("error");
			$stop;
		end
		else begin
			$display("opcode 5 Functionality validated");
		end
	end
	$stop;
end

endmodule