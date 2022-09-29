module image_processing_top (

// using dump logic signal to compile module
input        clk_i_top,
input        srst_i_top,
input  [7:0] data_i_top,
input        wr_valid_i_top,
output [7:0] data_o_top [2:0],
input        rd_valid_i_top
);

// parameter DATA_W_TOP = 8;
// parameter KERNEL_W_TOP = 3;

logic dump_logic1, dump_logic2;


// This module need to be compiled
linebuffer #(
  .DATA_W (),
  .KERNEL_W (),
  .RESOLUTION ()
) line_buff (
  .clk_i (),
  .srst_i (),
  .data_i (),
  .wr_valid_i (),
  .data_o (),
  .rd_valid_i ()
);

conv #(
  .DATA_W   (),
  .KERNEL_W ()
) convolution (
.clk_i (),
.pixel_data_i (),
.pixel_data_valid_i (),
.pixel_o (),
.pixel_valid_o ()
);

image_control #(
  .DATA_W     (),
  .KERNEL_W   (),
  .RESOLUTION () 
) im_control (
  .clk_i (),
  .srst_i (),
  .data_pixel_i (),
  .data_pixel_valid_i (),
  .pixel_o (),
  .pixel_valid_o ()
);

// dump logic
always_ff @( posedge clk_i_top )
  begin
    if( rd_valid_i_top )
      begin
        data_o_top[0] <= 8'b1;
        data_o_top[1] <= 8'b1;
        data_o_top[2] <= 8'b0;
      end
    
  end

endmodule