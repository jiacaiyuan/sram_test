`define ENA 1'b0
`define DISENA 1'b1

module sram_ctrl
(
//system port
clk,reset_n,
//bus interface
cmd,addr,inp_data,outp_data,busy,
//sram interface
s_qdata,s_cen,s_wen,s_oen,s_ddata,s_addr
);
input clk,reset_n;
input [7:0] cmd,inp_data;
input [9:0] addr;
output busy;
output [7:0] outp_data;

input [7:0] s_qdata;
output [7:0] s_ddata;
output [9:0] s_addr;
output s_cen,s_wen,s_oen;

reg [7:0] outp_data,s_ddata,outp_data_reg,s_ddata_reg;
reg [9:0] s_addr,s_addr_reg;
reg busy,s_cen,s_wen,s_oen,s_cen_reg,s_oen_reg,s_wen_reg;
wire clk,reset_n;
wire [7:0] cmd,inp_data,s_qdata;
wire [9:0] addr;


reg [7:0] operation;
reg [9:0] cnt;



parameter 
		NONE=8'b1111_1111,
		 W_ALL_0=8'b0100_0001,
		 W_ALL_1=8'b0100_0010,
		W_ALL_5a=8'b0100_0100,
		W_ALL_a5=8'b0100_1000,
		   R_ALL=8'b0000_0000,
		   W_ONE=8'b1100_0000,
		   R_ONE=8'b1000_0000;
//7:all 6:W/R 3:0:type


//reset block
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
	begin
		outp_data<=8'b0;
		s_ddata<=8'b0;
		s_addr<=8'b0;
		s_cen<=`DISENA;
		s_wen<=`DISENA;
		s_oen<=`DISENA;
		busy<=1'b0;
		cnt<=10'b0;
	end
	else
	begin
		outp_data<=outp_data_reg;
		s_ddata<=s_ddata_reg;
		s_addr<=s_addr_reg;
		s_cen<=s_cen_reg;
		s_wen<=s_wen_reg;
		s_oen<=s_oen_reg;
		busy<=busy;
	end
end

always@(posedge clk)
begin
	if((cmd==W_ALL_0)&&(busy==1'b0))
	begin
		operation<=W_ALL_0;
		busy<=1'b1;
	end
	else if ((cmd==W_ALL_1)&&(busy==1'b0))
	begin
		operation<=W_ALL_1;
		busy<=1'b1;
	end
	else if ((cmd==W_ALL_5a)&&(busy==1'b0))
	begin
		operation<=W_ALL_5a;
		busy<=1'b1;
	end
	else if ((cmd==W_ALL_a5)&&(busy==1'b0))
	begin
		operation<=W_ALL_a5;
		busy<=1'b1;
	end
	else if ((cmd==R_ALL)&&(busy==1'b0))
	begin
		operation<=R_ALL;
		busy<=1'b1;
	end
	else if ((cmd==W_ONE)&&(busy==1'b0))
	begin
		operation<=W_ONE;
		busy<=1'b1;
	end
	else if ((cmd==R_ONE)&&(busy==1'b0))
	begin
		operation<=R_ONE;
		busy<=1'b1;
	end
	else
	begin
		operation<=operation;
		busy<=busy;
	end
end


always@(posedge clk)
begin
	case(operation[7:6])
		2'b01://W_ALL
		begin
			s_cen_reg<=`ENA;
			s_addr_reg<=cnt;
			if(operation[3:0]==4'b0001)
				s_ddata_reg<=8'b0;
			else if (operation[3:0]==4'b0010)
				s_ddata_reg<=8'hff;
			else if (operation[3:0]==4'b0100)
				s_ddata_reg<=8'h5a;
			else if (operation[3:0]==4'b1000)
				s_ddata_reg<=8'ha5;
			else 
				s_ddata_reg<=8'h0;
			if(cnt==10'b11_1111_1111)
				begin
					busy<=1'b0;
					operation<=NONE;
					cnt<=10'b0;
				end
			else
				begin
					cnt<=cnt+1;
				end
			s_wen_reg<=`ENA;
		end
		2'b00://R_ALL
		begin
			s_cen_reg<=`ENA;
			s_addr_reg<=cnt;
			outp_data_reg<=s_qdata;
			if(cnt==10'b11_1111_1111)
				begin
					busy<=1'b0;
					operation<=NONE;
					cnt<=10'b0;
				end
			else
				begin
					cnt<=cnt+1;
				end
			s_oen_reg<=`ENA;
		end
		2'b11://W_ONE
		begin
			s_cen_reg<=`ENA;
			s_addr_reg<=addr;
			s_wen_reg<=`ENA;
			s_ddata_reg<=inp_data;
			operation<=NONE;
			busy<=1'b0;
		end
		2'b10://R_ONE
		begin
			s_cen_reg<=`ENA;
			s_addr_reg<=addr;
			s_oen_reg<=`ENA;
			operation<=NONE;
			busy<=1'b0;
		end
	endcase
end
endmodule
