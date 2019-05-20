#SRAM test algorithm

#some cmd
#cmd 1:write_one 2:read 3:write_all 4:read_direct 5:write_config 6:update 7:cut connection
#1 addr data 
#2 addr
#3 data
#4 addr
#5 addr data op_times inc_dec cycle jump
#6 addr area
#7 cut_connection
import os
import sys
from optparse import OptionParser
import random
WRT_ONE=1
READ=2
WRT_ALL=3
READ_D=4
WRT_CFG=5
UPDATE=6
CUT_CONNECT=7
ADDR_RANGE=1023 #3ff
DATA_RANGE=255  #ff
RAND_CNT=100
proba=0.02
def hex_to_int(hex):
	if '0x' in hex:
		num=int(hex,16)
	else:
		hex='0x'+hex
		num=int(hex,16)
	return num

def wrt_all(fil,data,dec):
	if(dec==10):
		cmd=str(WRT_ALL)+" "+str(data)+"\n"
	elif(dec==16):
		cmd=str(WRT_ALL)+" "+str(hex_to_int(data))+"\n"
	else:
		print("Please dec input 10 or 16\n")
	fil.write(cmd)


def wrt_lenth(fil,addr,data,area,dec):
	if area>=int("0x3ff",16):
		area=int("0x3ff",16)
	if(dec==10):
		cmd=str(WRT_CFG)+" "+str(addr)+" "+str(data)+" "+str(area)+" "+"0 0 0\n"
	elif(dec==16):
		cmd=str(WRT_CFG)+" "+str(hex_to_int(addr))+" "+str(hex_to_int(data))+" "+str(area)+" "+"0 0 0\n"
	else:
		print("Please dec input 10 or 16\n")
	fil.write(cmd)	


def wrt_one(fil,addr,data,dec):
	if(dec==10):
		cmd=str(WRT_ONE)+" "+str(addr)+" "+str(data)+"\n"
	elif(dec==16):
		cmd=str(WRT_ONE)+" "+str(hex_to_int(addr))+" "+str(hex_to_int(data))+"\n"
	else:
		print("Please dec input 10 or 16\n")
	fil.write(cmd)


def read_direct_all(fil):
	for i in range(ADDR_RANGE+1):
		cmd=str(READ_D)+" "+str(i)+"\n"
		fil.write(cmd)

def read_direct_one(fil,addr,dec):
	if(dec==10):
		cmd=str(READ_D)+" "+str(addr)+"\n"
	elif(dec==16):
		cmd=str(READ_D)+" "+str(hex_to_int(addr))+"\n"
	else:
		print("Please dec input 10 or 16\n")
	fil.write(cmd)

def read_direct_lenth(fil,addr,area,dec):
	if(dec==10):
		addr=addr
	elif(dec==16):
		addr=hex_to_int(addr)
	for i in range(area+1):
		cmd=str(READ_D)+" "+str(addr+i)+"\n"
	fil.write(cmd)

	
	
	
	
def update_lenth(fil,addr,area,dec):
	if(dec==10):
		cmd=str(UPDATE)+" "+str(addr)+" "+str(area)+"\n"
	elif(dec==16):
		cmd=str(UPDATE)+" "+str(hex_to_int(addr))+" "+str(area)+"\n"
	else:
		print("Please dec input 10 or 16\n")
	fil.write(cmd)

def update_one(fil,addr):
	if(dec==10):
		cmd=str(UPDATE)+" "+str(addr)+" "+str(0)+"\n"
	elif(dec==16):
		cmd=str(UPDATE)+" "+str(hex_to_int(addr))+" "+str(0)+"\n"
	else:
		print("Please dec input 10 or 16\n")
	fil.write(cmd)

def update_all(fil):
	cmd=str(UPDATE)+" "+str(0)+" "+str(ADDR_RANGE)+"\n"
	fil.write(cmd)	
	
	
	
