onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_soc/clk
add wave -noupdate /tb_soc/rst
add wave -noupdate /tb_soc/uut/instr_addr
add wave -noupdate /tb_soc/uut/instr_data
add wave -noupdate /tb_soc/uut/mem_addr
add wave -noupdate /tb_soc/uut/mem_data_r
add wave -noupdate /tb_soc/uut/cpu_instance/datapath_instance/f_iw_register_instance/pc_f
add wave -noupdate /tb_soc/uut/cpu_instance/datapath_instance/f_d_register_instance/pc_iw
add wave -noupdate /tb_soc/uut/cpu_instance/datapath_instance/d_e_register_instance/pc_d
add wave -noupdate /tb_soc/uut/cpu_instance/datapath_instance/d_e_register_instance/pc_e
add wave -noupdate /tb_soc/uut/memory_controller_instance/data_memory_instance/addr
add wave -noupdate /tb_soc/uut/memory_controller_instance/data_memory_instance/wdata
add wave -noupdate /tb_soc/uut/memory_controller_instance/data_memory_instance/rdata
add wave -noupdate /tb_soc/uut/memory_controller_instance/data_memory_instance/data
add wave -noupdate /tb_soc/uut/memory_controller_instance/data_valid
add wave -noupdate /tb_soc/uut/cpu_instance/datapath_instance/rf/we3
add wave -noupdate /tb_soc/uut/cpu_instance/datapath_instance/rf/wa3
add wave -noupdate /tb_soc/uut/cpu_instance/datapath_instance/rf/wd3
add wave -noupdate /tb_soc/uut/cpu_instance/datapath_instance/rf/rf
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 513
configure wave -valuecolwidth 184
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1584 ps}
