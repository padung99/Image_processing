module conv #(
  parameter DATA_W   = 8,
  parameter KERNEL_W = 3
) (
input  logic              clk_i,
input  logic [DATA_W-1:0] pixel_data_i [KERNEL_W-1:0] [KERNEL_W-1:0],
input  logic              pixel_data_valid_i,
output logic [DATA_W-1:0] pixel_o,
output logic              pixel_valid_o
);

logic [DATA_W-1:0] kernel    [KERNEL_W-1:0] [KERNEL_W-1:0];
logic [DATA_W-1:0] mult_data [KERNEL_W-1:0] [KERNEL_W-1:0];
logic [DATA_W-1:0] sum_data;
logic [DATA_W-1:0] sum_data_tmp;

logic mult_valid;
logic sum_valid;


initial
  begin
    kernel = '{'{ 8'd0, 8'd0, 8'd0 }, '{ 8'd0, 8'd1, 8'd0 }, '{ 8'd0, 8'd0, 8'd0 }}; //identify
    // kernel = '{'{ 8'd1, 8'd1, 8'd1 }, '{ 8'd1, 8'd1, 8'd1 }, '{ 8'd1, 8'd1, 8'd1 }}; //blur
  end

always_ff @( posedge clk_i )
  begin
    for( int i = 0; i < KERNEL_W; i++ )
      begin
        for( int j = 0; j < KERNEL_W; j++ )
          begin
            mult_data[i][j] <= pixel_data_i[i][j] * kernel[i][j];
          end
      end
    mult_valid <= pixel_data_valid_i;
  end

always_comb
  begin
    sum_data = '0;
    for( int i = 0; i < KERNEL_W; i++ )
      begin
        for( int j = 0; j < KERNEL_W; j++ )
          begin
            sum_data = sum_data + mult_data[i][j];
          end
      end
  end

always_ff @( posedge clk_i )
  begin
    sum_data_tmp <= sum_data;
    sum_valid    <= mult_valid;
  end

always_ff @( posedge clk_i )
  begin
    pixel_o       <= sum_data_tmp;
    // pixel_o       <= sum_data_tmp/9;
    pixel_valid_o <= sum_valid;
  end



endmodule