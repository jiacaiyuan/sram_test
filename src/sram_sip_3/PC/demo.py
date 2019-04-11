#need to define the BYTE_CNT in the FPGA

import socket
import struct
from time import sleep
s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
s.connect(('202.118.229.189',30))
recive =s.recv(1500)
print(str(recive,encoding="utf-8"))#or using bytes.decode(b) to change the bytes to str
s.send(struct.pack('i',5)+struct.pack('i',1)+struct.pack('i',2)+struct.pack('i',3)+struct.pack('i',4)+struct.pack('i',5)+struct.pack('i',6))
recive =s.recv(1500)
print(str(recive,encoding="utf-8"))
s.close()

'''
#need to define the STRING_CNT in the FPGA
import socket
import struct
from time import sleep
s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
s.connect(('202.118.229.189',30))
recive =s.recv(1500)
print(str(recive,encoding="utf-8"))#or using bytes.decode(b) to change the bytes to str
s.send(b'5 10 1023 10 4\n')
#recive =s.recv(1500)
#print(str(recive,encoding="utf-8"))
#s.send(b'how are you\n')
#recive =s.recv(1500)
#print(str(recive,encoding="utf-8"))
#s.send(b'Q\n')
#recive =s.recv(1500)
#print(str(recive,encoding="utf-8"))
s.close()
'''