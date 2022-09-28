module linebuffer_tb;

parameter MAX_DATA = 512;

parameter DATA_W_TB = 8;
parameter KERNEL_W_TB = 3;

bit clk_i_tb;

logic                 srst_i_tb;
logic [DATA_W_TB-1:0] data_i_tb;
logic                 wr_valid_i_tb;
logic [DATA_W_TB-1:0] data_o_tb [KERNEL_W_TB-1:0];
logic                 rd_valid_i_tb;

initial
  forever
    #5 clk_i_tb = !clk_i_tb;

default clocking cb
  @( posedge clk_i_tb );
endclocking

linebuffer #(
  .DATA_W     ( DATA_W_TB     ),
  .KERNEL_W   ( KERNEL_W_TB   )
) dut (
  .clk_i      ( clk_i_tb      ),
  .srst_i     ( srst_i_tb     ),
  .data_i     ( data_i_tb     ),
  .wr_valid_i ( wr_valid_i_tb ),
  .data_o     ( data_o_tb     ),
  .rd_valid_i ( rd_valid_i_tb )
);

task gen_data();

int i;
logic rd_valid;

i = 0;

while( i <= MAX_DATA )
  begin
    wr_valid_i_tb = 1'b1;

    if( wr_valid_i_tb == 1'b1 )
      begin
        data_i_tb = $urandom_range( 2**8-1,0 );
        i++;
      end
    
    if( i == 3 )
      rd_valid_i_tb <= 1'b1;
    
    @( posedge clk_i_tb );

    // rd_valid_i_tb <= rd_valid;
  end

endtask

initial
  begin
    srst_i_tb <= 1'b1;
    @( posedge clk_i_tb );
    srst_i_tb <= 1'b0;
    rd_valid_i_tb <= 1'b1;

    gen_data();
    $display("Test done");
    $stop();
  end

endmodule