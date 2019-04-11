//Note:fit for versatility
//2019/1/28
//jcyuan 
//version_4
`define CNT_NUM 32'h1
`define ENA 1'b0
`define DISENA 1'b1
`define DATA_W 8
`define ADDR_W 10 
`define ADDR_L 1024 //need to fit for ADDR_W
`define L_ADDR 10'h400 //need to fit for ADDR_W
//      the AXI bus register = 32 bits
module sram_ctrl
(
//system port
clk,reset_n,
//bus interface
outp_data,outp_addr,status,enable,send,sta_addr,tim_cfg,op_cfg,
//sram interface
s_qdata,s_cen,s_wen,s_oen,s_ddata,s_addr,s_clk,
//led output
led_0,led_1,led_2,led_3
);
input clk,reset_n;
input [31:0] enable,send,sta_addr,tim_cfg,op_cfg;
output [31:0] outp_data,outp_addr,status;

input [`DATA_W-1:0] s_qdata;
output [`DATA_W-1:0] s_ddata;
output [`ADDR_W-1:0] s_addr;
output s_cen,s_wen,s_oen,s_clk;

output led_1,led_2,led_3,led_0; 

wire clk,reset_n;
wire [31:0] enable,send,sta_addr,tim_cfg,op_cfg;
reg  [31:0] outp_data,outp_addr,led_cnt;

wire [`DATA_W-1:0] s_qdata;
reg  [`DATA_W-1:0] s_ddata;
reg  [`ADDR_W-1:0] s_addr;
wire [31:0] status;
reg s_cen,s_wen,s_oen,led_2,led_3;
wire s_clk;
//read caching region
reg [`DATA_W-1:0] inner_reg[0:`ADDR_L-1];
reg [7:0]c_state,n_state;

reg [31:0] inner_op_cfg,inner_send,inner_sta_addr,inner_tim_cfg,inc_addr;
wire ena,cmd,inc_dec,cyc,e_overflow,f_overflow,led_0,led_1;
reg chg_flag;
reg [`ADDR_W-1:0] addr;
reg [`DATA_W-1:0] data;
parameter
		CONFIG=8'b0000_0001,
		IDLE=8'b0000_0010,
		READ=8'b0000_0100,
		WRITE=8'b0000_1000,
		UPDATE=8'b0001_0000,
		ERROR=8'b1111_1111;


assign s_clk=clk;//the clk of sram is the same of sram_ctrl
assign ena=enable[0];
assign cmd=enable[1];//1'b0: write 1'b1:read
assign inc_dec=inner_op_cfg[1];//1'b0: inc 1'b1: dec
assign cyc=inner_op_cfg[0]; //1'b0: don't cycle 1'b1:cycle
assign e_overflow=((inner_sta_addr-inc_addr)>=32'hffff_ffff)?1'b1:1'b0;        //empty overflow
assign f_overflow=((inner_sta_addr+inc_addr)>=`ADDR_L)?1'b1:1'b0;             //full overflow
assign led_0=1'b1;
assign led_1=1'b0;
assign status=c_state|(e_overflow<<9)|(f_overflow<<10)|32'b0;

