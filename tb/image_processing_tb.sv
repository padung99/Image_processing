module image_processing_tb;

parameter BMP_HEADER_NUM = 54; // Header for bmp image
parameter RESOLUTION     = 512*512;
parameter INFILE = "../dog.bmp";
parameter OUTFILE = "../dog_o.bmp";

integer read_id, write_id;
logic [7:0] rd_data [$];
logic [7:0] array_pixel [511:0][511:0];
int total_data;

logic BMP_header [BMP_HEADER_NUM-1:0];

initial
  begin
    read_id = $fopen( INFILE, "rb" );
    $fread( rd_data, read_id );
    total_data = rd_data.size();
    for( int i = 0; i < total_data; i++ )
     $display("[%0d] %x", i, rd_data[i]);
    $fclose( read_id );
    
    // for( int i = 0; i < 512; i++ )
    //   for( int j = 0; j < 512; j++ )
    //     array_pixel[i][j] =  

    // BMP_header[ 0] = 66;BMP_header[28] =24; 
    // BMP_header[ 1] = 77;BMP_header[29] = 0; 
    // BMP_header[ 2] = 54;BMP_header[30] = 0; 
    // BMP_header[ 3] = 0;BMP_header[31] = 0;
    // BMP_header[ 4] = 18;BMP_header[32] = 0;
    // BMP_header[ 5] = 0;BMP_header[33] = 0; 
    // BMP_header[ 6] = 0;BMP_header[34] = 0; 
    // BMP_header[ 7] = 0;BMP_header[35] = 0; 
    // BMP_header[ 8] = 0;BMP_header[36] = 0; 
    // BMP_header[ 9] = 0;BMP_header[37] = 0; 
    // BMP_header[10] = 54;BMP_header[38] = 0; 
    // BMP_header[11] = 0;BMP_header[39] = 0; 
    // BMP_header[12] = 0;BMP_header[40] = 0; 
    // BMP_header[13] = 0;BMP_header[41] = 0; 
    // BMP_header[14] = 40;BMP_header[42] = 0; 
    // BMP_header[15] = 0;BMP_header[43] = 0; 
    // BMP_header[16] = 0;BMP_header[44] = 0; 
    // BMP_header[17] = 0;BMP_header[45] = 0; 
    // BMP_header[18] = 0;BMP_header[46] = 0; 
    // BMP_header[19] = 3;BMP_header[47] = 0;
    // BMP_header[20] = 0;BMP_header[48] = 0;
    // BMP_header[21] = 0;BMP_header[49] = 0; 
    // BMP_header[22] = 0;BMP_header[50] = 0; 
    // BMP_header[23] = 2;BMP_header[51] = 0; 
    // BMP_header[24] = 0;BMP_header[52] = 0; 
    // BMP_header[25] = 0;BMP_header[53] = 0; 
    // BMP_header[26] = 1; BMP_header[27] = 0; 

    write_id = $fopen(OUTFILE, "wb");

    // for( int i = 0; i<BMP_HEADER_NUM; i++ )
    // begin
    //     $fwrite(write_id, "%c", BMP_header[i]); // write the header
    // end

    for( int i = 0; i < RESOLUTION*3; i++ )
      begin
        $fwrite(write_id, "%c", rd_data[i]);
      end
    $stop();
  end  



endmodule