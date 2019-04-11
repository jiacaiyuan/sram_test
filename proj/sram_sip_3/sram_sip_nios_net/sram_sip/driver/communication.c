#include <stdio.h>
#include <string.h>
#include <ctype.h> 
#include "includes.h"
#include "communication.h"

INT32U buf_int (INT8U* buf)
{
    int i=0;
    INT32U number=0;
    for(i=0;i<sizeof(INT32U);i++)
    {       
        number |= ((INT32U)(*(buf+i))<<(i<<3));//little-endian   
    }
    return number;
}



int decoder_cmd (INT8U* buf,CMD_PACKAGE* cmd_package)
{
    cmd_package->cmd=buf_int(buf+4*0);
    switch(cmd_package->cmd)
    {
        case WRITE_ONE:
                cmd_package->addr=buf_int(buf+4*1)&0x3ff;
                cmd_package->data=buf_int(buf+4*2)&0xff;
                cmd_package->area=0;
                cmd_package->inc_dec=0;
                cmd_package->cycle=0;
                cmd_package->jump=0;
                break;
                
         case READ:
                cmd_package->addr=buf_int(buf+4*1)&0x3ff;
                cmd_package->data=0;
                cmd_package->area=0;
                cmd_package->inc_dec=0;
                cmd_package->cycle=0;
                cmd_package->jump=0;               
                break;
                  
         case WRITE_ALL:
                cmd_package->addr=0;
                cmd_package->data=buf_int(buf+4*1)&0xff;
                cmd_package->area=0;
                cmd_package->inc_dec=0;
                cmd_package->cycle=0;
                cmd_package->jump=0;                              
                break; 
                  
        case READ_D:
                cmd_package->addr=buf_int(buf+4*1)&0x3ff;
                cmd_package->data=0;
                cmd_package->area=0;
                cmd_package->inc_dec=0;
                cmd_package->cycle=0;
                cmd_package->jump=0;                
                break;    
                
        case WRITE_CFG:
                cmd_package->addr=buf_int(buf+4*1)&0x3ff;
                cmd_package->data=buf_int(buf+4*2)&0xff;
                cmd_package->area=buf_int(buf+4*3)&0xff;
                cmd_package->inc_dec=buf_int(buf+4*4)&0xff;
                cmd_package->cycle=buf_int(buf+4*5)&0xff;
                cmd_package->jump=buf_int(buf+4*6)&0xff;                   
                break;  
                
        case CUT_CNT:
                cmd_package->addr=0;
                cmd_package->data=0;
                cmd_package->area=0;
                cmd_package->inc_dec=0;
                cmd_package->cycle=0;
                cmd_package->jump=0;               
                break; 
        default:
                cmd_package->addr=0;
                cmd_package->data=0;
                cmd_package->area=0;
                cmd_package->inc_dec=0;
                cmd_package->cycle=0;
                cmd_package->jump=0;       
                break;
    }
    return 0;
}




