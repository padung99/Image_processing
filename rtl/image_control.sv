module image_control #(
  parameter DATA_W     = 8,
  parameter KERNEL_W   = 3,
  parameter RESOLUTION = 512  
) (
  input  logic              clk_i,
  input  logic              srst_i,
  input  logic [DATA_W-1:0] data_pixel_i,
  input  logic              data_pixel_valid_i,
  output logic [DATA_W-1:0] pixel_o [KERNEL_W-1:0] [KERNEL_W-1:0],
  output logic              pixel_valid_o
);

localparam RESOLUTION_W = $clog2( RESOLUTION );

logic [RESOLUTION_W-1:0] wr_pixel_cnt;
logic [1:0]              current_wr_line;
logic [3:0]              data_pixel_valid; 

logic [1:0]        current_rd_line;
logic [DATA_W-1:0] data_line0_buff [KERNEL_W-1:0];
logic [DATA_W-1:0] data_line1_buff [KERNEL_W-1:0];
logic [DATA_W-1:0] data_line2_buff [KERNEL_W-1:0];
logic [DATA_W-1:0] data_line3_buff [KERNEL_W-1:0];

logic [RESOLUTION_W-1:0] rd_pixel_cnt;
logic                    rd_line_buff;
logic [3:0]              pixel_valid;

logic [11:0] total_pixel_cnt;

enum logic  { 
  IDLE_S,
  RD_BUFF_S
} state, next_state;

linebuffer #(
  .DATA_W     ( DATA_W ),
  .KERNEL_W   ( KERNEL_W),
  .RESOLUTION ( RESOLUTION )
) line0 (
  .clk_i ( clk_i ),
  .srst_i ( srst_i ),
  .data_i ( data_pixel_i ),
  .wr_valid_i ( data_pixel_valid[0] ),
  .data_o ( data_line0_buff ),
  .rd_valid_i ( pixel_valid[0] )
);

linebuffer #(
  .DATA_W     ( DATA_W ),
  .KERNEL_W   ( KERNEL_W),
  .RESOLUTION ( RESOLUTION )
) line1 (
  .clk_i ( clk_i ),
  .srst_i ( srst_i ),
  .data_i ( data_pixel_i ),
  .wr_valid_i ( data_pixel_valid[1] ),
  .data_o ( data_line1_buff ),
  .rd_valid_i ( pixel_valid[1] )
);

linebuffer #(
  .DATA_W     ( DATA_W ),
  .KERNEL_W   ( KERNEL_W ),
  .RESOLUTION ( RESOLUTION )
) line2 (
  .clk_i ( clk_i ),
  .srst_i ( srst_i ),
  .data_i ( data_pixel_i ),
  .wr_valid_i ( data_pixel_valid[2] ),
  .data_o ( data_line2_buff ),
  .rd_valid_i ( pixel_valid[2] )
);

linebuffer #(
  .DATA_W     ( DATA_W              ),
  .KERNEL_W   ( KERNEL_W            ),
  .RESOLUTION ( RESOLUTION          )
) line3 (
  .clk_i      ( clk_i               ),
  .srst_i     ( srst_i              ),
  .data_i     ( data_pixel_i        ),
  .wr_valid_i ( data_pixel_valid[3] ),
  .data_o     ( data_line3_buff     ),
  .rd_valid_i ( pixel_valid[3] )
);


////---------------------------------------write to line buffer -----------------------------------
always_ff @( posedge clk_i )
  begin
    if( srst_i )
      wr_pixel_cnt <= '0;
    else
      if( data_pixel_valid_i )
        wr_pixel_cnt <= wr_pixel_cnt + (RESOLUTION_W)'(1);
  end

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      begin
        current_wr_line <= '0;
      end
    else
      if( ( wr_pixel_cnt == RESOLUTION - 1 ) && data_pixel_valid_i )
        begin
          current_wr_line <= current_wr_line + 1;
        end
  end 

always_comb 
  begin
    data_pixel_valid = 4'h0;
    data_pixel_valid[current_wr_line] = data_pixel_valid_i;
  end

////---------------------------------------read from line buffer -----------------------------------

assign pixel_valid_o = rd_line_buff;

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      total_pixel_cnt <= '0;
    else
      if( data_pixel_valid_i && !rd_line_buff )
        total_pixel_cnt <= total_pixel_cnt + 1;
      else if( !data_pixel_valid_i && rd_line_buff )
        total_pixel_cnt <= total_pixel_cnt - 1;
  end

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      state <= IDLE_S;
    else
      state <= next_state;
  end

always_comb
  begin
    next_state = state;
    case( state )
      IDLE_S:
       begin
         if( total_pixel_cnt >= 1536 )
           next_state = RD_BUFF_S;
       end
      
      RD_BUFF_S:
        begin
          if( rd_pixel_cnt == 511 )
            next_state = IDLE_S;
        end
    endcase
  end

always_comb
  begin
    rd_line_buff = 1'b0;
    case( state )
      IDLE_S:
        begin
          if( total_pixel_cnt >= 1536 )
            rd_line_buff = 1'b1;
        end

      RD_BUFF_S:
        begin
          if( rd_pixel_cnt == 511 )
            rd_line_buff = 1'b0;
        end
    endcase
  end

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      begin
        rd_pixel_cnt <= '0;
      end
    else
      if( rd_line_buff )
        rd_pixel_cnt <= rd_pixel_cnt + 1;
  end

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      begin
        current_rd_line <= '0;
      end
    else
      if( ( rd_pixel_cnt == RESOLUTION-1 ) && rd_line_buff )
        current_rd_line <= current_rd_line + 1;
  end

always_comb
  begin
    case( current_rd_line )
        2'd0:
        begin
            pixel_o[0] = data_line0_buff;
            pixel_o[1] = data_line1_buff;
            pixel_o[2] = data_line2_buff;
        end

        2'd1:
        begin
            pixel_o[0] = data_line1_buff;
            pixel_o[1] = data_line2_buff;
            pixel_o[2] = data_line3_buff;
        end

        2'd2:
        begin 
            pixel_o[0] = data_line2_buff;
            pixel_o[1] = data_line3_buff;
            pixel_o[2] = data_line0_buff;
        end

        2'd3:
        begin
            pixel_o[0] = data_line3_buff;
            pixel_o[1] = data_line0_buff;
            pixel_o[2] = data_line1_buff;
        end
    endcase
  end

always_comb
  begin
    case( current_rd_line )
      2'd0:
        begin
          pixel_valid[0] = rd_line_buff;
          pixel_valid[1] = rd_line_buff;
          pixel_valid[2] = rd_line_buff;
          pixel_valid[3] = 1'b0;
        end

      2'd1:
        begin
          pixel_valid[0] = 1'b0;
          pixel_valid[1] = rd_line_buff;
          pixel_valid[2] = rd_line_buff;
          pixel_valid[3] = rd_line_buff;
        end

      2'd2:
        begin
          pixel_valid[0] = rd_line_buff;
          pixel_valid[1] = 1'b0;
          pixel_valid[2] = rd_line_buff;
          pixel_valid[3] = rd_line_buff;
        end

      2'd3:
        begin
          pixel_valid[0] = rd_line_buff;
          pixel_valid[1] = rd_line_buff;
          pixel_valid[2] = 1'b0;
          pixel_valid[3] = rd_line_buff;
        end
    endcase
  end

endmodule
