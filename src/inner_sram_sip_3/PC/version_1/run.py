import os
import sys
from optparse import OptionParser
from time import sleep
#os.system("gcc -o raw_socket raw_socket.c")
#os.system("make")
#os.system("./raw_socket log.txt 1 2 3 4 5 6")

#cmd 1:write_one 2:read 3:write_all 4:write_config 5:cut connection
#1 addr data 
#2 addr
#3 data
#4 addr data op_times inc_dec cycle
#5 cut_connection

#Note: due to the communicate by Ethernet is different by UART,so the package need to same in different cmd
#so,we may send all same info to FPGA in different cmd,though some info in package is useless,and we will check
#the package in many steps to ensure the info has transmite to IP is right
#the test vector in Ethernet is in the order of cmd addr data times inc_dec cycle
#the send parameter like #os.system("./raw_socket log.txt 1 2 3 4 5 6")
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
parser.add_option("-i","--intput_file",dest="in_fil",help="Input test vector file",type='string',default="vector.txt")
parser.add_option("-o","--output_file",dest="out_fil",help="Output log file",type='string',default="log.txt")
parser.add_option("-e","--execute",dest="exe",help="the execute object",type='string',default="raw_socket")
parser.add_option("-p","--path",dest="path",help="the execute path",type='string',default="./")
(options,args)=parser.parse_args()


in_fil=check_name(options.in_fil)
out_fil=check_name(options.out_fil)
object=options.path+options.exe
para=object+" "+out_fil+" "

file=open(in_fil,'r')
lines=file.readlines()
for line in lines:
	sleep(0.5)
	line=(line.strip()).split()
	for i in range(len(line)):
		line[i]=int(line[i])
	cmd=line[0]
	if cmd==1:
		#check illegal
		if len(line)!=3 or (line[1]>int('0x3ff',16)) or (line[2]>int('0xff',16)):#addr/data overflow
			continue
		print(para+str(cmd)+" "+str(line[1])+" "+str(line[2])+" 0 0 0")
		os.system(para+str(cmd)+" "+str(line[1])+" "+str(line[2])+" 0 0 0")
	elif cmd==2:
		if len(line)!=2 or (line[1]>int('0x3ff',16)):
			continue
		print(para+str(cmd)+" "+str(line[1])+" "+"0 0 0 0")
		os.system(para+str(cmd)+" "+str(line[1])+" "+"0 0 0 0")
	elif cmd==3:
		if len(line)!=2 or (line[1]>int('0xff',16)):
			continue
		print(para+str(cmd)+" 0 "+str(line[1])+" 1023 0 0")
		os.system(para+str(cmd)+" 0 "+str(line[1])+" 1023 0 0")
	elif cmd==4:
		if len(line)!=6 :
			continue
		if (line[1]>int('0x3ff',16)) or (line[2]>int('0xff',16)):
			continue
		if (line[3]>int('0x3ff',16)):
			continue
		if (line[4]!=1 and line[4]!=0) or (line[5]!=1 and line[5]!=0):
			continue
		print(para+str(cmd)+" "+str(line[1])+" "+str(line[2])+" "+str(line[3])+" "+str(line[4])+" "+str(line[5]))
		os.system(para+str(cmd)+" "+str(line[1])+" "+str(line[2])+" "+str(line[3])+" "+str(line[4])+" "+str(line[5]))
	elif cmd==5:
		print(para+str(cmd)+" 0 0 0 0 0")
		os.system(para+str(cmd)+" 0 0 0 0 0")
	else:
		continue
file.close()
