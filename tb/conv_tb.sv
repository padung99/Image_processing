module conv_tb;

parameter DATA_W_TB   = 8;
parameter KERNEL_W_TB = 3;

bit                   clk_i_tb;
logic [DATA_W_TB-1:0] pixel_data_i_tb [KERNEL_W_TB-1:0] [KERNEL_W_TB-1:0];
logic                 pixel_data_valid_i_tb;
logic [DATA_W_TB-1:0] pixel_o_tb;
logic                 pixel_valid_o_tb;

initial
  forever
    #5 clk_i_tb = !clk_i_tb;

default clocking cb
  @( posedge clk_i_tb );
endclocking


conv #(
  .DATA_W           ( DATA_W_TB             ),
  .KERNEL_W         ( KERNEL_W_TB           )
) dut2 (
  .clk_i              ( clk_i_tb              ),
  .pixel_data_i       ( pixel_data_i_tb       ),
  .pixel_data_valid_i ( pixel_data_valid_i_tb ),
  .pixel_o            ( pixel_o_tb            ),
  .pixel_valid_o      ( pixel_valid_o_tb      )
);

// task gen_data();



// endtask

initial
  begin
    pixel_data_i_tb = '{'{ 8'd0, 8'd1, 8'd1 }, '{ 8'd15, 8'd16, 8'd17 }, '{ 8'd18, 8'd19, 8'd20 }};
    pixel_data_valid_i_tb = 1'b1;
    ##20;
    $stop();
  end


endmodule