always@(posedge clk)
begin
	if(reset_n==1'b0)
		c_state<=CONFIG;
	else
		c_state<=n_state;
end


always@(*)
begin
	n_state=c_state;
	case(c_state)
	CONFIG:
	begin
		if(ena==1'b1)
			n_state=IDLE;
		else
			n_state=CONFIG;
	end
	IDLE:
	begin
		if(ena==1'b0)
			n_state=CONFIG;
		else
		begin
			if((chg_flag==1'b1)|(send!=inner_send))
			begin
				if(cmd==1'b0)//write
					n_state=WRITE;
				else//cmd=1'b1 //read
					n_state=READ;
			end
			else
			begin
				n_state=IDLE;
			end
		end
	end
	WRITE:
	begin
		if(inc_addr==inner_tim_cfg)
			n_state=UPDATE;
		else
			n_state=WRITE;
	end
	UPDATE:
	begin
		if(inc_addr>=16'b100_0000_0001)
			n_state=IDLE;
		else
			n_state=UPDATE;
	end
	READ:
	begin
		n_state=IDLE;
	end
	default:
	begin
		n_state=CONFIG;
	end
	endcase
end

always@(posedge clk)
begin
	s_cen<=s_cen;
	s_oen<=s_oen;
	s_wen<=s_wen;
	s_ddata<=s_ddata;
	s_addr<=s_addr;
	outp_addr<=outp_addr;
	outp_data<=outp_data;
	inner_op_cfg<=inner_op_cfg;
	inner_sta_addr<=inner_sta_addr;
	inner_tim_cfg<=inner_tim_cfg;
	case(c_state)
		CONFIG:
		begin
			chg_flag=1'b1;
			s_cen<=`DISENA;
			s_oen<=`DISENA;
			s_wen<=`DISENA;
			inner_sta_addr<=(sta_addr<<(32-`ADDR_W))>>(32-`ADDR_W);//avoid overflow
			inner_op_cfg<=op_cfg;
			if(op_cfg[0]==1'b0)//don't cycle
			begin
				if(op_cfg[1]==1'b0)//inc
				begin
					if((`ADDR_L-sta_addr-1)<tim_cfg)//tim_cfg==0---1 time
						inner_tim_cfg<=`ADDR_L-sta_addr-1;
					else
						inner_tim_cfg<=tim_cfg;
				end
				else//dec
				begin
					if(sta_addr<tim_cfg)
						inner_tim_cfg<=sta_addr;
					else
						inner_tim_cfg<=tim_cfg;
				end
			end
			else
			begin
				if(tim_cfg>=`ADDR_L)
					inner_tim_cfg<=`ADDR_L-1;
				else
					inner_tim_cfg<=tim_cfg;
			end
		end
		IDLE:
		begin
			inner_send<=send;
			addr<=send[`ADDR_W-1:0];
			data<=send[`DATA_W-1:0];
			inc_addr<=32'b0;
			s_cen<=`ENA;
			s_wen<=`DISENA;
			s_oen<=`DISENA;
			chg_flag<=1'b0;
			inc_addr<=32'b0;
		end
		READ:
		begin
			s_wen<=`DISENA;
			s_oen<=`ENA;
			outp_addr<=addr|32'b0;
			outp_data<=inner_reg[addr];
		end
		WRITE:
		begin
			s_oen<=`DISENA;
			s_wen<=`ENA;
			s_ddata<=data;
			if(inc_addr==inner_tim_cfg)
			begin
				inc_addr<=32'b0;//for update to use
			end
			else
			begin
				inc_addr<=inc_addr+1;

			end
			case({cyc,inc_dec})
			2'b00:s_addr<=inner_sta_addr+inc_addr;//inc-nocycle
			2'b01:s_addr<=inner_sta_addr-inc_addr;//dec-nocycle
			2'b10://inc-cycle
			begin
				if(f_overflow)
					s_addr<=inner_sta_addr+inc_addr-`ADDR_L;
				else
					s_addr<=inner_sta_addr+inc_addr;
			end
			2'b11://dec-cycle
			begin
				if(e_overflow)
					//s_addr<=`ADDR_L-(32'hffff_ffff-(inner_sta_addr-inc_addr)+1);//ok but calc much
					s_addr<=`L_ADDR-(inc_addr-inner_sta_addr);
				else
					s_addr<=inner_sta_addr-inc_addr;
			end
			default:
				s_addr<=inner_sta_addr+inc_addr;
			endcase
		end
		UPDATE:
		begin
			s_oen<=`ENA;
			s_wen<=`DISENA;
			if(inc_addr>=32'b100_0000_0001)
				inc_addr<=32'b0;//for update to use
			else
				inc_addr<=inc_addr+1;
			s_addr<=inc_addr;
			inner_reg[inc_addr-2]<=s_qdata;
		end
	endcase
end



always@(posedge clk)
begin
	if(reset_n==1'b0)
	begin
		led_cnt<=32'b0;
	end
	else
	begin
		if(led_cnt==`CNT_NUM)
			led_cnt<=32'b0;
		else
			led_cnt<=led_cnt+1;
	end
end

always@(posedge clk)
begin
	if(reset_n==1'b0)
	begin
		led_2<=1'b1;
		led_3<=1'b0;
	end
	else
	begin
		if(led_cnt==`CNT_NUM)
		begin
			led_2<=~led_2;
			led_3<=~led_3;
		end
		else
		begin
			led_2<=led_2;
			led_3<=led_3;
		end
	end
end


endmodule



