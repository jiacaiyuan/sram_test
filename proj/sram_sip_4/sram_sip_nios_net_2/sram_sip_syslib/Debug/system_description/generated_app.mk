# generated_app.mk
#
# Machine generated for a CPU named "cpu" as defined in:
# D:\sram_test\sram_sip_16\sram_sip_quartus\system0.ptf
#
# Generated: 2019-05-31 21:21:26.809

# DO NOT MODIFY THIS FILE
#
#   Changing this file will have subtle consequences
#   which will almost certainly lead to a nonfunctioning
#   system. If you do modify this file, be aware that your
#   changes will be overwritten and lost when this file
#   is generated again.
#
# DO NOT MODIFY THIS FILE

# assuming the Quartus project directory is the same as the PTF directory
QUARTUS_PROJECT_DIR = D:/sram_test/sram_sip_16/sram_sip_quartus

# the simulation directory is a subdirectory of the PTF directory
SIMDIR = $(QUARTUS_PROJECT_DIR)/system0_sim

DBL_QUOTE := "



verifysysid: dummy_verifysysid_file
.PHONY: verifysysid

dummy_verifysysid_file:
	nios2-download $(JTAG_CABLE)                                --sidp=0x00801040 --id=611894095 --timestamp=1557996746
.PHONY: dummy_verifysysid_file


generated_app_clean:
.PHONY: generated_app_clean
