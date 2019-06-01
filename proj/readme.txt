sram_gpio_demo:verify the data path using gpio/LED-arm-uart
xc7z020clg400-1
zynq
pynq
SW-GPIO-CPU-slv_reg-LED




sram_sip_demo:verify the data path using self-ip/LED-arm-uart
pc communicate with FPGA in uart and write/read register in the modoule of ip to control led               add the clk_freq to light the LED--verfiy the data-path -using uart to communicate

xc7z020clg400-1
zynq
pynq
function:
1 CPU communicate to PC with UART
2 Control CPU to write/read slv_reg
3 LED change follow the slv_reg
4 LED change follow clk-freq

test all the data transfer
PC-UART-CPU-slv_reg-LED(outp)---write
(inp)slv_reg-CPU-UART-PC   -----read





inner_sram_sip:using the block-memory-generator to verify the sram_ctrl function Version:sram_ctrl_3
the ip to test inner_sram finish the basic function sram_ctrl_3

xc7z020clg400-1
zynq
pynq
function:
the system is composed by the CPU UART SRAM_CONTROL(self-IP) BLOCK-MEMORY-GENERATOR(inner-sram)
cpu control the IP to read and write inner-sram
the CPU communicate with the PC in Python and to control register in AXI to control the IP read/write SRAM
inner block generator: config for stand alone ;with enable ;without any register which can improve proformance due to the same with actural SRAM
SRAM size: 1024*8




inner_sram_sip_2:using the block-memory-generator to verify the sram_ctrl function Version:sram_ctrl_4
the ip to test inner_sram finish the basic function sram_ctrl_4,the communication using UART

xc7z020clg400-1
zynq
pynq
function:
the system is composed by the CPU UART SRAM_CONTROL(self-IP) BLOCK-MEMORY-GENERATOR(inner-sram)
cpu control the IP to read and write inner-sram
the CPU communicate with the PC in Python and to control register in AXI to control the IP read/write SRAM
inner block generator: config for stand alone ;with enable ;without any register which can improve proformance due to the same with actural SRAM
SRAM size: 1024*8
but this version can fit all sram-size with little change and function is more beautiful


inner_sram_sip_3:
the ip to test inner_sram finish the basic function sram_ctrl_4,the communication using Ethernet





sram_sip_1: using real SRAM to test Version:sram_ctrl_4,communication by UART
the ip using sram_ctrl_using real SRAM that produced byself

xc7z020clg400-1
zynq
pynq
NOTE: the ip is followed the real SRAM that enable is low
the frequency is just 1M



sram_sip_2: using real SRAM to test Version:sram_ctrl_5,communication by UART
the ip using sram_ctrl_using real SRAM that produced byself

xc7z020clg400-1
zynq
pynq
NOTE: the ip is followed the real SRAM that enable is low
the communication protocol is different


sram_sip_3: using real SRAM to test Version:sram_ctrl_5,communication by Ethernet
the ip using sram_ctrl_using real SRAM that produced byself

alter-DE2
cyclone2
EP2C35F672C6
NOTE: the ip is followed the real SRAM that enable is low
the communication protocol is different

sram_sip_4: using real SRAM to test Version:sram_ctrl_6,communication by Ethernet
the ip using sram_ctrl_using real SRAM that produced byself,Also it can update the data to inner reg by command

alter-DE2
cyclone2
EP2C35F672C6
NOTE: the ip is followed the real SRAM that enable is low
the communication protocol is different
1: once transfer one command
2: once transfer multi commands
