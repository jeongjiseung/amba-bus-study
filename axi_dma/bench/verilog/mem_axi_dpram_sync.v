//--------------------------------------------------------
// Copyright (c) 2013-2015 by Future Design Systems Co., Ltd.
// All right reserved.
//
// http://www.future-ds.com
//--------------------------------------------------------
// mem_axi_dpram_sync.v
//--------------------------------------------------------
// VERSION = 2015.07.13.
//--------------------------------------------------------
// Simple Dual-Port RAM
//  - one port for write
//  - one port for read
//--------------------------------------------------------
// Macros and parameters:
//--------------------------------------------------------
// size of memory in byte: 1<<ADDR_LENGTH
// requires: 'WIDTH_DS' 8-bit BRAM of depth 1<<(ADDR_LENGTH-WIDTH_DSB)
//----------------------------------------------------------------
`timescale 1ns/1ns

module mem_axi_dpram_sync
     #(parameter WIDTH_AD =10 // size of memory in byte
               , WIDTH_DA =32 // width of a line in bytes
               , WIDTH_DS =(WIDTH_DA/8) // width of a line in bytes
               , WIDTH_DSB=clogb2(WIDTH_DS)
               )
(
        input  wire                RESETn
      , input  wire                CLK
      , input  wire [WIDTH_AD-1:0] WADDR
      , input  wire [WIDTH_DA-1:0] WDATA
      , input  wire [WIDTH_DS-1:0] WSTRB
      , input  wire                WEN
      , input  wire [WIDTH_AD-1:0] RADDR
      , output reg  [WIDTH_DA-1:0] RDATA
      , input  wire [WIDTH_DS-1:0] RSTRB
      , input  wire                REN
);
    //----------------------------------------------------
    localparam DEPTH_BIT=(WIDTH_AD-WIDTH_DSB);
    localparam DEPTH=(1<<DEPTH_BIT);
    //----------------------------------------------------
    reg [WIDTH_DA-1:0] mem[0:DEPTH-1];
    //-----------------------------------------------------------
    integer idx;
    wire [WIDTH_AD-WIDTH_DSB-1:0] ta = WADDR[WIDTH_AD-1:WIDTH_DSB];
    wire [WIDTH_AD-WIDTH_DSB-1:0] tb = RADDR[WIDTH_AD-1:WIDTH_DSB];
    //-----------------------------------------------------------
    always @ (posedge CLK or negedge RESETn) begin
    if (RESETn==1'b0) begin
    end else begin
        if (WEN==1'b1) begin

            for (idx=0; idx<WIDTH_DS; idx=idx+1) begin
                 //if (WSTRB[idx]) mem[ta][(idx+1)*8-1:idx*8] <= WDATA[(idx+1)*8-1:idx*8];
                 if (WSTRB[idx]) mem[ta][(idx*8) +: 8] <= WDATA[(idx*8) +: 8];
            end

            if (REN==1'b1) begin
                if (ta===tb) begin
                    if (WSTRB[idx]) RDATA[(idx*8) +: 8] <= WDATA[(idx*8) +: 8];
                    else            RDATA[(idx*8) +: 8] <= mem[ta][(idx*8) +: 8];
                end 
                else begin
                    RDATA <= mem[tb];
                     $display("%m REN) tb=%x", tb);
                     $display("%m REN) mem[tb]=%x", mem[tb]);
                end
            end
        end else begin
            if (REN==1'b1) begin
                RDATA <= mem[tb];
                // $display("%m REN-B) tb=%x", tb);
                // $display("%m REN-B) mem[tb]=%x", mem[tb]);
            end
        end
    end
    end
    //-------------------------------------------------------
    function integer clogb2;
    input [31:0] value;
    reg   [31:0] tmp;
    begin
       tmp = value - 1;
       for (clogb2 = 0; tmp > 0; clogb2 = clogb2 + 1)
          tmp = tmp >> 1;
       end
    endfunction
     //-----------------------------------------------------------
     // synthesis translate_off
     task write;
     input [WIDTH_AD-1:0] addr;
     input [WIDTH_DA-1:0] data;
     input [WIDTH_DS-1:0] be  ;

     reg   [WIDTH_AD-WIDTH_DSB-1:0] ta;
     integer idx;

     begin
			 $display($time,,"%m addr = %8x",addr);
		   
		   $display($time,,"%m data = %0d",data);
           $display($time,,"%m data(h) = %8x",data);

		   $display($time,,"%m be = %b",be);	
		   
           
        //    $display($time,,"%m WIDTH_DSB = %0d",WIDTH_DSB);	
$display($time,,"%m WIDTH_AD-WIDTH_DSB-1 = %0d",WIDTH_AD-WIDTH_DSB-1);
          ta = addr[WIDTH_AD-1:WIDTH_DSB]; // WIDTH_AD =20 , WIDTH_DSB = 2
	      $display($time,,"%m addr[%0d:%0d] = %x",WIDTH_AD-1,WIDTH_DSB,addr[WIDTH_AD-1:WIDTH_DSB]);
	      $display($time,,"%m ta = %8x",ta);
	      $display($time,,"%m ta(b) = %b",ta);

           for (idx=0; idx<WIDTH_DS; idx=idx+1) begin
              if (be[idx]) begin
				   mem[ta][(idx*8) +: 8] = data[(idx*8) +: 8];

                  //$display($time,,"%m data[%0d*8+8] = %x",idx,data[(idx*8) +: 8]); 
                  $display($time,,"%m data[%0d:%0d] = %x",(idx*8)+8,(idx*8),data[(idx*8) +: 8]); 
				  
				end
           end
     end
     endtask
     task read;
     input  [WIDTH_AD-1:0] addr;
     output [WIDTH_DA-1:0] data;
     reg    [WIDTH_AD-WIDTH_DSB-1:0] ta  ;
     integer idx;
     begin
           ta = addr[WIDTH_AD-1:WIDTH_DSB];
           data = mem[ta];

           $display($time,,"%m mem read) data = %x",data); 
     end
     endtask
     // synthesis translate_on
    //-----------------------------------------------------------
endmodule
//--------------------------------------------------------
// Revision History
//
// 2015.07.13: Part-selection syntax used.
// 2013.02.03: Start by Ando Ki (adki@future-ds.com)
//--------------------------------------------------------
