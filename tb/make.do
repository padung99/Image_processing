vlib work

set source_file {
  "../rtl/linebuffer.sv"
  "../rtl/conv.sv"
  
  "conv_tb.sv"
}


foreach files $source_file {
  vlog -sv $files
}

#Return the name of last file (without extension .sv)
set fbasename [file rootname [file tail [lindex $source_file end]]]

vsim $fbasename

add log -r /*
add wave -hex -r *
#add wave -hex "sim:/linebuffer_tb/dut/data_o"
#add wave -hex "sim:/linebuffer_tb/dut/line"

add wave -hex "sim:/conv_tb/dut2/pixel_data_i"
add wave -hex "sim:/conv_tb/dut2/mult_data"

view -undock wave
run -all