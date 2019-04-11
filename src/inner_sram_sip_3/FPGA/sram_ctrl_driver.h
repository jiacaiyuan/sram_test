#ifndef __SRAM_CTRL_DRIVER_H_
#define __SRAM_CTRL_DRIVER_H_

#define CTRL_ID XPAR_SRAM_CONTROL_0_DEVICE_ID
#define CTRL_BASE XPAR_SRAM_CONTROL_0_S00_AXI_BASEADDR
//for write
#define STA_ADDR_OFFSET SRAM_CONTROL_S00_AXI_SLV_REG0_OFFSET
#define TIM_CFG_OFFSET SRAM_CONTROL_S00_AXI_SLV_REG1_OFFSET
#define OP_CFG_OFFSET SRAM_CONTROL_S00_AXI_SLV_REG2_OFFSET
#define SEND_OFFSET SRAM_CONTROL_S00_AXI_SLV_REG3_OFFSET
#define ENABLE_OFFSET SRAM_CONTROL_S00_AXI_SLV_REG4_OFFSET

//for read
#define OUTP_ADDR_OFFSET SRAM_CONTROL_S00_AXI_SLV_REG5_OFFSET
#define OUTP_DATA_OFFSET SRAM_CONTROL_S00_AXI_SLV_REG6_OFFSET
#define STATUS_OFFSET SRAM_CONTROL_S00_AXI_SLV_REG7_OFFSET

#define DISENA 0x0
#define ENA 0x1
#define READ 0x1<<1
#define WRITE 0x0<<1

#define DELAY     1000000
#define ADDR_RANGE 0x3ff
#define DATA_RANGE 0xff
#define IDLE 0x2

//cmd
#define WRT_ONE 1
#define READ_ONE 2
#define WRT_ALL 3
#define WRT_CFG 4
#define CUT_CNT 5

void write_one(u32* addr,u32* data);

void write_all(u32 *data);

u32 write_cfg(u32 *addr,u32 *data,u32 *times,u32 *inc_dec,u32 *cycle);//times min=0 ->one time

u32 read_one(u32 *addr);

#endif