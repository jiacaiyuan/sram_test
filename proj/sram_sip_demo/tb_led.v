module tb_led();
reg clk,rst_n;
reg [31:0]slv_reg1,slv_reg2;
wire [31:0] slv_reg0;
wire led_0,led_1,led_2,led_3,clk_out;
led u_led
(
	.CLK(clk),
	.RSTn(rst_n),
	.slv_reg0(slv_reg0),
	.slv_reg1(slv_reg1),
	.slv_reg2(slv_reg2),
	.led_0(led_0),
	.led_1(led_1),
	.led_2(led_2),
	.led_3(led_3),
	.clk_out(clk_out)
);
initial
begin
	rst_n=1'b1;
	clk=1'b0;
	#2 rst_n=1'b0;
	#10 rst_n=1'b1;
end
always #5 clk=!clk;
initial
begin
	#100;
	#8
	slv_reg2=32'h00_00_00_00;
	slv_reg1=32'h00_00_00_00;
	#100;//test led_2 
	slv_reg2=32'h00_00_ff_ff;
	#100;
	slv_reg2=32'hc1_00_00_00;
	#100;
	slv_reg2=32'h00_00_ff_ff;
	#100;//test led_1
	slv_reg1=32'b1;
	#100;
	slv_reg1=32'b0;
	#100;//test slv_reg0
	slv_reg1=32'h2;
	#100;
	slv_reg2=32'h2;
	#100;
	$stop();
end
endmodule






