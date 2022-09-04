//--------------------------------------------------------
// Copyright (c) 2013 by Ando Ki.
// All right reserved.
//
// This program is distributed in the hope that it
// will be useful to understand Ando Ki's work,
// BUT WITHOUT ANY WARRANTY.
//--------------------------------------------------------
`timescale 1ns/1ns

`ifndef CLK_FREQ
`define CLK_FREQ     100000000 // 100Mhz
`endif

module top ;
   localparam CLK_FREQ=`CLK_FREQ;
   localparam CLK_PERIOD_HALF=1000000000/(CLK_FREQ*2);

   reg clk = 1'b0;

   always #CLK_PERIOD_HALF clk <= ~clk;

   real stamp, delta;
   initial begin
       repeat (10) @ (posedge clk);
       @ (posedge clk) stamp = $time;
       @ (posedge clk) delta = $time - stamp;
       $display("%m clk %f nsec %f Mhz", delta, 1000.0/delta);
       repeat (10) @ (posedge clk);
       $finish(2);
   end

   initial begin
       $dumpfile("wave.vcd");
       $dumpvars(0);
   end

endmodule

//--------------------------------------------------------
// Revision history:
//
// 2013.07.03.: Started by Ando Ki (adki@dynalith.com)
//--------------------------------------------------------
