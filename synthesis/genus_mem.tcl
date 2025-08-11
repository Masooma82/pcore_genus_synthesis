set RTL_PATH "../rtl/"
set LIB_PATH		"../libraries/TIMING/CUSTOM ../libraries/TIMING/STDCELL ../libraries/TIMING/IO ../libraries/LEF/STDCELL ../libraries/LEF/CUSTOM ../libraries/LEF/IO"
set DESIGN 		"soc_top"
set WL_MODE		top
set TCL_PATH		"../synthesis"
# Baseline Libraries
set LIB_LIST { \
ss_g_1v08_125c.lib \
ss_hvt_1v08_125c.lib \
ram_256x16A_slow_syn.lib \
rom_512x16A_slow_syn.lib  \
pllclk_slow.lib \
}

set LEF_LIST { \
tsmc13fsg_8lm_tech.lef \
tsmc13g_m_macros.lef \
tsmc13hvt_m_macros.lef \
pllclk.lef \
ram_256X16A.lef \
rom_512x16A.lef \
tpz013g2_7lm.lef \
}
# Baseline RTL
set RTL_LIST { \
soc_top.sv \
peripherals/clint/clint.sv \
peripherals/plic/plic_target.sv \
peripherals/plic/plic_top.sv \
peripherals/plic/plic_regs.sv \
peripherals/plic/plic_gateway.sv \
peripherals/spi/spi_fifo.sv \
peripherals/spi/spi_controller.sv \
peripherals/spi/spi_regs.sv \
peripherals/spi/spi_top.sv \
peripherals/spi/spi_datapath.sv \
peripherals/uart/uart_rx.sv \
peripherals/uart/uart_tx.sv \
peripherals/uart/uart.sv \
interconnect/dbus_interconnect.sv \
core/core_top.sv \
core/mmu/dtlb.sv \
core/mmu/mmu.sv \
core/mmu/itlb.sv \
core/mmu/ptw.sv \
core/pipeline/pipeline_top.sv \
core/pipeline/execute.sv \
core/pipeline/divider.sv \
core/pipeline/forward_stall.sv \
core/pipeline/decode.sv \
core/pipeline/lsu.sv \
core/pipeline/cmp_decode.sv \
core/pipeline/writeback.sv \
core/pipeline/divide.sv \
core/pipeline/fetch.sv \
core/pipeline/reg_file.sv \
core/pipeline/csr.sv \
core/pipeline/amo.sv \
memory/main_mem.sv \
memory/bmem.sv \
memory/mem_top.sv \
memory/bmem_interface.sv \
memory/icache/icache_top.sv \
memory/icache/icache_tag_ram.sv \
memory/icache/icache_data_ram.sv \
memory/wb_dcache/dcache_tag_ram.sv \
memory/wb_dcache/dcache_data_ram.sv \
memory/wb_dcache/wb_dcache_controller.sv \
memory/wb_dcache/wb_dcache_datapath.sv \
memory/wb_dcache/wb_dcache_top.sv \
defines/pcore_config_defs.svh \
defines/ddr_defs.svh \
defines/a_ext_defs.svh \
defines/spi_defs.svh \
defines/pcore_interface_defs.svh \
defines/uart_defs.svh \
defines/mmu_defs.svh \
defines/m_ext_defs.svh \
defines/cache_defs.svh \
defines/plic_defs.svh \
defines/pcore_csr_defs.svh \
}




set CAP_TABLE_FILE ../libraries/tsmc13fsg.capTbl
suppress_messages {LBR-30 LBR-31 LBR-40 LBR-41 LBR-72 LBR-77 LBR-162}
set_db hdl_track_filename_row_col true
set_db lp_power_unit mW
set_db init_lib_search_path $LIB_PATH
set_db script_search_path $TCL_PATH 
set_db init_hdl_search_path $RTL_PATH 

set_db hdl_max_memory_address_range 20000

set_db library $LIB_LIST
## PLE
set_db lef_library $LEF_LIST 
set_db cap_table_file $CAP_TABLE_FILE 

## Turning On Genus Legacy Power Engine 
set_db power_engine legacy

read_hdl -sv ../rtl/$RTL_LIST
elaborate soc_top
current_design soc_top
read_sdc ../constraints/constraints_top.sdc
set_db syn_generic_effort high
set_db syn_map_effort high
set_db syn_opt_effort high

syn_generic
syn_map
syn_opt

write_hdl > counter_netlist.v
write_sdc > counter_sdc.sdc
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge  -setuphold split > delays.sdf
report_timing > riscv_timing_report1
report_power > riscv_power_report1
report_qor > riscv_qor_report1

