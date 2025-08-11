set RTL_PATH "../rtl/"
set LIB_PATH "../libraries/TIMING/CUSTOM ../libraries/TIMING/STDCELL ../libraries/TIMING/IO"
set DESIGN "soc_top"
set WL_MODE top
set TCL_PATH "../synthesis"

# Baseline Libraries
set LIB_LIST { 
    ff_g_1v32_0c.lib 
    ff_hvt_1v32_0c.lib 
    pllclk_fast.lib 
}

# Baseline RTL
set RTL_LIST { 
    soc_top.sv 
    peripherals/clint/clint.sv 
    peripherals/plic/plic_target.sv 
    peripherals/plic/plic_top.sv 
    peripherals/plic/plic_regs.sv 
    peripherals/plic/plic_gateway.sv 
    peripherals/spi/spi_fifo.sv 
    peripherals/spi/spi_controller.sv 
    peripherals/spi/spi_regs.sv 
    peripherals/spi/spi_top.sv 
    peripherals/spi/spi_datapath.sv 
    peripherals/uart/uart_rx.sv 
    peripherals/uart/uart_tx.sv 
    peripherals/uart/uart.sv 
    interconnect/dbus_interconnect.sv 
    core/core_top.sv 
    core/mmu/dtlb.sv 
    core/mmu/mmu.sv 
    core/mmu/itlb.sv 
    core/mmu/ptw.sv 
    core/pipeline/pipeline_top.sv 
    core/pipeline/execute.sv 
    core/pipeline/divider.sv 
    core/pipeline/forward_stall.sv 
    core/pipeline/decode.sv 
    core/pipeline/lsu.sv 
    core/pipeline/cmp_decode.sv 
    core/pipeline/writeback.sv 
    core/pipeline/divide.sv 
    core/pipeline/fetch.sv 
    core/pipeline/reg_file.sv 
    core/pipeline/csr.sv 
    core/pipeline/amo.sv 
    memory/main_mem.sv 
    memory/bmem.sv 
    memory/mem_top.sv 
    memory/bmem_interface.sv 
    memory/icache/icache_top.sv 
    memory/icache/icache_tag_ram.sv 
    memory/icache/icache_data_ram.sv 
    memory/wb_dcache/dcache_tag_ram.sv 
    memory/wb_dcache/dcache_data_ram.sv 
    memory/wb_dcache/wb_dcache_controller.sv 
    memory/wb_dcache/wb_dcache_datapath.sv 
    memory/wb_dcache/wb_dcache_top.sv 
}

set_db hdl_track_filename_row_col true
set_db lp_power_unit mW
set_db init_lib_search_path $LIB_PATH
set_db script_search_path $TCL_PATH 
set_db init_hdl_search_path $RTL_PATH 

set_db hdl_max_memory_address_range 20000
set_db library $LIB_LIST

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

write_hdl > counter_netlist_200M_ff.v
write_sdc > counter_sdc_200M_ff.sdc
report_timing > riscv_timing_report_200M_ff
report_power > riscv_power_report_200M_ff
report_qor > riscv_qor_report_200M_ff

