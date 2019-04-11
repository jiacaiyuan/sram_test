//Note:specical fit for 1024*8
//2019/1/11
//jcyuan 
//version_3
`define ENA 1'b0
`define DISENA 1'b1

module sram_ctrl
(
//system port
clk,reset_n,
//bus interface
cmd,outp_data,outp_addr,status,
//sram interface
s_qdata,s_cen,s_wen,s_oen,s_ddata,s_addr,s_clk
);
input clk,reset_n;

//Note: the data = 8 bits 
//      the addr = 10 bits
//      the AXI bus register = 32 bits

//cmd:[31:24]=operation [23:16]=inp_data [15:0]=inp_addr
//status:[7:0]=debug_state 8=change the cmd  9=finish once operation

input [31:0] cmd;
output [31:0] outp_data,outp_addr,status;

input [7:0] s_qdata;
output [7:0] s_ddata;
output [9:0] s_addr;
output s_cen,s_wen,s_oen,s_clk;

wire clk,reset_n;
wire [31:0] cmd;
reg  [31:0] outp_data,outp_addr,status;
wire [7:0] s_qdata;
reg  [7:0] s_ddata;
reg  [9:0] s_addr;
reg s_cen,s_wen,s_oen;
wire s_clk;
//read caching region
reg [7:0] inner_reg[0:1023];

//cmd decode 
reg [15:0] inp_addr;
reg [23:16] inp_data;
reg [31:24] operation;

//inner signal
reg [7:0] c_state,n_state;
reg [15:0] inc_addr;

parameter
		IDLE=8'b0000_0001,
		SPLIT=8'b0000_0010,//ready for which state to jump
		W_ALL=8'b0000_0100,//write all the sram the inp_data
		R_ALL=8'b0000_1000,//move the data to the caching region
		W_ONE=8'b0001_0000,//write the inp_data into the address of inp_addr in sram
		R_ONE=8'b0010_0000,//for read the inner caching region
		R_REG=8'b0100_0000,//read the data in the inner_reg 
		DEFAULT=8'b1000_0000,
		ERROR=8'b1111_1111;
parameter
		cmd_chg_resp=32'h0000_0100,//response to change the cmd enable
		cmd_finish_resp=32'h0000_0200;//response to finish the cmd enable
		
		
assign s_clk=clk;//the clk of sram is the same of sram_ctrl

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
	begin
		c_state<=IDLE;
	end
	else
	begin
		c_state<=n_state;
	end
end

always@(*)
begin
	case(c_state)
	IDLE:
		begin
			n_state=SPLIT;
		end
	SPLIT:
		begin
			if(operation==W_ALL)
				n_state=W_ALL;
			else if(operation==R_ALL)
				n_state=R_ALL;
			else if(operation==W_ONE)
				n_state=W_ONE;
			else if(operation==R_ONE)
				n_state=R_ONE;
			else if(operation==R_REG)
				n_state=R_REG;
			else
				n_state=ERROR;
		end
	W_ALL:
		begin
			if(inc_addr==16'b11_1111_1111)
			begin
				n_state=IDLE;
			end
			else
			begin
				n_state=c_state;
			end
		end
	R_ALL:
		begin
			if(inc_addr==16'b100_0000_0001)
			begin
				n_state=IDLE;
			end
			else
			begin
				n_state=c_state;
			end
		end
	W_ONE,R_ONE,R_REG,ERROR:
		begin
			n_state=IDLE;
		end
	default:
		begin
			n_state=IDLE;
		end
	endcase
end

always@(posedge clk)
begin
	status<=status;
	operation<=operation;
	inp_data<=inp_data;
	inp_addr<=inp_addr;
	s_cen<=s_cen;
	s_oen<=s_oen;
	s_wen<=s_wen;
	s_ddata<=s_ddata;
	s_addr<=s_addr;
	outp_addr<=outp_addr;
	outp_data<=outp_data;
	case(c_state)
	IDLE:
		begin
			status<=32'b0|IDLE;
			operation<=cmd[31:24];
			inp_data<=cmd[23:16];
			inp_addr<=cmd[15:0];
			s_cen<=`ENA;
			s_wen<=`DISENA;
			s_oen<=`DISENA;
			inc_addr<=16'b0;
		end
	SPLIT:
		begin
			if((operation==W_ALL)|(operation==W_ONE))
			begin
				s_wen<=`ENA;
				s_oen<=`DISENA;
			end
			else if((operation==R_ALL)|(operation==R_ONE))
			begin
				s_wen<=`DISENA;
				s_oen<=`ENA;
			end
			else
			begin//R_REG
				s_wen<=`DISENA;
				s_oen<=`DISENA;
			end
			status<=32'b0|SPLIT;
		end
	W_ALL:
		begin
			s_addr<=inc_addr;
			s_ddata<=inp_data;
			if(inc_addr==16'b11_1111_1111)
			begin
				inc_addr<=16'b0;
				status<=32'b0|W_ALL|cmd_finish_resp;
			end
			else if(inc_addr==16'b10_0000_0000)
			begin
				inc_addr<=inc_addr+1;
				status<=32'b0|W_ALL|cmd_chg_resp;
			end
			else
			begin
				inc_addr<=inc_addr+1;
				status<=32'b0|W_ALL;
			end
		end
	R_ALL:
		begin
			s_addr<=inc_addr;
			inner_reg[inc_addr-2]<=s_qdata;
			if(inc_addr>16'b100_0000_0001)
			begin
				inc_addr<=16'b0;
				status<=32'b0|R_ALL|cmd_finish_resp;
			end
			else if(inc_addr==16'b10_0000_0000)
			begin
				inc_addr<=inc_addr+1;
				status<=32'b0|R_ALL|cmd_chg_resp;
			end
			else
			begin
				inc_addr<=inc_addr+1;
				status<=32'b0|R_ALL;
			end
		end
	W_ONE:
		begin
			s_addr<=inp_addr;
			s_ddata<=inp_data;
			status<=32'b0|W_ONE|cmd_finish_resp|cmd_chg_resp;
		end
	R_ONE:
		begin
			s_addr<=inp_addr;
			outp_data<=s_qdata;
			outp_addr<=inp_addr;
			status<=32'b0|R_ONE|cmd_finish_resp|cmd_chg_resp;
		end
	R_REG:
		begin
			outp_data<=inner_reg[inp_addr];
			outp_addr<=inp_addr;
			status<=32'b0|R_REG|cmd_finish_resp|cmd_chg_resp;
		end
	ERROR:
		begin
			s_oen<=`DISENA;
			s_wen<=`DISENA;
			s_cen<=`DISENA;
			status<=32'b0|ERROR|cmd_finish_resp;
		end
	default:
		begin
			s_oen<=`ENA;
			s_wen<=`ENA;
			s_cen<=`ENA;
			status<=32'b0|DEFAULT;
		end
	endcase
end
endmodule



