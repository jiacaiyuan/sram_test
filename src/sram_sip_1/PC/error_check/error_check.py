#SRAM test algorithm

#some cmd
#cmd 1:write_one 2:read 3:write_all 4:write_config 5:cut connection
#1 addr data 
#2 addr
#3 data
#4 addr data op_times inc_dec cycle
#5 cut_connection
import os
import sys
from optparse import OptionParser
import random
WRT_ONE=1
READ=2
WRT_ALL=3
WRT_CFG=4
CUT_CONNECT=5
ADDR_RANGE=1023 #3ff
DATA_RANGE=255  #ff
RAND_CNT=100
SRAM=[]
def check_name(name):
	name=(name.strip()).split('.')
	return name[0]+".txt"
def hex_to_int(hex):
	if '0x' in hex:
		num=int(hex,16)
	else:
		hex='0x'+hex
		num=int(hex,16)
	return num
#input info
print("\n\n\n\n")
print(sys.version)
os.system("python -V")
usage="%prog [options]"
version="1.0"
parser=OptionParser(usage,description="SRAM test vector generator",version="%prog "+version)
#in/out file
parser.add_option("-i","--input_file",dest="inp_file",help="Input test vector generator file",type='string',default="algorithm.txt")
parser.add_option("-l","--log_file",dest="log_file",help="Input the generated log file",type='string',default="log.txt")
parser.add_option("-o","--out_file",dest="out_file",help="Output the error log file",type='string',default="error.txt")
(options,args)=parser.parse_args()
v_file_name=check_name(options.inp_file)
l_file_name=check_name(options.log_file)
e_file_name=check_name(options.out_file)


v_file=open(v_file_name,'r')
l_file=open(l_file_name,'r')
e_file=open(e_file_name,'w')

v_lines=v_file.readlines()
l_lines=l_file.readlines()


print("Initial Virtual SRAM")
for i in range(ADDR_RANGE+1):
	SRAM.append(0)
print("Check File")
if len(v_lines)==len(l_lines):
	print("File Intact")
else:
	print("File Wrong")
	exit()
print("Ready to Check WRONG")
for i in range(min(len(l_lines),len(v_lines))):
	
	v_line=(v_lines[i].strip()).split(" ")
	l_line=(l_lines[i].strip()).split(" ")
	#ONE
	if v_line[0]==str(WRT_ONE):
		if len(v_line)!=3:
			print("ERROR CMD")
			e_file.write("ERROR_CMD: "+v_file_name+"("+str(i)+"): "+v_lines[i].strip()+'\n')
			continue
		else:
			#update virtual SRAM
			addr=int(v_line[1])
			data=int(v_line[2])
			SRAM[addr]=data
		if len(l_line)!=3:
			print("ERROR LOG")
			e_file.write("ERROR_LOG: "+l_file_name+"("+str(i+1)+"): "+l_lines[i].strip()+"         "+"CMD: "+v_lines[i].strip()+'\n')
			continue
		else:
			if l_line[0]!='WRITE_ONE' or hex_to_int(l_line[2])!=SRAM[hex_to_int(l_line[1])] :
				print("ERROR LOG")
				e_file.write("ERROR_LOG: "+l_file_name+"("+str(i+1)+"): "+l_lines[i].strip()+"         "+"CMD: "+v_lines[i].strip()+'\n')
			else:
				print("CHECK ONE FINISH")
				continue
	#TWO
	elif v_line[0]==str(READ):
		if len(v_line)!=2:
			print("ERROR CMD")
			e_file.write("ERROR_CMD: "+v_file_name+"("+str(i+1)+"): "+v_lines[i].strip()+'\n')
			continue
		else:
			#read don't need to update virtual SRAM
			if len(l_line)!=3:
				print("ERROR LOG")
				e_file.write("ERROR_LOG: "+l_file_name+"("+str(i+1)+"): "+l_lines[i].strip()+"         "+"CMD: "+v_lines[i].strip()+'\n')
				continue
			if l_line[0]!='READ' or hex_to_int(l_line[1])!=int(v_line[1]) :
				print("ERROR LOG")
				e_file.write("ERROR_LOG_ADDR: "+l_file_name+"("+str(i+1)+"): "+l_lines[i].strip()+"         "+"CMD: "+v_lines[i].strip()+'\n')
				continue
			if hex_to_int(l_line[2])!=SRAM[hex_to_int(l_line[1])]:
				print("ERROR LOG")
				e_file.write("ERROR_LOG_DATA: "+l_file_name+"("+str(i+1)+"): "+l_lines[i].strip()+"         "+"CMD: "+v_lines[i].strip()+' theory: '+str(hex(SRAM[hex_to_int(l_line[1])]))+'\n')
				continue
			else:
				print("CHECK ONE FINISH")
				continue
	#THREE
	elif v_line[0]==str(WRT_ALL):
		if len(v_line)!=2:
			print("ERROR CMD")
			e_file.write("ERROR_CMD: "+v_file_name+"("+str(i+1)+"): "+v_lines[i].strip()+'\n')
			continue
		else:
			data=int(v_line[1])
			for j in range(ADDR_RANGE+1):
				SRAM[j]=data
		if len(l_line)!=2:
			print("ERROR LOG")
			e_file.write("ERROR_LOG: "+l_file_name+"("+str(i+1)+"): "+l_lines[i].strip()+"         "+"CMD: "+v_lines[i].strip()+'\n')
			continue
		else:
			if l_line[0]!='WRITE_ALL' or data!=hex_to_int(l_line[1]):
				print("ERROR LOG")
				e_file.write("ERROR_LOG: "+l_file_name+"("+str(i+1)+"): "+l_lines[i].strip()+"         "+"CMD: "+v_lines[i].strip()+'\n')
				continue
			else:
				print("CHECK ONE FINISH")
	#FOUR
	elif v_line[0]==str(WRT_CFG):
		if len(v_line)!=6:
			print("ERROR CMD")
			e_file.write("ERROR_CMD: "+v_file_name+"("+str(i+1)+"): "+v_lines[i].strip()+'\n')
			continue
		else:
			addr=int(v_line[1])
			data=int(v_line[2])
			times=int(v_line[3])
			inc_dec=int(v_line[4])
			cycle=int(v_line[5])
			for k in range(times+1):
				if inc_dec==0:#inc
					if cycle==0:#no-cycle
						if addr+k<=ADDR_RANGE:
							SRAM[addr+k]=data
					else:#cycle
						SRAM[(addr+k)%(ADDR_RANGE+1)]=data
				else:#inc_dec==1  #dec
					if cycle==0:
						if (addr-k)>=0:
							SRAM[addr-k]=data
					else:#cycle
						if (addr-k)<0:
							SRAM[ADDR_RANGE+1+(addr-k)]=data
						else:
							SRAM[addr-k]=data
		if len(l_line)!=5:
			print("ERROR LOG")
			e_file.write("ERROR_LOG: "+l_file_name+"("+str(i+1)+"): "+l_lines[i].strip()+"         "+"CMD: "+v_lines[i].strip()+'\n')
			continue
		else:
			if l_line[0]!='WRITE_CFG' or (inc_dec*2+cycle)!=hex_to_int(l_line[1]) or hex_to_int(l_line[2])!=times+1 or hex_to_int(l_line[3])!=addr:
				print("ERROR LOG")
				e_file.write("ERROR_LOG: "+l_file_name+"("+str(i+1)+"): "+l_lines[i].strip()+"         "+"CMD: "+v_lines[i].strip()+'\n')
				continue
			else:
				continue
	else:
		print("NO Recognition vector file line "+str(i))
		print("ERROR CMD")
		continue

















