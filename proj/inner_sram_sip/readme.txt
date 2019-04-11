xc7z020clg400-1
zynq
pynq
function:
the system is composed by the CPU UART SRAM_CONTROL(self-IP) BLOCK-MEMORY-GENERATOR(inner-sram)
cpu control the IP to read and write inner-sram
the CPU communicate with the PC in Python and to control register in AXI to control the IP read/write SRAM
inner block generator: config for stand alone ;with enable ;without any register which can improve proformance due to the same with actural SRAM
SRAM size: 1024*8