module  SRAM_SOC
	(
		////////////////////	Clock Input	 	////////////////////	 
		
		CLOCK_50,						//	On Board 50 MHz
		////////////////////	Push Button		////////////////////
		KEY,							//	Pushbutton[3:0]
		////////////////////	DPDT Switch		////////////////////
		SW,								//	Toggle Switch[17:0]
		////////////////////	7-SEG Dispaly	////////////////////
		HEX0,							//	Seven Segment Digit 0
		HEX1,							//	Seven Segment Digit 1
		HEX2,							//	Seven Segment Digit 2
		HEX3,							//	Seven Segment Digit 3
		HEX4,							//	Seven Segment Digit 4
		HEX5,							//	Seven Segment Digit 5
		HEX6,							//	Seven Segment Digit 6
		HEX7,							//	Seven Segment Digit 7

		////////////////////////	LED		////////////////////////
		LEDG,							//	LED Green[8:0]
//		LEDR,							//	LED Red[17:0]
		
		/////////////////////	SDRAM Interface		////////////////
		DRAM_DQ,						//	SDRAM Data bus 16 Bits
		DRAM_ADDR,						//	SDRAM Address bus 12 Bits
		DRAM_LDQM,						//	SDRAM Low-byte Data Mask 
		DRAM_UDQM,						//	SDRAM High-byte Data Mask
		DRAM_WE_N,						//	SDRAM Write Enable
		DRAM_CAS_N,						//	SDRAM Column Address Strobe
		DRAM_RAS_N,						//	SDRAM Row Address Strobe
		DRAM_CS_N,						//	SDRAM Chip Select
		DRAM_BA_0,						//	SDRAM Bank Address 0
		DRAM_BA_1,						//	SDRAM Bank Address 1
		DRAM_CLK,						//	SDRAM Clock
		DRAM_CKE,						//	SDRAM Clock Enable
		////////////////////	Flash Interface		////////////////
	
		FL_DQ,							//	FLASH Data bus 8 Bits
		FL_ADDR,						//	FLASH Address bus 20 Bits
		FL_WE_N,						//	FLASH Write Enable
		FL_RST_N,						//	FLASH Reset
		FL_OE_N,						//	FLASH Output Enable
		FL_CE_N						//	FLASH Chip Enable
	);
	
	////////////////////////	Clock Input	 	////////////////////////

input			CLOCK_50;				//	On Board 50 MHz

////////////////////////	Push Button		////////////////////////
input	[3:0]	KEY;					//	Pushbutton[3:0]
////////////////////////	DPDT Switch		////////////////////////
input	[17:0]	SW;						//	Toggle Switch[17:0]
////////////////////////	7-SEG Display	////////////////////////

output	[6:0]	HEX0;					//	Seven Segment Digit 0
output	[6:0]	HEX1;					//	Seven Segment Digit 1
output	[6:0]	HEX2;					//	Seven Segment Digit 2
output	[6:0]	HEX3;					//	Seven Segment Digit 3
output	[6:0]	HEX4;					//	Seven Segment Digit 4
output	[6:0]	HEX5;					//	Seven Segment Digit 5
output	[6:0]	HEX6;					//	Seven Segment Digit 6
output	[6:0]	HEX7;					//	Seven Segment Digit 7

////////////////////////////	LED		////////////////////////////

output	[8:0]	LEDG;					//	LED Green[8:0]
//output		LEDR7;					//	LED Red[17:0]


///////////////////////		SDRAM Interface	////////////////////////
inout	[15:0]	DRAM_DQ;				//	SDRAM Data bus 16 Bits
output	[11:0]	DRAM_ADDR;				//	SDRAM Address bus 12 Bits
output			DRAM_LDQM;				//	SDRAM Low-byte Data Mask 
output			DRAM_UDQM;				//	SDRAM High-byte Data Mask
output			DRAM_WE_N;				//	SDRAM Write Enable
output			DRAM_CAS_N;				//	SDRAM Column Address Strobe
output			DRAM_RAS_N;				//	SDRAM Row Address Strobe
output			DRAM_CS_N;				//	SDRAM Chip Select
output			DRAM_BA_0;				//	SDRAM Bank Address 0
output			DRAM_BA_1;				//	SDRAM Bank Address 0
output			DRAM_CLK;				//	SDRAM Clock
output			DRAM_CKE;				//	SDRAM Clock Enable
////////////////////////	Flash Interface	////////////////////////

