//#include "STM32F10X_GPIO.h"

#ifndef __MY_MAC_DRIVER_H
#define __MY_MAC_DRIVER_H
/***************************** Include Files *********************************/

#include "xil_types.h"
#include "xil_io.h"
#include "xil_assert.h"
#include "xparameters.h"
#include "stdio.h"
#include "string.h"
#include "sleep.h"
#include "xparameters.h"
#include "xparameters_ps.h"	/* defines XPAR values */
#include "xil_types.h"
#include "xil_assert.h"
#include "xil_io.h"
#include "xil_exception.h"
#include "xpseudo_asm.h"
#include "xil_cache.h"
#include "xil_printf.h"
#include "xscugic.h"
#include "xscutimer.h"
#include "xemacps.h"		/* defines XEmacPs API */
#include "xil_mmu.h"
#include "hls_driver.h"
/************************** Constant Definitions *****************************/

/*
 * The following constants map to the XPAR parameters created in the
 * xparameters_ps.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */

/*#define RXBD_SPACE_BYTES 	\
XEmacPs_BdRingMemCalc(XEMACPS_BD_ALIGNMENT, XEMACPS_IEEE1588_NO_OF_RX_DESCS)

#define TXBD_SPACE_BYTES 	\
XEmacPs_BdRingMemCalc(XEMACPS_BD_ALIGNMENT, XEMACPS_IEEE1588_NO_OF_TX_DESCS)
*/
#define EMACPS_DEVICE_ID	XPAR_XEMACPS_0_DEVICE_ID
#define INTC_DEVICE_ID		XPAR_SCUGIC_SINGLE_DEVICE_ID
#define TIMER_DEVICE_ID		XPAR_SCUTIMER_DEVICE_ID
#define EMACPS_IRPT_INTR	XPS_GEM0_INT_ID
#define TIMER_IRPT_INTR		XPAR_SCUTIMER_INTR

#define RX_BD_START_ADDRESS	0x0FF00000
#define TX_BD_START_ADDRESS	0x0FF10000

#define PHY_DETECT_REG1 2
#define PHY_DETECT_REG2 3

#define PHY_ID_MARVELL	0x141
#define PHY_ID_TI		0x2000
#define PHY_ID_REALTEK  0x1C
#define PHY_R1_AN_COMPLETE 0x0020
#define PHY_R1_LINK_UP 0x0004

/* Timer load value for timer expiry in every 500 milli seconds. */
#define TIMER_LOAD_VALUE	1665000//XPAR_CPU_CORTEXA9_0_CPU_CLK_FREQ_HZ / 4

/* Number of BDs used in the Tx and Rx paths */
#define RX_DESCS			3
#define TX_DESCS			4

/* Maximum buffer length used to store the PTP pakcets */
#define XEMACPS_PACKET_LEN				1538

#define ETH_P_DEAN 0x8874 //自定义的以太网协议type


/**************************** Type Definitions *******************************/
typedef struct _data_send //定义发送数据结构体
{
    char data_1[16];
    char data_2[16];
    char data_3[32];
    int  data_4;
    float  data_5;
}DATA_SEND;
typedef struct _ehthdr //定义eth首部
{
    unsigned char dest_1; //Destination MAC Address
    unsigned char dest_2;
    unsigned char dest_3;
    unsigned char dest_4;
    unsigned char dest_5;
    unsigned char dest_6;
    unsigned char src_1;  //Source MAC Address
    unsigned char src_2;
    unsigned char src_3;
    unsigned char src_4;
    unsigned char src_5;
    unsigned char src_6;
    unsigned short type; //EtherType
}ETH_HEADER;
typedef struct _datahdr //定义data
{
    char payload[XEMACPS_PACKET_LEN + 2 -14];

}DATA_HEADER;

typedef char EthernetFrame[XEMACPS_MAX_VLAN_FRAME_SIZE]
	__attribute__ ((aligned(XEMACPS_RX_BUF_ALIGNMENT)));

/***************** Macros (Inline Functions) Definitions *********************/
void 	Mac_driver_PacketSend(unsigned int len, unsigned char* packet,XEmacPs *EmacPsInstancePtr);
unsigned int Mac_driver_PacketReceive(unsigned int maxlen, unsigned char* packet,XEmacPs *EmacPsInstancePtr);

void XEmacPs_Rx_InterruptHandler(XEmacPs *InstancePtr);
void XEmacPs_Tx_InterruptHandler (XEmacPs *InstancePtr);
void XEmacPs_Error_InterruptHandler (XEmacPs *InstancePtr,
						u8 Direction, u32 ErrorWord);
int XEmacPs_InitializeEmacPsDma (XEmacPs *InstancePntr);
int XEmacPs_InitScuTimer(void);
int EmacPs_PHY_init(XEmacPs * EmacPsInstancePtr);
int EmacPsUtilRealtekPhy(XEmacPs * EmacPsInstancePtr, u32 PhyAddr);
int XEmacPsDetectPHY(XEmacPs * EmacPsInstancePtr);
int XEmacPs_SetupIntrSystem(XScuGic *IntcInstancePtr,
		XEmacPs *EmacPsInstancePtr, XScuTimer *TimerInstancePtr,
			u16 EmacPsIntrId, u16 TimerIntrId);
void XEmacPs_TimerInterruptHandler_MY(XEmacPs *EmacPsInstancePtr);
void analyseETH(ETH_HEADER *eth);
void analyseDATA(DATA_HEADER *data);
int mymacinit(unsigned char *mymac, XEmacPs *EmacPsInstancePtr);

extern XEmacPs Mac;
extern u32 NewPktRecd;
extern int init_finish_flag;
extern unsigned int my_protocol_flag;
extern unsigned char MyRecvbuf[XEMACPS_PACKET_LEN + 2];
extern unsigned char MySendbuf[XEMACPS_PACKET_LEN + 2];
extern XPid_regulator Hls_pid;
extern int ResultAvailHls_PID;
extern unsigned char src_mac[6]; //Pynq
extern unsigned char dst_mac[6]; //VMware

#endif
