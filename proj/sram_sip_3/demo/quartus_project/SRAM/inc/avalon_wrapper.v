module avalon_wrapper (avalon_clk,clk,reset_n,chipselect,address,write,writedata,read,readdata,
					s_qdata,s_ddata,s_addr,s_cen,s_wen,s_oen,s_clk,led_0,led_1,led_2,led_3);
input clk,reset_n,chipselect,write,read,avalon_clk;
input [2:0] address;
input [31:0] writedata;
output [31:0] readdata;

input  [7:0] s_qdata;
output  [7:0] s_ddata;
output  [9:0] s_addr;
output  s_cen,s_wen,s_oen,s_clk,led_0,led_1,led_2,led_3;

wire [2:0] address;
wire [31:0] writedata;
reg [31:0] readdata;
wire clk,reset_n,chipselect,write,read;

wire [7:0] s_qdata;
wire [7:0] s_ddata;
wire [9:0] s_addr;
wire s_cen,s_wen,s_oen,s_clk,led_0,led_1,led_2,led_3;


reg [31:0] slv_reg0,slv_reg1,slv_reg2,slv_reg3,slv_reg4,slv_reg5,slv_reg6,slv_reg7;

always @(posedge avalon_clk or negedge reset_n)
begin
	if(!reset_n)
	begin
		slv_reg0<=32'b0;
		slv_reg1<=32'b0;
		slv_reg2<=32'b0;
		slv_reg3<=32'b0;
		slv_reg4<=32'b0;
		slv_reg5<=32'b0;
		slv_reg6<=32'b0;
		slv_reg7<=32'b0;
	end
	else
	begin
		if(write&chipselect)
		begin
			case(address)
				3'b000:slv_reg0<=writedata;
				3'b001:slv_reg1<=writedata;
				3'b010:slv_reg2<=writedata;
				3'b011:slv_reg3<=writedata;
				3'b100:slv_reg4<=writedata;
				3'b101:slv_reg5<=writedata;
				3'b110:slv_reg6<=writedata;
				3'b111:slv_reg7<=writedata;
				default:
				begin
					slv_reg0 <= slv_reg0;
					slv_reg1 <= slv_reg1;
					slv_reg2 <= slv_reg2;
					slv_reg3 <= slv_reg3;
					slv_reg4 <= slv_reg4;
					slv_reg5 <= slv_reg5;
					slv_reg6 <= slv_reg6;
					slv_reg7 <= slv_reg7;
				end
			endcase
		end
		slv_reg5<=outp_addr;
		slv_reg6<=outp_data;
		slv_reg7<=status;
	end
end

always @(*)
begin
	if(read&chipselect)
	begin
		case(address)
			3'b000:readdata=slv_reg0;
			3'b001:readdata=slv_reg1;
			3'b010:readdata=slv_reg2;
			3'b011:readdata=slv_reg3;
			3'b100:readdata=slv_reg4;
			3'b101:readdata=slv_reg5;
			3'b110:readdata=slv_reg6;
			3'b111:readdata=slv_reg7;
			default:
				begin
				readdata=0;
				end
		endcase
	end
end


//user add-----------------------------------------------------------------
wire [31:0] outp_data,outp_addr,status,enable,send,sta_addr,area_cfg,op_cfg;
assign sta_addr=slv_reg0;
assign area_cfg=slv_reg1;
assign op_cfg=slv_reg2;
assign send=slv_reg3;
assign enable=slv_reg4;

sram_ctrl u_sram_ctrl(
//system port
.clk(clk),
.reset_n(reset_n),
//bus interface
.outp_data(outp_data),
.outp_addr(outp_addr),
.status(status),
.enable(enable),
.send(send),
.sta_addr(sta_addr),
.area_cfg(area_cfg),
.op_cfg(op_cfg),
//sram interface
.s_qdata(s_qdata),
.s_cen(s_cen),
.s_wen(s_wen),
.s_oen(s_oen),
.s_ddata(s_ddata),
.s_addr(s_addr),
.s_clk(s_clk),
//led output
.led_0(led_0),
.led_1(led_1),
.led_2(led_2),
.led_3(led_3)

);
endmodule