inout	[7:0]	FL_DQ;					//	FLASH Data bus 8 Bits
output	[21:0]	FL_ADDR;				//	FLASH Address bus 22 Bits
output			FL_WE_N;				//	FLASH Write Enable
output			FL_RST_N;				//	FLASH Reset
output			FL_OE_N;				//	FLASH Output Enable
output			FL_CE_N;				//	FLASH Chip Enable








////////////////////////	GPIO	////////////////////////////////
//inout	[35:0]	GPIO_0;					//	GPIO Connection 0
//inout	[35:0]	GPIO_1;					//	GPIO Connection 1

wire	CPU_CLK;
wire	CPU_RESET;
wire	CLK_25;
wire Done,Cancel,Confirm;
wire [2:0] coins,goods;
//	Flash
assign	FL_RST_N	=	1'b1;
assign goods = SW[2:0];
Reset_Delay	delay1	(.iRST(KEY[0]),.iCLK(CLOCK_50),.oRESET(CPU_RESET));
SDRAM_PLL 	PLL1	(.inclk0(CLOCK_50),.c0(DRAM_CLK),.c1(CPU_CLK),.c2(CLK_25));

key_test   sw(
							.clk(CPU_CLK),              // 开发板上输入时钟: 50Mhz
							.rst_n(KEY[0]),            // 开发板上输入复位按键
							.key_in({SW[17:15],SW[10:8]}),           
							.out({Cancel,Confirm,Done,coins})           
						);
						
					
system0 	u0	(
				// 1) global signals:
                  .clk_0(CPU_CLK),
                  .clk_1(CLOCK_50),
                  .reset_n(CPU_RESET),
				 // the_Vend
                   .SW_to_the_Vend({Cancel,Confirm,Done,coins,goods}),
				 
                 // the_sdram_0
                 .zs_addr_from_the_sdram(DRAM_ADDR),
                 .zs_ba_from_the_sdram({DRAM_BA_1,DRAM_BA_0}),
                 .zs_cas_n_from_the_sdram(DRAM_CAS_N),
                 .zs_cke_from_the_sdram(DRAM_CKE),
                 .zs_cs_n_from_the_sdram(DRAM_CS_N),
                 .zs_dq_to_and_from_the_sdram(DRAM_DQ),
                 .zs_dqm_from_the_sdram({DRAM_UDQM,DRAM_LDQM}),
                 .zs_ras_n_from_the_sdram(DRAM_RAS_N),
                 .zs_we_n_from_the_sdram(DRAM_WE_N),
					  
					 
					   // the_tri_state_bridge_avalon_slave
                  .select_n_to_the_cfi_flash(FL_CE_N),
                  .tri_state_bridge_address(FL_ADDR),
                  .tri_state_bridge_data(FL_DQ),
                  .tri_state_bridge_readn(FL_OE_N),
                  .write_n_to_the_cfi_flash(FL_WE_N),
						
						// the_pio_led
                  .out_port_from_the_pio_led({LEDG[7],LEDG[0]}),
						 // the_seg7_lut_8
                  .oSEG0_from_the_seg7_lut_8(HEX0),
                  .oSEG1_from_the_seg7_lut_8(HEX1),
                  .oSEG2_from_the_seg7_lut_8(HEX2),
                  .oSEG3_from_the_seg7_lut_8(HEX3),
                  .oSEG4_from_the_seg7_lut_8(HEX4),
                  .oSEG5_from_the_seg7_lut_8(HEX5),
                  .oSEG6_from_the_seg7_lut_8(HEX6),
                  .oSEG7_from_the_seg7_lut_8(HEX7)
                );	
endmodule
