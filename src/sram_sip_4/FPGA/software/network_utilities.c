#include <alt_types.h>
#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <sys/alt_flash.h>
#include "includes.h"
#include "io.h"
#include "simple_socket_server.h"
 
#include <alt_iniche_dev.h>
 
#include "ipport.h"
#include "tcpport.h"
#include "network_utilities.h"
 
#define IP4_ADDR(ipaddr, a,b,c,d) ipaddr = \
    htonl((((alt_u32)(a & 0xff) << 24) | ((alt_u32)(b & 0xff) << 16) | \
          ((alt_u32)(c & 0xff) << 8) | (alt_u32)(d & 0xff)))
 
/*
* get_mac_addr
*
* Read the MAC address in a board specific way
*
*/
static unsigned char macaddr[6] = { 0x00, 0x07, 0xed, 0xff, 0x06, 0x00 };
 
int get_mac_addr(NET net, unsigned char mac_addr[6])
{
  int rv = -1;
 
  /* first 3 bytes are altera's vendor id */
  /* last 3 bytes are picked from serial number sticker */
  mac_addr[0] = macaddr[0];
  mac_addr[1] = macaddr[1];
  mac_addr[2] = macaddr[2];
  mac_addr[3] = macaddr[3];
  mac_addr[4] = macaddr[4];
  mac_addr[5] = macaddr[5];
 
  /* return the mac address in the array */
  rv = 0;
 
  return rv;
}
 
/*
 * get_ip_addr()
 *
 * This routine is called by InterNiche to obtain an IP address for the
 * specified network adapter. Like the MAC address, obtaining an IP address is
 * very system-dependant and therefore this function is exported for the
 * developer to control.
 *
 * In our system, we are either attempting DHCP auto-negotiation of IP address,
 * or we are setting our own static IP, Gateway, and Subnet Mask addresses our
 * self. This routine is where that happens.
 */
int get_ip_addr(alt_iniche_dev *p_dev,
                ip_addr* ipaddr,
                ip_addr* netmask,
                ip_addr* gw,
                int* use_dhcp)
{
 
    IP4_ADDR(*ipaddr,202, 118, 229,189);//the ip address------------------jcyuan
    IP4_ADDR(*netmask, 255, 255, 255, 0);
 
#ifdef DHCP_CLIENT
    *use_dhcp = 0;
#else /* not DHCP_CLIENT */
    *use_dhcp = 0;
 
    printf("Static IP Address is %d.%d.%d.%d\n",
        ip4_addr1(*ipaddr),
        ip4_addr2(*ipaddr),
        ip4_addr3(*ipaddr),
        ip4_addr4(*ipaddr));
#endif /* not DHCP_CLIENT */
 
    /* Non-standard API: return 1 for success */
    return 1;
}