def read_all(fil):
	for i in range(ADDR_RANGE+1):
		cmd=str(READ)+" "+str(i)+"\n"
		fil.write(cmd)

def read_direct_one(fil,addr,dec):
	if(dec==10):
		cmd=str(READ)+" "+str(addr)+"\n"
	elif(dec==16):
		cmd=str(READ)+" "+str(hex_to_int(addr))+"\n"
	else:
		print("Please dec input 10 or 16\n")
	fil.write(cmd)

def read_direct_lenth(fil,addr,area,dec):
	if(dec==10):
		addr=addr
	elif(dec==16):
		addr=hex_to_int(addr)
	for i in range(area+1):
		cmd=str(READ)+" "+str(addr+i)+"\n"
	fil.write(cmd)
	
	
	

def check_name(name):
	name=(name.strip()).split('.')
	return name[0]+".txt"
def read_boundry():
	read_0=str(READ_D)+" "+str(0)+"\n"
	read_1=str(READ_D)+" "+str(1)+"\n"
	read_2=str(READ_D)+" "+str(2)+"\n"
	read_1021=str(READ_D)+" "+str(1021)+"\n"
	read_1022=str(READ_D)+" "+str(1022)+"\n"
	read_1023=str(READ_D)+" "+str(1023)+"\n"
	file.write(read_0+read_1+read_2+read_1021+read_1022+read_1023)
#input info
print("\n\n\n\n")
print(sys.version)
os.system("python -V")
usage="%prog [options]"
version="1.0"
parser=OptionParser(usage,description="SRAM test vector generator",version="%prog "+version)
#in/out file
parser.add_option("-o","--output_file",dest="file",help="Output test vector generator file",type='string',default="algorithm.txt")
(options,args)=parser.parse_args()
print("READY test vector generator")

file_name=check_name(options.file)
file=open(file_name,'w')

# step one:
#write all 00 and read to check
#write all ff and read to check
#write all 5a and read to check
#write all a5 and read to check

print("STEP ONE: scan test")
wrt_all(file,0,10)
read_direct_all(file)

wrt_all(file,'0xff',16)
read_direct_all(file)

wrt_all(file,"0x5a",16)
read_direct_all(file)

wrt_all(file,"0xa5",16)
read_direct_all(file)



# step two:
#algorithm of march-SS
print("STEP TWO: the algorithm of march-ss")
#||(w0)
wrt_all(file,0,10)
#up(r0,r0,w0,r0,w1)
for addr in range(ADDR_RANGE+1):
	read_direct_one(file,addr,10)
	read_direct_one(file,addr,10)
	wrt_one(file,addr,0,10)
	read_direct_one(file,addr,10)
	wrt_one(file,addr,1023,10)

#up(r1,r1,w1,r1,w0)
for addr in range(ADDR_RANGE+1):
	read_direct_one(file,addr,10)
	read_direct_one(file,addr,10)
	wrt_one(file,addr,1023,10)
	read_direct_one(file,addr,10)
	wrt_one(file,addr,0,10)


#down(r0,r0,w0,r0,w1)
for i in range(ADDR_RANGE+1):
	read_direct_one(file,addr,10)
	read_direct_one(file,addr,10)
	wrt_one(file,addr,0,10)
	read_direct_one(file,addr,10)
	wrt_one(file,addr,1023,10)
	
#down(r1,r1,w1,r1,w0)
for i in range(ADDR_RANGE+1):
	read_direct_one(file,addr,10)
	read_direct_one(file,addr,10)
	wrt_one(file,addr,1023,10)
	read_direct_one(file,addr,10)
	wrt_one(file,addr,0,10)
#||(r0)
for addr in range(ADDR_RANGE+1):
	read_direct_one(file,addr,10)


#step three:boundry test
print("STEP THREE: boundry test")
boundry_addr=[int("0x00",16),int("0x01",16),int("0x02",16),int("0x3fd",16),int("0x3fe",16),int("0x3ff",16)]
write_all=str(WRT_ALL)+" "+str(int("0x00",16))+"\n"
file.write(write_all)
for addr in boundry_addr:
	read=str(READ_D)+" "+str(addr)+"\n"
	file.write(read)
