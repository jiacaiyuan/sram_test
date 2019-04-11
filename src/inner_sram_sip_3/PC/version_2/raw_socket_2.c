#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <linux/if_packet.h>
#include <netinet/if_ether.h>
#include <netinet/in.h>
#include <unistd.h> //for sleep
#define ETH_P_DEAN 0x8874 //self define Ethernet communicate type

#define ADDR_RANGE 0x3ff
#define DATA_RANGE 0xff

#define WRT_ONE 1
#define READ_ONE 2
#define WRT_ALL 3
#define WRT_CFG 4
#define CUT_CNT 5
#define UNKNOW 0
#define THRESHOLD 500


typedef struct _ehthdr //the header of ethernet 
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

typedef struct _data_send //define data
{
    unsigned int cmd;
    unsigned int addr;
    unsigned int data;
    unsigned int times;
    unsigned int inc_dec;
    unsigned int cycle;
}DATA_SEND;

typedef struct _data_recv //define data_recv
{
    char cmd_mode[16];
    int addr;
    int data;
    int times;
    int config;
}DATA_RECV;


void analyseETH(ETH_HEADER *eth);
int  analyseDATA(char* fil_name,DATA_RECV* data_recv);
int read_vectors(char*cmd,char*addr,char*data,char*times,char*inc_dec,char*cycle,DATA_SEND*data_send);
int socket_init();



int protocol_flag = 0;
unsigned char src_mac[6] = {0x00,0x0c,0x29,0xb7,0x9a,0x5e};  //VMware the laptop thinkpad X1--jcyuan
unsigned char dst_mac[6] = {0x01,0x02,0x03,0x04,0x05,0x06};  //Pynq
struct sockaddr_ll device_send;
char *interface="eno16777736";//VMware the laptop thinkpad X1--jcyuan
int sockfd;

//the parameter is filename,cmd,addr,data,times,inc_dec,cycle
int main(int argc,char* argv[])
{
    //argv[1] output 
    //argv[2] input
    int n;
    int i=0,counter=0;
    ETH_HEADER *eth;
    DATA_SEND data_send;
    DATA_RECV *data_recv;
    FILE* fp;
    char rec_buf[1500];
    char send_buf[1500];
    int datalen= sizeof(DATA_SEND);
    socket_init();
    if((fp=fopen(argv[2],"r"))==NULL)
    {
        printf("ERROR\n");
        exit(0);
    }
    for(i=0;!feof(fp);i++)
    {
        fscanf(fp,"%d ",&data_send.cmd);
        if(data_send.cmd==WRT_ONE)//write one
        {
            fscanf(fp,"%d %d\n",&data_send.addr,&data_send.data);
            data_send.addr=data_send.addr&ADDR_RANGE;
            data_send.data=data_send.data&DATA_RANGE;
            data_send.times=0;
            data_send.inc_dec=0;
            data_send.cycle=0;
        }
        else if(data_send.cmd==READ_ONE)
        {
            fscanf(fp,"%d\n",&data_send.addr);
            data_send.addr=data_send.addr&ADDR_RANGE;
            data_send.data=0;
            data_send.times=0;
            data_send.inc_dec=0;
            data_send.cycle=0;
        }
        else if(data_send.cmd==WRT_ALL)
        {
            fscanf(fp,"%d\n",&data_send.data);
            data_send.addr=0;
            data_send.data=data_send.data&DATA_RANGE;
            data_send.times=ADDR_RANGE;
            data_send.inc_dec=0;
            data_send.cycle=0;
        }
        else if(data_send.cmd==WRT_CFG)
        {
            fscanf(fp,"%d %d %d %d %d\n",&data_send.addr,
                   &data_send.data,&data_send.times,&data_send.inc_dec,&data_send.cycle);
            data_send.addr=data_send.addr&ADDR_RANGE;
            data_send.data=data_send.data&DATA_RANGE;
            data_send.times=data_send.times&ADDR_RANGE;
            if(data_send.inc_dec!=0){ data_send.inc_dec=1;}
            else{ data_send.inc_dec=0;}
            if(data_send.cycle=0){ data_send.cycle=1;}
            else{ data_send.cycle=0;}
        }
        else
        {
            printf("CUT CONNECTION\n");
            return 0;
        }
        //MAC
        memcpy (send_buf, dst_mac, 6);
        memcpy (send_buf + 6, src_mac, 6);
        //Type
        send_buf[12] = ETH_P_DEAN / 256;
        send_buf[13] = ETH_P_DEAN % 256;
        //Data
        memcpy (send_buf + 14 , &data_send, datalen);
        /***************************send***********************************/
        printf("%d %d %d %d %d %d\n",data_send.cmd,data_send.addr,data_send.data,data_send.times,data_send.inc_dec,data_send.cycle);
        n = sendto(sockfd, send_buf, 14+datalen, 0,(struct sockaddr *) &device_send, sizeof (device_send));
        if (n == -1)
        {
            perror("send error!\n");
            return 1;
        }
        /******************************reveive*************************/
        n = recvfrom(sockfd, rec_buf, sizeof(rec_buf), 0,NULL, NULL);
        if (n == -1)
        {
            perror("recv error!\n");
            return 1;
        }
        //receive eth-header
        eth = ( ETH_HEADER *)(rec_buf);
        analyseETH(eth);
        size_t ethlen =  14;
        if(protocol_flag == 1)
        {
            data_recv = (DATA_RECV *)(rec_buf + ethlen);
            //Note:due to the Ethernet Feature that the NIC of PC may send some other eth-types like 0x8000 0x0000 
            //to check if the Ethernet is well automaticly,so this type package may occupy the interrupt of FPGA,cause
            //FPGA can't process your package but process that useless package,to resolve it,if the package is not the type
            //of 0x8874--my eth-type, it will return the info that "unknow",so the PC need to re-send the package to ensure 
            // the info has been processed by FPGA
           // while((!strcmp(data_recv->cmd_mode, "UNKNOW"))|(data_recv->addr==-1))
			while((data_recv->addr==-1)&(data_recv->data==-1)&(data_recv->times==-1)&(data_recv->config==-1)&(counter<THRESHOLD))
            {
                usleep(100000);//0.1s
			    counter++;
                sendto(sockfd, send_buf, 14+datalen, 0,(struct sockaddr *) &device_send, sizeof (device_send));
                recvfrom(sockfd, rec_buf, sizeof(rec_buf), 0,NULL, NULL);
                data_recv = (DATA_RECV *)(rec_buf + ethlen);
            }
        }
		counter=0;
        analyseDATA(argv[1],data_recv);
    }
    close(sockfd);
    return 0;
}








