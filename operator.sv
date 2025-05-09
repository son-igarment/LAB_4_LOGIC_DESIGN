`define BUF_WIDTH 3   
`define BUF_SIZE ( 1<<`BUF_WIDTH )
module operator( clk, rst, buf_in, buf_out, wr_en, rd_en, buf_empty, buf_full, fifo_counter );

input                 rst, clk, wr_en, rd_en;   
input [7:0]           buf_in;                   
output[7:0]           buf_out;                  
output                buf_empty, buf_full;       
output[`BUF_WIDTH :0] fifo_counter;             
  

reg[7:0]              buf_out;
reg                   buf_empty, buf_full;
reg[`BUF_WIDTH :0]    fifo_counter;
reg[`BUF_WIDTH -1:0]  rd_ptr, wr_ptr;           // pointer to read and write addresses  
reg[7:0]              buf_mem[`BUF_SIZE -1 : 0]; //  

always @(fifo_counter)
begin
   buf_empty = (fifo_counter==0);   
   buf_full = (fifo_counter== `BUF_SIZE);  

end

always @(posedge clk or posedge rst)
begin
   if( rst )
       fifo_counter <= 0;		// Reset the counter of FIFO

   else if( (!buf_full && wr_en) && ( !buf_empty && rd_en ) )  //When doing read and write operation simultaneously
       fifo_counter <= fifo_counter;			// At this state, counter value will remain same.

   else if( !buf_full && wr_en )			// When doing only write operation
       fifo_counter <= fifo_counter + 1;

   else if( !buf_empty && rd_en )		//When doing only read operation
       fifo_counter <= fifo_counter - 1;

   else
      fifo_counter <= fifo_counter;			// When doing nothing.
end

always @( posedge clk or posedge rst)
begin
   if( rst )
      buf_out <= 0;		//On reset output of buffer is all 0.
   else
   begin
      if( rd_en && !buf_empty )
         buf_out <= buf_mem[rd_ptr];	//Reading the 8 bit data from buffer location indicated by read pointer

      else
         buf_out <= buf_out;		

   end
end

always @(posedge clk)
begin
   if( wr_en && !buf_full )
      buf_mem[ wr_ptr ] <= buf_in;		//Writing 8 bit data input to buffer location indicated by write pointer

   else
      buf_mem[ wr_ptr ] <= buf_mem[ wr_ptr ];
end

always@(posedge clk or posedge rst)
begin
   if( rst )
   begin
      wr_ptr <= 0;		// Initializing write pointer
      rd_ptr <= 0;		//Initializing read pointer
   end
   else
   begin
      if( !buf_full && wr_en )    
			wr_ptr <= wr_ptr + 1;		// On write operation, Write pointer points to next location
      else  
			wr_ptr <= wr_ptr;

      if( !buf_empty && rd_en )   
			rd_ptr <= rd_ptr + 1;		// On read operation, read pointer points to next location to be read
      else 
			rd_ptr <= rd_ptr;
   end

end
endmodule