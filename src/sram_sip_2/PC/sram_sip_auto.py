import os
import sys
import struct
import serial
from time import sleep
from optparse import OptionParser

def recv(serial):
	data=''
	sleep(0.05)
	while True:
		while serial.inWaiting() >0:
			data+=(serial.read(1)).decode()
		if data=='':
			continue
		else:
			break
	print('slave computer info: ')
	print(data)
	data=(data.strip())+'\n'
	return data

def write_data(*args):
	i=0
	for i in range(len(args)):
		sleep(0.05)
		ser.write(args[i])
		ser.write(struct.pack('c','\r'.encode()))
		#Note:for vivado scanf() & getchar()
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

print("Config UART to Communicate Slave\n")
ser=serial.Serial('com4',115200)

cmd_file=open(in_fil,'r')
log_file=open(out_fil,'w')
recv(ser)
lines=cmd_file.readlines()
#file format
#cmd 1:write_one 2:read 3:write_all 4:read_direct 5:write_config 6:cut connection
#1 addr data 
#2 addr
#3 data
#4 addr
#5 addr data op_areas inc_dec cycle jump
#6 cut_connection
for line in lines:
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
		write_data(cmd,addr,data)
		log_file.write(recv(ser))
	elif cmd==2 or cmd==3 or cmd==4:
		if len(line)!=2:
			continue
		if cmd==2 and (line[1]>int('0x3ff',16)):
			continue
		cmd=struct.pack('i',cmd)
		write_data(cmd,struct.pack('i',line[1]))
		log_file.write(recv(ser))
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
		write_data(cmd,addr,data,area,inc_dec,cycle,jump)
		log_file.write(recv(ser))
	elif cmd==6:
		write_data(cmd)
		recv(ser)
	else:
		continue
cmd_file.close()
log_file.close()



