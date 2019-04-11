import os
import sys
import struct
import socket
from time import sleep
from optparse import OptionParser

def eth_recv():
	recive =s.recv(1500)
	data=str(recive,encoding="utf-8")#or using bytes.decode(b) to change the bytes to str
	print(data)
	return data

def write_data(package):
	s.send(package)

def initial_eth():
	s.connect(('202.118.229.189',30))
	eth_recv()

def transfer_once(package):
	initial_eth()
	write_data(package)
	data=eth_recv()
	s.close()
	return data

def check_name(name):
	name=(name.strip()).split('.')
	return name[0]+".txt"

print("\n\n\n\n")
print(sys.version)
os.system("python -V")
usage="%prog [options]"
version="1.0"
parser=OptionParser(usage,description="SRAM test running",version="%prog "+version)
#in/out file
parser.add_option("-i","--intput_file",dest="in_fil",help="Input test vector file",type='string',default="cmd.txt")
parser.add_option("-o","--output_file",dest="out_fil",help="Output log file",type='string',default="log.txt")
(options,args)=parser.parse_args()

in_fil=check_name(options.in_fil)
out_fil=check_name(options.out_fil)



cmd_file=open(in_fil,'r')
log_file=open(out_fil,'w')
lines=cmd_file.readlines()
#file format
#cmd 1:write_one 2:read 3:write_all 4:read_direct 5:write_config 6:cut connection
#1 addr data 
#2 addr
#3 data
#4 addr
#5 addr data op_times inc_dec cycle jump
#6 cut_connection
for line in lines:
	s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
	line=(line.strip()).split()
	for i in range(len(line)):
		line[i]=int(line[i])
	cmd=line[0]
	if cmd==1:
		#check illegal
		if len(line)!=3 or (line[1]>int('0x3ff',16)) or (line[2]>int('0xff',16)):#addr/data overflow
			continue
		cmd=struct.pack('i',cmd)
		addr=struct.pack('i',line[1])
		data=struct.pack('i',line[2])
		log_info=transfer_once(cmd+addr+data)
		log_file.write(log_info)
	elif cmd==2 or cmd==3 or cmd==4:
		if len(line)!=2:
			continue
		if cmd==2 and (line[1]>int('0x3ff',16)):
			continue
		cmd=struct.pack('i',cmd)
		log_info=transfer_once(cmd+struct.pack('i',line[1]))
		log_file.write(log_info)
	elif cmd==5:
		if len(line)!=7 :
			continue
		if (line[1]>int('0x3ff',16)) or (line[2]>int('0xff',16)) or (line[6]>int('0x3ff',16)):
			continue
		if (line[3]>int('0x3ff',16)):
			continue
		if (line[4]!=1 and line[4]!=0) or (line[5]!=1 and line[5]!=0):
			continue
		cmd=struct.pack('i',cmd)
		addr=struct.pack('i',line[1])
		data=struct.pack('i',line[2])
		times=struct.pack('i',line[3])
		inc_dec=struct.pack('i',line[4])
		cycle=struct.pack('i',line[5])
		jump=struct.pack('i',line[6])
		log_info=transfer_once(cmd+addr+data+times+inc_dec+cycle+jump)
		log_file.write(log_info)
	else:
		continue
cmd_file.close()
log_file.close()



