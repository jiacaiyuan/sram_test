#cmd
CC = gcc
PY = python
DIR=./
#source file
C_SOURCE = raw_socket.c
L_SOURCE = raw_socket.o
C_TARGET = raw_socket

GP_SOURCE = sram_test_algorithm.py
EP_SOURCE = error_check_eth.py
RP_SOURCE = run.py 

vector_file = cmd.txt
log_file = log.txt
error_file = error.txt


default: com_c gen_v run check







com_c: link
	$(CC) -o $(C_TARGET) $(L_SOURCE)	
link:
	$(CC) -c $(DIR)$(C_SOURCE)

gen_v:
	$(PY) $(GP_SOURCE) -o $(vector_file)

run:
	$(PY) $(RP_SOURCE) -i $(vector_file) -o $(log_file) -e $(C_TARGET) -p $(DIR)
check:
	$(PY) $(EP_SOURCE) -i $(vector_file) -l $(log_file) -o $(error_file)







.PHONY:clean
clean:
	-rm *.o $(C_TARGET) $(vector_file) $(log_file) $(error_file)
