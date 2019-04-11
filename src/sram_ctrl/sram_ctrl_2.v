`define ENA 1'b0
`define DISENA 1'b1

module sram_ctrl
(
//system port
clk,reset_n,
//bus interface
cmd,outp_data,half,
//sram interface
s_qdata,s_cen,s_wen,s_oen,s_ddata,s_addr
);
input clk,reset_n;
input [31:0] cmd;

output [7:0] outp_data;
output half;
input [7:0] s_qdata;
output [7:0] s_ddata;
output [9:0] s_addr;
output s_cen,s_wen,s_oen;

reg [7:0] outp_data,s_ddata;
reg [9:0] s_addr,s_addr_reg;
reg s_cen,s_wen,s_oen,half;
wire clk,reset_n;
wire [7:0] s_qdata;
wire [31:0] cmd;


//cmd decode 
reg [15:0] addr;
reg [23:16] inp_data;
reg [31:24] operation;

//inner signal
reg [15:0] debug_state,c_state,n_state;
reg finish;
reg [9:0] addr_inc,cnt;
parameter 
		IDLE=16'hffff,
		SPLIT=16'h0000,
		W_ALL=16'h0001,
		R_ALL=16'h0002,
		W_ONE=16'h0004,
		R_ONE=16'h0008,
		W_A_0=16'h0010,
		W_A_1=16'h0020,
		W_A_5a=16'h0040,
		W_A_a5=16'h0080,
		INCREMENT=16'h0100,
		ERROR=16'hx;


//reset block
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

//operation7:1-all 0-one  ; operation6:1-write 0-read  ;operation[3:0]: type
always@(*)
begin
	case(c_state)
	IDLE:
		begin
			n_state=SPLIT;
		end
	SPLIT:
		begin
			if (operation[31:30]==2'b11)
				n_state=W_ALL;
			else if (operation[31:30]==2'b10)
				n_state=R_ALL;
			else if (operation[31:30]==2'b01)
				n_state=W_ONE;
			else if (operation[31:30]==2'b00)
				n_state=R_ONE;
			else
				n_state=IDLE;
		end
	W_ALL:
		begin
			if(operation[27:24]==4'b0001)
				n_state=W_A_0;
			else if (operation[27:24]==4'b0010)
				n_state=W_A_1;
			else if (operation[27:24]==4'b0100)
				n_state=W_A_5a;
			else if (operation[27:24]==4'b1000)
				n_state=W_A_a5;
			else
				n_state=IDLE;
		end
	R_ALL,W_A_0,W_A_1,W_A_5a,W_A_a5:
		begin
			if(finish==1'b1)
			begin
				n_state=IDLE;
			end
			else
				n_state=INCREMENT;
		end
	W_ONE,R_ONE:
		begin
			n_state=IDLE;
		end
	INCREMENT:
		begin
			case(debug_state)
			W_A_0: n_state=W_A_0;
			W_A_1: n_state=W_A_1;
			W_A_5a:n_state=W_A_5a;
			W_A_a5:n_state=W_A_a5;
			R_ALL:n_state=R_ALL;
			default:n_state=IDLE;
			endcase
		end
	default:
		begin
			n_state=IDLE;
		end
	endcase
end
		
always@(posedge clk)
begin
	operation<=operation;
	inp_data<=inp_data;
	addr<=addr;
	cnt<=cnt;
	finish<=finish;
	half<=half;
	s_cen<=s_cen;
	s_wen<=s_wen;
	s_oen<=s_oen;
	s_addr<=s_addr;
	s_ddata<=s_ddata;
	outp_data<=outp_data;
	case(c_state)
	IDLE:
		begin
			//operation7:1-all 0-one  ; operation6:1-write 0-read  ;operation[3:0]: type
			debug_state<=IDLE;
			operation<=cmd[31:24];
			inp_data<=cmd[23:16];
			addr<=cmd[15:0];
			s_cen<=`ENA;
			s_wen<=s_wen;
			s_oen<=s_oen;
			cnt<=10'b0;
			finish<=1'b0;
			half<=1'b0;
		end
	SPLIT:
		debug_state<=SPLIT;
	W_ALL:
		debug_state<=W_ALL;
	W_ONE:
		begin
			debug_state<=W_ONE;
			s_cen<=`ENA;
			s_wen<=`ENA;
			s_addr<=addr;
			s_ddata<=inp_data;
		end
	R_ALL:
		begin
			debug_state<=R_ALL;
			s_cen<=`ENA;
			s_oen<=`ENA;
			s_addr<=addr_inc;
			outp_data<=s_qdata;
		end
	R_ONE:
		begin
			debug_state<=R_ONE;
			s_cen<=`ENA;
			s_oen<=`ENA;
			s_addr<=addr;
			outp_data<=s_qdata;
		end
	W_A_0:
		begin
			debug_state<=W_A_0;
			s_cen<=`ENA;
			s_wen<=`ENA;
			s_addr<=addr_inc;
			s_ddata<=8'h00;
		end
	W_A_1:
		begin
			debug_state<=W_A_1;
			s_cen<=`ENA;
			s_wen<=`ENA;
			s_addr<=addr_inc;
			s_ddata<=8'hff;
		end
	W_A_5a:
		begin
			debug_state<=W_A_5a;
			s_cen<=`ENA;
			s_wen<=`ENA;
			s_addr<=addr_inc;
			s_ddata<=8'h5a;
		end
	W_A_a5:
		begin
			debug_state<=W_A_a5;
			s_cen<=`ENA;
			s_wen<=`ENA;
			s_addr<=addr_inc;
			s_ddata<=8'ha5;
		end
	INCREMENT:
		begin
			addr_inc<=cnt;
			if(cnt==10'b11_1111_1111)
			begin
				cnt<=10'b00_0000_0000;
				finish<=1'b1;
			end
			else if(cnt==10'b10_0000_0000)
			begin
				half<=1'b1;
				cnt<=cnt+1;
			end
			else
			begin
				cnt<=cnt+1;
			end
		end
	default:
		begin
			debug_state<=ERROR;
		end
	endcase
end
endmodule






