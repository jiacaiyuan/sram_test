import struct
import serial
from time import sleep

def recv(serial):
	data=''
	sleep(1)
	while True:
		while serial.inWaiting() >0:
			data+=(serial.read(1)).decode()
		if data=='':
			continue
		else:
			break
	print('slave computer info: ')
	print(data)
	return data

def write_data(*args):
	i=0
	for i in range(len(args)):
		sleep(1)
		ser.write(args[i])
		ser.write(struct.pack('c','\r'.encode()))
		#Note:for vivado scanf() & getchar()


print("Config UART to Communicate Slave\n")
ser=serial.Serial('com4',115200)

cmd_file=open("cmd.txt",'r')
log_file=open("log.txt",'w')
log_file.write(recv(ser))
lines=cmd_file.readlines()
#file format
#cmd 1:write_one 2:read 3:write_all 4:write_config 5:cut connection
#1 addr data 
#2 addr
#3 data
#4 addr data op_times inc_dec cycle
#5 cut_connection
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
	elif cmd==2 or cmd==3:
		if len(line)!=2:
			continue
		if cmd==2 and (line[1]>int('0x3ff',16)):
			continue
		cmd=struct.pack('i',cmd)
		write_data(cmd,struct.pack('i',line[1]))
		log_file.write(recv(ser))
	elif cmd==4:
		if len(line)!=6 :
			continue
		if (line[1]>int('0x3ff',16)) or (line[2]>int('0xff',16)):
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
		write_data(cmd,addr,data,times,inc_dec,cycle)
		log_file.write(recv(ser))
	elif cmd==5:
		write_data(cmd)
		log_file.write(recv(ser))
	else:
		continue
cmd_file.close()
log_file.close()



