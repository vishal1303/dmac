######################################################################################################
##  File name :       default.xdc
##
##  Details :     Constraints file
##                    FPGA family:       virtex7
##                    FPGA:              xc7vx690t-3ffg1761C
##                    Speedgrade:        -3
##
######################################################################################################

##The following two properties should be set for every design
set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]

######################################################################################################
# PIN ASSIGNMENTS
######################################################################################################
set_property LOC AR22 [get_ports { leds_leds[0] }]
set_property LOC AR23 [get_ports { leds_leds[1] }]
set_property LOC AB7  [get_ports { CLK_pci_sys_clk_n }]
set_property LOC AB8  [get_ports { CLK_pci_sys_clk_p }]
set_property LOC AY35 [get_ports { RST_N_pci_sys_reset_n }]
set_property LOC H19  [get_ports { CLK_sys_clk_p }]
set_property LOC G18  [get_ports { CLK_sys_clk_n }]

# set_property LOC W2   [get_ports { PCIE_rxp_v[0] }]
# set_property LOC AA2  [get_ports { PCIE_rxp_v[1] }]
# set_property LOC AC2  [get_ports { PCIE_rxp_v[2] }]
# set_property LOC AE2  [get_ports { PCIE_rxp_v[3] }]
# set_property LOC AG2  [get_ports { PCIE_rxp_v[4] }]
# set_property LOC AH4  [get_ports { PCIE_rxp_v[5] }]
# set_property LOC AJ2  [get_ports { PCIE_rxp_v[6] }]
# set_property LOC AK4  [get_ports { PCIE_rxp_v[7] }]

# set_property LOC W1   [get_ports { PCIE_rxn_v[0] }]
# set_property LOC AA1  [get_ports { PCIE_rxn_v[1] }]
# set_property LOC AC1  [get_ports { PCIE_rxn_v[2] }]
# set_property LOC AE1  [get_ports { PCIE_rxn_v[3] }]
# set_property LOC AG1  [get_ports { PCIE_rxn_v[4] }]
# set_property LOC AH3  [get_ports { PCIE_rxn_v[5] }]
# set_property LOC AJ1  [get_ports { PCIE_rxn_v[6] }]
# set_property LOC AK3  [get_ports { PCIE_rxn_v[7] }]

# set_property LOC Y4   [get_ports { PCIE_txp[0] }]
# set_property LOC AA6  [get_ports { PCIE_txp[1] }]
# set_property LOC AB4  [get_ports { PCIE_txp[2] }]
# set_property LOC AC6  [get_ports { PCIE_txp[3] }]
# set_property LOC AD4  [get_ports { PCIE_txp[4] }]
# set_property LOC AE6  [get_ports { PCIE_txp[5] }]
# set_property LOC AF4  [get_ports { PCIE_txp[6] }]
# set_property LOC AG6  [get_ports { PCIE_txp[7] }]

# set_property LOC Y3   [get_ports { PCIE_txn[0] }]
# set_property LOC AA5  [get_ports { PCIE_txn[1] }]
# set_property LOC AB3  [get_ports { PCIE_txn[2] }]
# set_property LOC AC5  [get_ports { PCIE_txn[3] }]
# set_property LOC AD3  [get_ports { PCIE_txn[4] }]
# set_property LOC AE5  [get_ports { PCIE_txn[5] }]
# set_property LOC AF3  [get_ports { PCIE_txn[6] }]
# set_property LOC AG5  [get_ports { PCIE_txn[7] }]

######################################################################################################
# I/O STANDARDS
######################################################################################################
set_property IOSTANDARD LVCMOS15    [get_ports { leds_leds[*] }]
set_property IOSTANDARD DIFF_SSTL15 [get_ports { CLK_sys_clk_* }]
set_property IOSTANDARD LVCMOS15    [get_ports { RST_N_pci_sys_reset_n }]
set_property PULLUP     true        [get_ports { RST_N_pci_sys_reset_n }]

######################################################################################################
# CELL LOCATIONS
######################################################################################################
#
# SYS clock 100 MHz (input) signal. The sys_clk_p and sys_clk_n
# signals are the PCI Express reference clock. Virtex-7 GT
# Transceiver architecture requires the use of a dedicated clock
# resources (FPGA input pins) associated with each GT Transceiver.
# To use these pins an IBUFDS primitive (refclk_ibuf) is
# instantiated in user's design.
# Please refer to the Virtex-7 GT Transceiver User Guide
# (UG) for guidelines regarding clock resource selection.
#
#set_property LOC IBUFDS_GTE2_X1Y5 [get_cells { *pci_clk_100mhz_buf }]

#set_property LOC bogus [get_cells -hier -filter { NAME =~ */ext_clk.pipe_clock_i/mmcm_i }]
#set_property LOC bogus [get_cells -hier -filter { NAME =~ *clkgen_pll }]
#set_property LOC bogus [get_cells -hier -filter { NAME =~ *clk_gen_pll }]

######################################################################################################
# TIMING CONSTRAINTS
######################################################################################################

create_clock -name bscan_refclk -period 20 [get_pins host_pciehost_bscan_bscan/TCK]
create_clock -name pci_refclk -period 10 [get_pins *pci_clk_100mhz_buf/O]

## no longer needed?
create_clock -name pci_extclk -period 10 [get_pins *ep7/pcie_ep/inst/inst/gt_top_i/pipe_wrapper_i/pipe_lane[0].gt_wrapper_i/gtx_channel.gtxe2_channel_i/TXOUTCLK]
set_clock_groups -name ___clk_groups_generated_0_1_0_0_0 -physically_exclusive -group [get_clocks clk_125mhz] -group [get_clocks clk_250mhz]
