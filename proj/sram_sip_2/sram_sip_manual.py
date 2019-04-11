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


while(1):
	COM=input('Please input the number of com:\r\n')
	while not(COM.isdigit()):
		COM=input('Please input the number of com:\r\n')
	Baud=input('Please input Baud rate:\r\n')
	while not(Baud.isdigit()):
		Baud=input('Please input Baud rate:\r\n')
	print("Com: "+str(COM)+" Baud: "+str(int(Baud)))
	judge=input('Right? y or n\r\n')
	while(judge!='y' and judge!='n'):
		judge=input('Right? y or n\r\n')
	if judge=='y':
		break
	elif judge=='n':
		continue
	else:
		print('Error Config')
ser=serial.Serial('com'+str(COM),int(Baud))


recv(ser)
while(1):
	print("Some Cmd to choose")
	print(" 1:write_one\n 2:read\n 3:write_all\n 4:read_direct\n 5:write_config\n 6:cut connection\n")
	cmd=int(input("Please input the cmd:\n"))
	while(cmd>6):
		cmd=int(input("Please input the cmd:\n"))
	cmd_inp=struct.pack('i',cmd)
	write_data(cmd_inp)
	if(cmd==1):
		print("write_one\n")
		addr=int(input("input addr:"))
		while(addr>int('0x3ff',16)):
			print("addr range 0-0x3ff\n")
			addr=int(input("input addr:"))
		addr=struct.pack('i',addr)
		write_data(addr)
		data=int(input("input data:"))
		while(data>int('0xff',16)):
			print("data range 0-0xff\n")
			data=int(input("input data:"))
		data=struct.pack('i',data)
		write_data(data)
		recv(ser)
	elif (cmd==2) or (cmd==4):
		if cmd==2:
			print("read\n")
		else:
			print("read_direct\n")
		addr=int(input("input addr:"))
		while(addr>int('0x3ff',16)):
			print("addr range 0-0x3ff\n")
			addr=int(input("input addr:"))
		addr=struct.pack('i',addr)
		write_data(addr)
		recv(ser)
	elif(cmd==3):
		print("write_all\n")
		data=int(input("input data:"))
		while(data>int('0xff',16)):
			print("data range 0-0xff\n")
			data=int(input("input data:"))
		data=struct.pack('i',data)
		write_data(data)
		recv(ser)
	elif(cmd==5):
		print("write_config\n")
		print("please input the config in order:\n")
		print(" 1:start_address\n 2:data\n 3:operation_area\n 4:inc/dec\n 5:cycle\n 6:jump\n")
		addr=int(input("input start_addr:"))
		while(addr>int('0x3ff',16)):
			print("addr range 0-0x3ff\n")
			addr=int(input("input start_addr:"))
		addr=struct.pack('i',addr)
		write_data(addr)
		
		data=int(input("input data:"))
		while(data>int('0xff',16)):
			print("data range 0-0xff\n")
			data=int(input("input data:"))
		data=struct.pack('i',data)
		write_data(data)
		
		op_area=int(input("input operation_area:"))
		while(op_area>int('0x3ff',16)):
			print("op_area range 0-1023\n")
			op_area=int(input("input op_area:"))
		op_area=struct.pack('i',op_area)
		write_data(op_area)
		
		inc_dec=int(input("input inc=0 or dec=1:"))
		while(inc_dec!=0 and inc_dec!=1):
			print("num 1 or 0\n")
			inc_dec=int(input("input inc/dec:"))
		inc_dec=struct.pack('i',inc_dec)
		write_data(inc_dec)
		
		cycle=bool(int(input("cycle or no-cycle:")))
		if cycle==True:
			cycle=struct.pack('i',1)
		else:
			cycle=struct.pack('i',0)
		write_data(cycle)
		
		jump=int(input("input jump step:"))
		while(jump>int('0x3ff',16)):
			print("jump range 0-1023\n")
			jump=int(input("input jump step:"))
		jump=struct.pack('i',jump)
		write_data(jump)
		
		recv(ser)
	else:
		recv(ser)
		break
print("Cut the connection\n")


