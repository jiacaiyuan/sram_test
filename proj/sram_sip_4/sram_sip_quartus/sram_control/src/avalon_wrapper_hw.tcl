# TCL File Generated by Component Editor 9.0
# Thu May 16 16:54:20 CST 2019
# DO NOT MODIFY


# +-----------------------------------
# | 
# | avalon_wrapper "avalon_wrapper" v1.0
# | null 2019.05.16.16:54:20
# | 
# | 
# | D:/sram_test/sram_sip_16/sram_sip_quartus/sram_control/src/avalon_wrapper.v
# | 
# |    ./avalon_wrapper.v syn, sim
# |    ./sram_ctrl.v syn, sim
# | 
# +-----------------------------------


# +-----------------------------------
# | module avalon_wrapper
# | 
set_module_property NAME avalon_wrapper
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property GROUP sram_control
set_module_property DISPLAY_NAME avalon_wrapper
set_module_property TOP_LEVEL_HDL_FILE avalon_wrapper.v
set_module_property TOP_LEVEL_HDL_MODULE avalon_wrapper
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file avalon_wrapper.v {SYNTHESIS SIMULATION}
add_file sram_ctrl.v {SYNTHESIS SIMULATION}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point avalon_slave_0
# | 
add_interface avalon_slave_0 avalon end
set_interface_property avalon_slave_0 addressAlignment NATIVE
set_interface_property avalon_slave_0 bridgesToMaster ""
set_interface_property avalon_slave_0 burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_0 holdTime 0
set_interface_property avalon_slave_0 isMemoryDevice false
set_interface_property avalon_slave_0 isNonVolatileStorage false
set_interface_property avalon_slave_0 linewrapBursts false
set_interface_property avalon_slave_0 maximumPendingReadTransactions 0
set_interface_property avalon_slave_0 printableDevice false
set_interface_property avalon_slave_0 readLatency 0
set_interface_property avalon_slave_0 readWaitTime 1
set_interface_property avalon_slave_0 setupTime 0
set_interface_property avalon_slave_0 timingUnits Cycles
set_interface_property avalon_slave_0 writeWaitTime 0

set_interface_property avalon_slave_0 ASSOCIATED_CLOCK clock_sink
set_interface_property avalon_slave_0 ENABLED true

add_interface_port avalon_slave_0 address address Input 3
add_interface_port avalon_slave_0 write write Input 1
add_interface_port avalon_slave_0 writedata writedata Input 32
add_interface_port avalon_slave_0 read read Input 1
add_interface_port avalon_slave_0 readdata readdata Output 32
add_interface_port avalon_slave_0 chipselect chipselect Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clock_reset
# | 
add_interface clock_reset clock end
set_interface_property clock_reset ptfSchematicName ""

set_interface_property clock_reset ENABLED true

add_interface_port clock_reset reset_n reset_n Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point conduit_end
# | 
add_interface conduit_end conduit end

set_interface_property conduit_end ENABLED true

add_interface_port conduit_end led_0 export Output 1
add_interface_port conduit_end led_1 export Output 1
add_interface_port conduit_end led_2 export Output 1
add_interface_port conduit_end led_3 export Output 1
add_interface_port conduit_end s_addr export Output 10
add_interface_port conduit_end s_cen export Output 1
add_interface_port conduit_end s_clk export Output 1
add_interface_port conduit_end s_ddata export Output 8
add_interface_port conduit_end s_oen export Output 1
add_interface_port conduit_end s_qdata export Input 8
add_interface_port conduit_end s_wen export Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clock_sink
# | 
add_interface clock_sink clock end
set_interface_property clock_sink ptfSchematicName ""

set_interface_property clock_sink ENABLED true

add_interface_port clock_sink avalon_clk clk Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point conduit_end_1
# | 
add_interface conduit_end_1 conduit end

set_interface_property conduit_end_1 ENABLED true

add_interface_port conduit_end_1 clk export Input 1
# | 
# +-----------------------------------
