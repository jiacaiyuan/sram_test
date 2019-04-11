import struct
import socket
from time import sleep

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

while(1):
	s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
	print("Some Cmd to choose")
	print(" 1:write_one\n 2:read\n 3:write_all\n 4:read_direct\n 5:write_config\n 6:cut connection\n")
	cmd=int(input("Please input the cmd:\n"))
	while(cmd>6):
		cmd=int(input("Please input the cmd:\n"))
	cmd_inp=struct.pack('i',cmd)
	if(cmd==1):
		print("write_one\n")
		addr=int(input("input addr:"))
		while(addr>int('0x3ff',16)):
			print("addr range 0-0x3ff\n")
			addr=int(input("input addr:"))
		addr=struct.pack('i',addr)
		data=int(input("input data:"))
		while(data>int('0xff',16)):
			print("data range 0-0xff\n")
			data=int(input("input data:"))
		data=struct.pack('i',data)
		transfer_once(cmd_inp+addr+data)
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
		transfer_once(cmd_inp+addr)
	elif(cmd==3):
		print("write_all\n")
		data=int(input("input data:"))
		while(data>int('0xff',16)):
			print("data range 0-0xff\n")
			data=int(input("input data:"))
		data=struct.pack('i',data)
		transfer_once(cmd_inp+data)
	elif(cmd==5):
		print("write_config\n")
		print("please input the config in order:\n")
		print(" 1:start_address\n 2:data\n 3:operation_area\n 4:inc/dec\n 5:cycle\n 6:jump\n")
		addr=int(input("input start_addr:"))
		while(addr>int('0x3ff',16)):
			print("addr range 0-0x3ff\n")
			addr=int(input("input start_addr:"))
		addr=struct.pack('i',addr)
		
		data=int(input("input data:"))
		while(data>int('0xff',16)):
			print("data range 0-0xff\n")
			data=int(input("input data:"))
		data=struct.pack('i',data)
		
		op_area=int(input("input operation_area:"))
		while(op_area>int('0x3ff',16)):
			print("op_area range 0-1023\n")
			op_area=int(input("input op_area:"))
		op_area=struct.pack('i',op_area)
		
		inc_dec=int(input("input inc=0 or dec=1:"))
		while(inc_dec!=0 and inc_dec!=1):
			print("num 1 or 0\n")
			inc_dec=int(input("input inc/dec:"))
		inc_dec=struct.pack('i',inc_dec)
		
		cycle=bool(int(input("cycle or no-cycle:")))
		if cycle==True:
			cycle=struct.pack('i',1)
		else:
			cycle=struct.pack('i',0)
		
		jump=int(input("input jump step:"))
		while(jump>int('0x3ff',16)):
			print("jump range 0-1023\n")
			jump=int(input("input jump step:"))
		jump=struct.pack('i',jump)
		
		transfer_once(cmd_inp+addr+data+op_area+inc_dec+cycle+jump)
	else:
		judge=input("Rready to cut connection? y or n\n")
		while(judge!='y' and judge!='n'):
			judge=input("Rready to cut connection? y or n\n")
		if judge=='y':
			break
		elif judge=='n':
			continue
		else:
			break
print("Cut the connection\n")


