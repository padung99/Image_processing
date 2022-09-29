module linebuffer #(
  parameter DATA_W     = 8,
  parameter KERNEL_W   = 3,
  parameter RESOLUTION = 512
) (
  input  logic              clk_i,
  input  logic              srst_i,
  input  logic [DATA_W-1:0] data_i,
  input  logic              wr_valid_i,
  output logic [DATA_W-1:0] data_o [KERNEL_W-1:0],
  input  logic              rd_valid_i
);

localparam RESOLUTION_W = $clog2(RESOLUTION);

logic [DATA_W-1:0] line [RESOLUTION-1:0];
logic [RESOLUTION_W-1:0] wr_ptr;
logic [RESOLUTION_W-1:0] rd_ptr;

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      begin
        wr_ptr <= '0;
        rd_ptr <= '0;
      end
    else
      begin
        if( wr_valid_i )
          wr_ptr <= wr_ptr + (RESOLUTION_W)'(1);
        if( rd_valid_i && wr_ptr >= 3 )
          rd_ptr <= rd_ptr + (RESOLUTION_W)'(1);
      end
  end

always_ff @( posedge clk_i )
  begin
    if( wr_valid_i )
      line[wr_ptr] <= data_i;
  end

// always_comb
//   begin
//     if( wr_ptr > 3 )
//      begin
//       data_o[0] = line[rd_ptr];
//       data_o[1] = line[rd_ptr+1];
//       data_o[2] = line[rd_ptr+2];
//      end
//   end

assign data_o[0] = line[rd_ptr];
assign data_o[1] = line[rd_ptr+1];
assign data_o[2] = line[rd_ptr+2];

endmodule