void analyseETH(ETH_HEADER *eth)
{
    unsigned char* p = (unsigned char*)&eth->type;
    if(p[0] == 0x88 && p[1] == 0x74)
    {
        protocol_flag = 1;
       // printf("dest: %02x.%02x.%02x.%02x.%02x.%02x\n", eth->dest_1,eth->dest_2,eth->dest_3,eth->dest_4,eth->dest_5,eth->dest_6);
       // printf("src: %02x.%02x.%02x.%02x.%02x.%02x\n", eth->src_1,eth->src_2,eth->src_3,eth->src_4,eth->src_5,eth->src_6);
       // printf("type: %02x%02x\n", p[0],p[1]);
    }
    else
    {
        protocol_flag = 0;
    }
    return;
}




int analyseDATA(char* fil_name,DATA_RECV* data_recv)
{
    printf("%s 0x%x 0x%x 0x%x 0x%x\n",
            data_recv->cmd_mode,data_recv->addr,data_recv->data,data_recv->times,data_recv->config);
    FILE *fp;
    if((fp=fopen(fil_name,"a"))==NULL)
    {
        printf("Error:Open/Gen Fail %s\n",fil_name);
        exit(0);
    }
    fprintf(fp,"%s 0x%x 0x%x 0x%x 0x%x\n",
            data_recv->cmd_mode,data_recv->addr,data_recv->data,data_recv->times,data_recv->config);
  
    fclose(fp);
    return 0;
}



int socket_init()
{
    int i;
   /* capture ip datagram without ethernet header */
    if ((sockfd = socket(PF_PACKET,  SOCK_RAW, htons(ETH_P_DEAN)))== -1)
    {    
        perror("socket error!\n");
        return 1;
    }
    /**************************send device init***************************/
    memset (&device_send, 0, sizeof (device_send));
    device_send.sll_family    = AF_PACKET;//write AF_PACKET,and it will not into the protocol layers
    device_send.sll_protocol  = htons(ETH_P_ALL);
    //the index of NIC,very important,the index decide which NIC that the system send the info to 
    if ((device_send.sll_ifindex = if_nametoindex (interface)) == 0) 
    {
        perror ("if_nametoindex() failed to obtain interface index ");
        exit (EXIT_FAILURE);
    }
    //printf ("Index for interface %s is %i\n", interface, device_send.sll_ifindex);

    device_send.sll_pkttype   = PACKET_OTHERHOST;//define the type of package is being sent 
    device_send.sll_halen     = 6;    //the destination MAC address is 6 bytes
    //write the dest MAC addr
    for(i=0;i<6;i++){device_send.sll_addr[i]=src_mac[i];}
    return 0;
}
