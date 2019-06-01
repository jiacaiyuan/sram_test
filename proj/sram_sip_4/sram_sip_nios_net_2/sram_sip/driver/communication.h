#ifndef COMMUNICATION_H_
#define COMMUNICATION_H_

//-----------------cmd
#define WRITE_ONE 1
#define READ 2
#define WRITE_ALL 3
#define READ_D 4
#define WRITE_CFG 5
#define INNER_UPDATE 6
#define CUT_CNT 7
//-----------------cmd



typedef struct
{
    INT32U cmd;
    INT32U addr;
    INT32U data;
    INT32U area;
    INT32U inc_dec;
    INT32U cycle;
    INT32U jump;
} CMD_PACKAGE; 



typedef struct
{
    INT8U cmd;
    INT8U addr[4];//char 1023 is 4 bytes
    INT8U data[3]; //char 255 is 3 bytes
    INT8U area[4]; //char 1023 is 4 bytes
    INT8U inc_dec; // only 1 or 0
    INT8U cycle; //onl 1 or 0
    INT8U jump[4];//  char 1023 is 4 bytes
} CMD_STRING;




#endif /*COMMUNICATION_H_*/
