/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "xparameters.h"
#include "sram_ctrl.h"


#define CTRL_BASE XPAR_SRAM_CTRL_0_S00_AXI_BASEADDR
#define R0_OFFSET SRAM_CTRL_S00_AXI_SLV_REG0_OFFSET
#define R1_OFFSET SRAM_CTRL_S00_AXI_SLV_REG1_OFFSET
#define R2_OFFSET SRAM_CTRL_S00_AXI_SLV_REG2_OFFSET
#define R3_OFFSET SRAM_CTRL_S00_AXI_SLV_REG3_OFFSET
#define DELAY     1000000
int main()
{
    init_platform();
    int delay;
    u32 r_reg0,r_reg1,r_reg2,r_reg3;
    int w_reg1,w_reg2,w_reg3;
    print("Hello World\n\r");
    print("-------------test one---------------\n\r");
    print("ready to read reg0-reg3\n\r");
    for(delay=0;delay<DELAY;delay++);
    r_reg0=SRAM_CTRL_mReadReg(CTRL_BASE, R0_OFFSET);
    r_reg1=SRAM_CTRL_mReadReg(CTRL_BASE, R1_OFFSET);
    r_reg2=SRAM_CTRL_mReadReg(CTRL_BASE, R2_OFFSET);
    r_reg3=SRAM_CTRL_mReadReg(CTRL_BASE, R3_OFFSET);
    printf("reg0=%x\n\r",r_reg0);
    printf("reg1=%x\n\r",r_reg1);
    printf("reg2=%x\n\r",r_reg2);
    printf("reg3=%x\n\r",r_reg3);
    printf("has read all reg\n\r");

    for(delay=0;delay<DELAY;delay++);
    print("ready to write reg0-reg3\n\r");
    print("first to test led_1\n\r");
    SRAM_CTRL_mWriteReg(CTRL_BASE, R1_OFFSET, 0x1);
    if(SRAM_CTRL_mReadReg(CTRL_BASE, R1_OFFSET)==0x1)
    {print("write reg1 ok\n\r");}
    else{print("write reg1 fail\n\r");}

    for(delay=0;delay<DELAY;delay++);
    print("nest to test led_2\n\r");
    SRAM_CTRL_mWriteReg(CTRL_BASE, R2_OFFSET, 0xcf000000);
    if(SRAM_CTRL_mReadReg(CTRL_BASE, R2_OFFSET)==0xcf000000)
    {print("write reg2 ok\n\r");}
    else{print("write reg2 fail\n\r");}

    for(delay=0;delay<DELAY;delay++);
    while(1)
    {
    	print("ready to test slv_reg0\n\r");
    	print("print input add1\n\r");
    	scanf("%d",&w_reg1);
		SRAM_CTRL_mWriteReg(CTRL_BASE, R1_OFFSET, w_reg1);
    	print("print input add2\n\r");
    	scanf("%d",&w_reg2);
		SRAM_CTRL_mWriteReg(CTRL_BASE, R2_OFFSET, w_reg2);
		r_reg0=SRAM_CTRL_mReadReg(CTRL_BASE, R0_OFFSET);
		if(r_reg0==(w_reg1+w_reg2))
		{
			print("add ok\n\r");
		}
		else
		{
			printf("add fail and the reg0=%x\n\r",r_reg0);
		}
		print("test reg3 read and write\n\r");
		print("write to reg3\n\r");
		scanf("%d",&w_reg3);
		SRAM_CTRL_mWriteReg(CTRL_BASE, R3_OFFSET, w_reg3);
		for(delay=0;delay<DELAY;delay++);
		r_reg3=SRAM_CTRL_mReadReg(CTRL_BASE, R3_OFFSET);
		if(r_reg3==w_reg3)
		{print("write reg3 ok\n\r");}
		else
		{printf("write reg3 fail reg3=%x\n\r",r_reg3);}
    }
    cleanup_platform();
    return 0;
}
