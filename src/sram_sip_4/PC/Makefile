#cmd
PY=python

#source
GP_SOURCE = sram_test_algorithm.py
EP_SOURCE = error_check.py
RAP_SOURCE = sram_sip_auto.py
RMP_SOURCE = sram_sip_manual.py

#file
vector_file = cmd.txt
a_log_file = log.txt
m_log_file = man_log.txt
error_file = error.txt

default: gen_v,run_auto

gen_v:
	$(PY) $(GP_SOURCE) -o $(vector_file)

run:
	$(PY) $(RAP_SOURCE) -i $(vector_file) -o $(a_log_file)

man:
	$(PY) $(RMP_SOURCE) -o $(m_log_file)

check:
	$(PY) $(EP_SOURCE) -i $(vector_file) -l $(a_log_file) -o $(error_file)
