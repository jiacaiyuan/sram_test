//`define NUM   32'h05f5_0000
`define NUM   23'hf
module led
(
	CLK,
	RSTn,
	slv_reg0,
	slv_reg1,
	slv_reg2,
	led_0,
	led_1,
	led_2,
	led_3,
	clk_out
);
input CLK,RSTn;
input [31:0] slv_reg2,slv_reg1;
output [31:0] slv_reg0;

output led_0,led_1,led_2,led_3,clk_out;
wire [31:0]  slv_reg1,slv_reg2;
reg [31:0] slv_reg0;

reg led_0,led_1,led_2;
wire led_3,clk_out;

reg [31:0] inner_reg_1,inner_reg_2,cnt;

assign led_3=1'b1;
assign clk_out=CLK;


always@(posedge CLK)
begin
	if(RSTn==1'b0)
	begin
		slv_reg0<=32'h00_00_00_00;
	end
	else
	begin
		slv_reg0<=slv_reg1+slv_reg2;
	end
end

always@(posedge CLK)
begin
	if(RSTn==1'b0)
	begin
		inner_reg_1<=32'h0;
		inner_reg_2<=32'h0;
	end
	else
	begin
		inner_reg_1<=slv_reg1;
		inner_reg_2<=slv_reg2;
	end
end


always@(posedge CLK)
begin
	if(RSTn==1'b0)
	begin
		led_1<=1'b0;
		led_2<=1'b0;
	end
	else
	begin
		if (inner_reg_2>32'hc0_00_00_00)
		begin
			led_2<=1'b1;
		end
		else
		begin
			led_2<=1'b0;
		end
		if(inner_reg_1==32'h00_00_00_01)
		begin
			led_1<=1'b1;
		end
		else
		begin
			led_1<=1'b0;
		end
	end
end

always@(posedge CLK)
begin
	if(RSTn==1'b0)
	begin
		cnt<=32'h0;
	end
	else
	begin
		if(cnt>=`NUM)
		begin
			cnt<=32'h0;
		end
		else
		begin
			cnt<=cnt+1;
		end
	end
end

always@(posedge CLK)
begin
	if(RSTn==1'b0)
	begin
		led_0<=1'b0;
	end
	else
	begin
		if(cnt==`NUM)
		begin
			led_0<=~led_0;
		end
		else
		begin
			led_0<=led_0;
		end
	end
end

endmodule