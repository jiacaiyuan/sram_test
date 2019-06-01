import os
import sys
import struct
import socket
from time import sleep
from optparse import OptionParser

#NOTE: due to the fact that the ethernet once transfer max is 1500bytes buffer
#and the command max is write config need 7int(28bytes),so we recommand you that
#once transfer command number max is not overflow 50 to avoid the error that unconsicous
#MAX_CMD_NUM=50


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
parser.add_option("-m","--max_trans",dest="max_trans",help="once commands transfer",type='int',default=10)
(options,args)=parser.parse_args()

in_fil=check_name(options.in_fil)
out_fil=check_name(options.out_fil)
MAX_CMD_NUM=options.max_trans

cmd_file=open(in_fil,'r')
log_file=open(out_fil,'w')
lines=cmd_file.readlines()
cmd_num=len(lines)
tr_num=int(cmd_num/MAX_CMD_NUM)+1
last_num=cmd_num%MAX_CMD_NUM
print("all commands number: "+str(cmd_num))
print("once transfer commands number: "+str(MAX_CMD_NUM))
print("transfer times: "+str(tr_num))
#file format
#cmd 1:write_one 2:read 3:write_all 4:read_direct 5:write_config 6:update 7:cut connection
#1 addr data 
#2 addr
#3 data
#4 addr
#5 addr data op_area inc_dec cycle jump
#6 update addr area
#7 cut_connection


#the version of send specific commands to FPGA once transfer
for i in range(tr_num):
	s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
	if(i==tr_num-1):#last transfer
		num=last_num
	else:
		num=MAX_CMD_NUM
	num_pkg=struct.pack('i',num)
	transfer_pkg=b''
	for j in range(num):
		line=(lines[j+i*MAX_CMD_NUM].strip()).split()
		for k in range(len(line)):
			line[k]=int(line[k])
		cmd=line[0]
		if cmd==1:
			#check illegal
			if len(line)!=3 or (line[1]>int('0x3ff',16)) or (line[2]>int('0xff',16)):#addr/data overflow
				continue
			cmd=struct.pack('i',cmd)
			addr=struct.pack('i',line[1])
			data=struct.pack('i',line[2])
			cmd_pkg=cmd+addr+data
		elif cmd==2 or cmd==3 or cmd==4:
			if len(line)!=2:
				continue
			if cmd==2 and (line[1]>int('0x3ff',16)):
				continue
			cmd=struct.pack('i',cmd)
			cmd_pkg=cmd+struct.pack('i',line[1])
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
			area=struct.pack('i',line[3])
			inc_dec=struct.pack('i',line[4])
			cycle=struct.pack('i',line[5])
			jump=struct.pack('i',line[6])
			cmd_pkg=cmd+addr+data+area+inc_dec+cycle+jump
		elif cmd==6:
			if len(line)!=3 or (line[1]>int('0x3ff',16)) or (line[2]>int('0x3ff',16)):
				continue
			cmd=struct.pack('i',cmd)
			addr=struct.pack('i',line[1])
			area=struct.pack('i',line[2])
			cmd_pkg=cmd+addr+area
		else:
			continue
		transfer_pkg=transfer_pkg+cmd_pkg
	transfer_pkg=num_pkg+transfer_pkg
	log_info=transfer_once(transfer_pkg)
	log_file.write(log_info)
	print("\n\n\n")
cmd_file.close()
log_file.close()


#the version of send one command to FPGA once transfer
'''
cmd_num=struct.pack('i',1)#manual is only one command can send
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
		log_info=transfer_once(cmd_num+cmd+addr+data)
		log_file.write(log_info)
	elif cmd==2 or cmd==3 or cmd==4:
		if len(line)!=2:
			continue
		if cmd==2 and (line[1]>int('0x3ff',16)):
			continue
		cmd=struct.pack('i',cmd)
		log_info=transfer_once(cmd_num+cmd+struct.pack('i',line[1]))
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
		area=struct.pack('i',line[3])
		inc_dec=struct.pack('i',line[4])
		cycle=struct.pack('i',line[5])
		jump=struct.pack('i',line[6])
		log_info=transfer_once(cmd_num+cmd+addr+data+area+inc_dec+cycle+jump)
		log_file.write(log_info)
	elif cmd==6:
		if len(line)!=3 or (line[1]>int('0x3ff',16)) or (line[2]>int('0x3ff',16)):
			continue
		cmd=struct.pack('i',cmd)
		addr=struct.pack('i',line[1])
		area=struct.pack('i',line[2])
		log_info=transfer_once(cmd_num+cmd+addr+area)
		log_file.write(log_info)
	else:
		continue
cmd_file.close()
log_file.close()
'''


