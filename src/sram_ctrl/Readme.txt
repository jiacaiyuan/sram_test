sram_ctrl_1: sram_ctrl--the version of test can't synthesize
sram_ctrl_2: the state of W/R_ALL,W/R_ONE,W_A_0/1/5a/a5,INCREMENT(auto),ERROR,the version can synthesize but don't use it

sram_ctrl_3: the version that can synthesize in FPGA(inner_sram_sip),the function of it can W_ALL,R_ALL,W_ONE,R_ONE,R_REG and the only one register you can control it named control-reg but it can only fit in 1024*8 SRAM

sram_ctrl_4: the version that can fit all size SRAM more config 

sram_ctrl_5: base on the sram_ctrl_4,add the additional function,such as read directly from SRAM and write jump some address