for i in boundry_addr:
	cmd=str(WRT_ONE)+" "+str(i)+" "+str(int("0x5a",16))+"\n"
	file.write(cmd)
	cmd_read=str(READ_D)+" "+str(int(i))+"\n"
	if i==int("0x00",16):
		cmd_read=cmd_read+str(READ_D)+" "+str(int(i+1))+"\n"+str(READ_D)+" "+str(int("0x3ff",16))+"\n"
	elif i==int("0x3ff",16):
		cmd_read=cmd_read+str(READ_D)+" "+str(int(i-1))+"\n"+str(READ_D)+" "+str(int("0x00",16))+"\n"
	else:
		cmd_read=cmd_read+str(READ_D)+" "+str(int(i-1))+"\n"+str(READ_D)+" "+str(int(i+1))+"\n"
	file.write(cmd_read)


#step four:random test
print("STEP FOUR: random test")
for i in range(RAND_CNT):
	addr_list=random.sample(range(int("0x00",16),ADDR_RANGE+1),ADDR_RANGE+1)  #0<=x<addr_range
	data_list=random.sample(range(int("0x00",16),DATA_RANGE+1),DATA_RANGE+1)
	
	addr_rand=random.randint(0,ADDR_RANGE)  
	data_rand=random.randint(0,DATA_RANGE)
	write=str(WRT_ONE)+" "+str(addr_list[addr_rand])+" "+str(data_list[data_rand])+"\n"
	read=str(READ_D)+" "+str(addr_list[addr_rand])+"\n"
	if addr_list[addr_rand]==ADDR_RANGE:
		read_before=str(READ_D)+" "+str(addr_list[addr_rand]-1)+"\n"
		read_after=str(READ_D)+" "+str(0)+"\n"
	elif addr_list[addr_rand]==0:
		read_before=str(READ_D)+" "+str(ADDR_RANGE)+"\n"
		read_after=str(READ_D)+" "+str(addr_list[addr_rand]+1)+"\n"
	else:
		read_before=str(READ_D)+" "+str(addr_list[addr_rand]-1)+"\n"
		read_after=str(READ_D)+" "+str(addr_list[addr_rand]+1)+"\n"
	file.write(write+read+read_before+read_after)


#write all and read some addr to judge it's right
print("STEP FIVE: write all but read random for possibility")
write_all=str(WRT_ALL)+" "+str(int("0x00",16))+"\n"
file.write(write_all)
for i in range(RAND_CNT):
	data_list=random.sample(range(int("0x00",16),DATA_RANGE+1),DATA_RANGE+1)
	data_rand=random.randint(0,DATA_RANGE)
	write_all=str(WRT_ALL)+" "+str(data_list[data_rand])+"\n"
	file.write(write_all)
	read_boundry()
	for j in range(int((ADDR_RANGE+1)*proba)):
		addr_list=random.sample(range(int("0x00",16),ADDR_RANGE+1),ADDR_RANGE+1)  #0<=x<addr_range
		addr_rand=random.randint(0,ADDR_RANGE)
		read=str(READ_D)+" "+str(addr_list[addr_rand])+"\n"
		file.write(read)
'''
for i in range(DATA_RANGE+1):
	write_all=str(WRT_ALL)+" "+str(int("0x00",16))+"\n"
	file.write(write_all)
	a=str(WRT_ONE)+" "+str(int("0x3fd",16))+" "+str(i)+"\n"
	b=str(READ_D)+" "+str(int("0x3fd",16))+"\n"
	c=str(READ_D)+" "+str(int("0x3fc",16))+"\n"
	d=str(READ_D)+" "+str(int("0x3fe",16))+"\n"
	file.write(a+b+c+d)
file.close()
'''





