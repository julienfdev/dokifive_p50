## Generated SDC file "dokifive_p50_top.sdc"

## Copyright (C) 2025  Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus Prime License Agreement,
## the Altera IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Altera and sold by Altera or its authorized distributors.  Please
## refer to the Altera Software License Subscription Agreements 
## on the Quartus Prime software download page.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 24.1std.0 Build 1077 03/04/2025 SC Lite Edition"

## DATE    "Sat May  3 17:09:40 2025"

##
## DEVICE  "10M50DAF484C7G"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {ADC_CLK_10} -period 100.000 -waveform { 0.000 50.000 } [get_ports {ADC_CLK_10}]
create_clock -name {MAX10_CLK1_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {MAX10_CLK1_50}]
create_clock -name {MAX10_CLK2_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {MAX10_CLK2_50}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {MAX10_CLK1_50}] -rise_to [get_clocks {MAX10_CLK1_50}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {MAX10_CLK1_50}] -fall_to [get_clocks {MAX10_CLK1_50}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {MAX10_CLK1_50}] -rise_to [get_clocks {MAX10_CLK1_50}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {MAX10_CLK1_50}] -fall_to [get_clocks {MAX10_CLK1_50}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {KEY[0]}]
set_input_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {KEY[1]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX0[0]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX0[1]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX0[2]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX0[3]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX0[4]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX0[5]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX0[6]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX0[7]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX1[0]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX1[1]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX1[2]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX1[3]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX1[4]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX1[5]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX1[6]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX1[7]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX2[0]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX2[1]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX2[2]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX2[3]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX2[4]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX2[5]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX2[6]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX2[7]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX3[0]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX3[1]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX3[2]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX3[3]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX3[4]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX3[5]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX3[6]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX3[7]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX4[0]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX4[1]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX4[2]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX4[3]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX4[4]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX4[5]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX4[6]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX4[7]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX5[0]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX5[1]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX5[2]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX5[3]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX5[4]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX5[5]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX5[6]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX5[7]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {LEDR[0]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {LEDR[1]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {LEDR[2]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {LEDR[3]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {LEDR[4]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {LEDR[5]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {LEDR[6]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {LEDR[7]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {LEDR[8]}]
set_output_delay -add_delay  -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {LEDR[9]}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

