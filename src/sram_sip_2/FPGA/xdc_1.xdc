#create_clock -name outp_clk -period 10 [get_ports s_clk]
#set_input_delay -max 3 -clock outp_clk [get_ports s_qdata]
#set_output_delay -max 3 -clock outp_clk [get_ports s_ddata]
#set_output_delay -max 3 -clock outp_clk [get_ports s_addr]
#set_output_delay -max 3 -clock outp_clk [get_ports s_oen]
#set_output_delay -max 3 -clock outp_clk [get_ports s_cen]
#set_output_delay -max 3 -clock outp_clk [get_ports s_wen]

#set_output_delay -max 3 -clock outp_clk [get_ports led_0]
#set_output_delay -max 3 -clock outp_clk [get_ports led_1]
#set_output_delay -max 3 -clock outp_clk [get_ports led_2]
#set_output_delay -max 3 -clock outp_clk [get_ports led_3]



set_property PACKAGE_PIN M14 [get_ports led_3]
set_property PACKAGE_PIN N16 [get_ports led_2]
set_property PACKAGE_PIN P14 [get_ports led_1]
set_property PACKAGE_PIN R14 [get_ports led_0]

set_property PACKAGE_PIN T14 [get_ports s_ddata[3]]
set_property PACKAGE_PIN U5 [get_ports s_qdata[3]]
set_property PACKAGE_PIN U12 [get_ports s_ddata[2]]
set_property PACKAGE_PIN V5 [get_ports s_qdata[2]]
set_property PACKAGE_PIN U13 [get_ports s_ddata[1]]
set_property PACKAGE_PIN V6 [get_ports s_qdata[1]]
set_property PACKAGE_PIN V13 [get_ports s_ddata[0]]
set_property PACKAGE_PIN U7 [get_ports s_qdata[0]]
set_property PACKAGE_PIN V15 [get_ports s_ddata[7]]
set_property PACKAGE_PIN V7 [get_ports s_qdata[7]]
set_property PACKAGE_PIN T15 [get_ports s_ddata[6]]
set_property PACKAGE_PIN U8 [get_ports s_qdata[6]]
set_property PACKAGE_PIN R16 [get_ports s_ddata[5]]
set_property PACKAGE_PIN V8 [get_ports s_qdata[5]]
set_property PACKAGE_PIN U17 [get_ports s_ddata[4]]
set_property PACKAGE_PIN V10 [get_ports s_qdata[4]]

set_property PACKAGE_PIN V17 [get_ports s_oen]
set_property PACKAGE_PIN W10 [get_ports s_clk]
set_property PACKAGE_PIN V18 [get_ports s_cen]
set_property PACKAGE_PIN W6 [get_ports s_wen]

set_property PACKAGE_PIN T16 [get_ports s_addr[0]]
set_property PACKAGE_PIN Y6 [get_ports s_addr[1]]
set_property PACKAGE_PIN R17 [get_ports s_addr[2]]
set_property PACKAGE_PIN Y7 [get_ports s_addr[3]]
set_property PACKAGE_PIN P18 [get_ports s_addr[4]]
set_property PACKAGE_PIN W8 [get_ports s_addr[5]]
set_property PACKAGE_PIN N17 [get_ports s_addr[6]]
set_property PACKAGE_PIN Y8 [get_ports s_addr[7]]
set_property PACKAGE_PIN W9 [get_ports s_addr[8]]
set_property PACKAGE_PIN Y9 [get_ports s_addr[9]]



set_property IOSTANDARD LVCMOS33 [get_ports led_1]
set_property IOSTANDARD LVCMOS33 [get_ports led_2]
set_property IOSTANDARD LVCMOS33 [get_ports led_3]
set_property IOSTANDARD LVCMOS33 [get_ports led_0]

set_property IOSTANDARD LVCMOS33 [get_ports s_addr[0]]
set_property IOSTANDARD LVCMOS33 [get_ports s_addr[1]]
set_property IOSTANDARD LVCMOS33 [get_ports s_addr[2]]
set_property IOSTANDARD LVCMOS33 [get_ports s_addr[3]]
set_property IOSTANDARD LVCMOS33 [get_ports s_addr[4]]
set_property IOSTANDARD LVCMOS33 [get_ports s_addr[5]]
set_property IOSTANDARD LVCMOS33 [get_ports s_addr[6]]
set_property IOSTANDARD LVCMOS33 [get_ports s_addr[7]]
set_property IOSTANDARD LVCMOS33 [get_ports s_addr[8]]
set_property IOSTANDARD LVCMOS33 [get_ports s_addr[9]]

set_property IOSTANDARD LVCMOS33 [get_ports s_qdata[0]]
set_property IOSTANDARD LVCMOS33 [get_ports s_qdata[1]]
set_property IOSTANDARD LVCMOS33 [get_ports s_qdata[2]]
set_property IOSTANDARD LVCMOS33 [get_ports s_qdata[3]]
set_property IOSTANDARD LVCMOS33 [get_ports s_qdata[4]]
set_property IOSTANDARD LVCMOS33 [get_ports s_qdata[5]]
set_property IOSTANDARD LVCMOS33 [get_ports s_qdata[6]]
set_property IOSTANDARD LVCMOS33 [get_ports s_qdata[7]]

set_property IOSTANDARD LVCMOS33 [get_ports s_ddata[0]]
set_property IOSTANDARD LVCMOS33 [get_ports s_ddata[1]]
set_property IOSTANDARD LVCMOS33 [get_ports s_ddata[2]]
set_property IOSTANDARD LVCMOS33 [get_ports s_ddata[3]]
set_property IOSTANDARD LVCMOS33 [get_ports s_ddata[4]]
set_property IOSTANDARD LVCMOS33 [get_ports s_ddata[5]]
set_property IOSTANDARD LVCMOS33 [get_ports s_ddata[6]]
set_property IOSTANDARD LVCMOS33 [get_ports s_ddata[7]]

set_property IOSTANDARD LVCMOS33 [get_ports s_cen]
set_property IOSTANDARD LVCMOS33 [get_ports s_oen]
set_property IOSTANDARD LVCMOS33 [get_ports s_wen]

set_property IOSTANDARD LVCMOS33 [get_ports s_clk]

