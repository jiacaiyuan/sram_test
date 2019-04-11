import struct
import serial
from time import sleep

def recv(serial):
	data=''
	sleep(0.02)
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
'''
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
'''
ser=serial.Serial('com'+str(4),int(115200))
recv(ser)

a='1'
b=150
c=200
d=250
e=300

a=struct.pack('c',a.encode())
#a=a.encode()
print(a)
sleep(1)
#ser.write(a)
#ser.write(struct.pack('c','\r'.encode()))
write_data(a)
recv(ser)

b=struct.pack('i',b)
print(b)
sleep(1)
#ser.write(b)
#ser.write(struct.pack('c','\r'.encode()))
write_data(b)
recv(ser)

c=struct.pack('i',c)
print(c)
sleep(1)
write_data(c)
recv(ser)

d=struct.pack('i',d)
e=struct.pack('i',e)
print(d)
print(e)
sleep(1)
write_data(d,e)
recv(ser)