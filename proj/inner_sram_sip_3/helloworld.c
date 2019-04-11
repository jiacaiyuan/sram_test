
/*
 * the project to communicate in FPGA(PYNQ-z1) and PC(Linux) using Ethernet by the data package in the data link layer
 * parameter:
 *
 * pynq:
 *         EtherType:0x8874
 *         MAC:01-02-03-04-05-06
 *         PC :00-0x0c-0x29-0xb7-0x9a-0x5e
 *
 * the ISR in ARM:
 * Ethernet:
 * XEmacPs_Rx_InterruptHandler
 * XEmacPs_Tx_InterruptHandler
 * XEmacPs_Error_InterruptHandler
 *
 * Timer£ºXEmacPs_TimerInterruptHandler
 *
 * dataflow:
 * PC--ETHERNET--ARM--FPGA(IP)--IP--ARM--ETHERNET--PC
 *
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xscugic.h"
#include "mac_driver.h"
#include "sram_ctrl_driver.h"

int main()
{
    init_platform();
    int Status = XST_SUCCESS;
    int status;
    int datalen=0;
    XEmacPs *EmacPsInstancePtr = &Mac;
    print("Hello World\n\r");
    unsigned int s_addr=0,s_data=0,s_times=0,s_inc_dec=0,s_cycle=0;
    unsigned int s_config=0;
    int data_read=0;

    // Setup the MAC instances
    Status = mymacinit(src_mac,EmacPsInstancePtr);
    if (Status != XST_SUCCESS) { return XST_FAILURE; }

    DATA_SEND *data_send;        //Payload of Ethernet
    strcpy(data_send->cmd_mode,"I am zynq");//don't comment it ,it will breakdown!!!

    //build the ethernet header of sendbuf
    memcpy (Sendbuf, dst_mac, 6);
    memcpy (Sendbuf + 6, src_mac, 6);
    Sendbuf[12] = ETH_P_DEAN / 256;
    Sendbuf[13] = ETH_P_DEAN % 256;

    while(1)
    {


        /*when the Ethernet receive each frames from PC
         *(not only the type of 8874,but also some other types like 8000,0000 to send from PC autoly to check the network
         *  and you need to igonore it,the other types also trigger the interrupt,and it's so frequency that maybe
         *  it can't receive the reall info from PC and it's useless,so the ARM may don't receive
         *  the useful info,so the PC need to re-send the info until the ARM receive the useful info)
         * the interrupt will put the NwePktRecd to True,if it is the type of 0x8874,so execute it
         */
        if(NewPktRecd == TRUE)
        {
            NewPktRecd = 0;
            char unsigned *buf;
            ETH_HEADER *eth;
            DATA_RECEIVE *data_recv;
           //the data that received need to stripped the ether head
            buf = Recvbuf;
            eth = ( ETH_HEADER *)(buf);
            analyseETH(eth);
            size_t ethlen =  14;
            if(protocol_flag == 1)
            {
                data_recv = (DATA_RECEIVE *)(buf + ethlen);
                analyseDATA(data_recv,&s_addr,&s_data,&s_times,&s_inc_dec,&s_cycle);
                if(data_recv->cmd==WRT_ONE)
                {
                    write_one(&s_addr,&s_data);
                    strcpy(data_send->cmd_mode,"WRT_ONE");
                    data_send->addr=(int)s_addr;
                    data_send->data=(int)s_data;
                    data_send->times=0;
                    data_send->config=0;
                }
                else if(data_recv->cmd==READ_ONE)
                {
                    data_read=read_one(&s_addr);
                    strcpy(data_send->cmd_mode,"READ");
                    data_send->addr=(int)s_addr;
                    data_send->data=(int)data_read;
                    data_send->times=0;
                    data_send->config=0;
                }
                else if(data_recv->cmd==WRT_ALL)
                {
                    write_all(&s_data);
                    strcpy(data_send->cmd_mode,"WRT_ALL");
                    data_send->addr=0;
                    data_send->data=(int)s_data;
                    data_send->times=ADDR_RANGE;
                    data_send->config=0;
                }
                else if(data_recv->cmd==WRT_CFG)
                {
                    s_config=write_cfg(&s_addr,&s_data,&s_times,&s_inc_dec,&s_cycle);
                    strcpy(data_send->cmd_mode,"WRT_CFG");
                    data_send->addr=s_addr;
                    data_send->data=(int)s_data;
                    data_send->times=s_times;
                    data_send->config=s_config;
                }
                else
                {
                    strcpy(data_send->cmd_mode,"CUT_CNT");
                    data_send->addr=-1;
                    data_send->data=-1;
                    data_send->times=-1;
                    data_send->config=-1;
                    datalen = sizeof(DATA_SEND)/sizeof(unsigned char);
                    memcpy (Sendbuf + 14 , data_send, datalen);
                    Mac_driver_PacketSend(14+datalen, Sendbuf,EmacPsInstancePtr); //using the function of send ethernet
                    return 0;
                }
            }
            else
            {
                strcpy(data_send->cmd_mode,"UNKNOW");
                data_send->addr=-1;
                data_send->data=-1;
                data_send->times=-1;
                data_send->config=-1;
            }
            datalen = sizeof(DATA_SEND)/sizeof(unsigned char);
            //printf("datalen = %d\n",datalen);
            // data
            memcpy (Sendbuf + 14 , data_send, datalen);
            Mac_driver_PacketSend(14+datalen, Sendbuf,EmacPsInstancePtr); //using the function of send ethernet
        }
        else{;}
    }

    cleanup_platform();
    return 0;
}

