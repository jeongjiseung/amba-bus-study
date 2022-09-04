`ifndef BFM_AXI_TASKS_V
`define BFM_AXI_TASKS_V
//----------------------------------------------------------------
//  Copyright (c) 2013 by Ando Ki.
//  All right reserved.
//  http://www.future-ds.com
//  All rights are reserved by Ando Ki.
//  Do not use in any means or/and methods without Ando Ki's permission.
//----------------------------------------------------------------
// bfm_axi_tasks.v
//----------------------------------------------------------------
// VERSION: 2013.02.03.
//---------------------------------------------------------
reg [7:0] dataWB[0:1023];
reg [7:0] dataRB[0:1023];

//`include "bfm_axi_tasks_inc.v"

//----------------------------------------------------------------
// Read-After-Write
task test_raw;
     input [31:0] id;
     input [31:0] saddr; // start address
     input [31:0] depth; // size in byte
     input [31:0] bsize; // burst size in byte
     input [31:0] bleng; // burst length
     reg   [31:0] addr;
     integer      idx, idy, idz, error;
begin

 //$display("====================================== test_raw START ======================================");

    error = 0;
    addr = saddr;

     $display($time,,"%m addr = saddr = 0x%x", saddr);
     $display($time,,"%m depth = %x", depth);
     $display($time,,"%m bsize = %x", bsize);
     $display($time,,"%m bleng = %x", bleng);

    for (idy=0; idy<depth; idy=idy+bsize) begin
       
       $display("###################### idy(%0d) <  depth(%0d) ",idy,depth);

        for (idx=0; idx<bsize; idx=idx+1) begin
            dataWB[idx] = idy + idx + 1;
            $display($time,,"%m dataWB[%0d] = %x (%0d + %0d + 1)", idx, dataWB[idx],idy,idx);
        end
	   


        write_task( id //input [31:0]         id;
                  , addr  //addr;
                  , bsize //size; // 1 ~ 128 byte in a beat
                  , bleng //leng; // 1 ~ 16  beats in a burst
                  , 0     //type; // burst type
                  );

        read_task ( id //input [31:0]         id;
                  , addr  //addr;
                  , bsize //size; // 1 ~ 128 byte in a beat
                  , bleng //leng; // 1 ~ 16  beats in a burst
                  , 0     //type; // burst type
                  );

        for (idz=0; idz<bsize; idz=idz+1) begin

             if (dataWB[idz]!=dataRB[idz]) begin
                 error = error + 1;
                 $display($time,,"%m Error A:0x%x D:0x%x, but 0x%x expected",addr+idz, dataRB[idz], dataWB[idz]);
             end

            
               else begin
                   $display($time,,"%m A:0x%x D:0x%x, but 0x%x expected",addr+idz, dataRB[idz], dataWB[idz]);
                   $display($time,,"%m OK A:0x%x D:0x%x", addr+idz, dataRB[idz]);
               end
            
        end

        addr = addr + bsize;
        $display($time,,"%m test_raw from 0x%08x to 0x%08x %03d-size %03d-leng OK", saddr, saddr+depth-1, bsize, bleng);

    end
    if (error==0) begin
        $display($time,,"%m test_raw from 0x%08x to 0x%08x %03d-size %03d-leng OK", saddr, saddr+depth-1, bsize, bleng);
    end
    
    $display("====================================== test_raw END ======================================");
end
endtask
//----------------------------------------------------------------
// Read-After-Write ALL
// task test_raw_all;
//      input [31:0] id;
//      input [31:0] saddr; // start address
//      input [31:0] depth; // size in byte
//      input [31:0] bsize; // burst size in byte
//      input [31:0] bleng; // burst length
//      reg   [31:0] addr;
//      integer      idx, idy, idz, error;
// begin
//     error = 0;
//     addr = saddr;
//     for (idy=0; idy<depth; idy=idy+bsize) begin
//         for (idx=0; idx<bsize; idx=idx+1) begin
//             dataWB[idx] = idy + idx + 1;
//         end
//         //$display($time,,"%m idy=%03d", idy);
//         write_task( id //input [31:0]         id;
//                   , addr  //addr;
//                   , bsize //size; // 1 ~ 128 byte in a beat
//                   , bleng //leng; // 1 ~ 16  beats in a burst
//                   , 0     //type; // burst type
//                   );
//         addr = addr + bsize;
//     end
//     addr = saddr;
//     for (idy=0; idy<depth; idy=idy+bsize) begin
//         read_task ( id //input [31:0]         id;
//                   , addr  //addr;
//                   , bsize //size; // 1 ~ 128 byte in a beat
//                   , bleng //leng; // 1 ~ 16  beats in a burst
//                   , 0     //type; // burst type
//                   );
//         for (idz=0; idz<bsize; idz=idz+1) begin
//              if ((idy+idz+1)!=dataRB[idz]) begin
//                  error = error + 1;
//                  $display($time,,"%m Error A:0x%x D:0x%x, but 0x%x expected",
//                                   addr+idz, dataRB[idz], idy+idz+1);
//              end
//         end
//         addr = addr + bsize;
//     end
//     if (error==0) $display($time,,"%m test_raw_all from 0x%08x to 0x%08x %03d-size %03d-leng OK", saddr, saddr+depth-1, bsize, bleng);
// end
// endtask
//----------------------------------------------------------------
task read_task;
     input [31:0]         id;
     input [WIDTH_AD-1:0] addr;
     input [31:0]         size; // 1 ~ 128 byte in a beat
     input [31:0]         leng; // 1 ~ 16  beats in a burst
     input [31:0]         type; // burst type
begin

    $display();
     fork
      read_address_channel(id,addr,size,leng,type);
      read_data_channel(id,addr,size,leng,type);
     join

end
endtask
//----------------------------------------------------------------
task read_address_channel;
     input [31:0]         id;
     input [WIDTH_AD-1:0] addr;
     input [31:0]         size; // 1 ~ 128 byte in a beat
     input [31:0]         leng; // 1 ~ 16  beats in a burst
     input [31:0]         type; // burst type
begin
	 
	 @(posedge ACLK);
	  ARID <= #1 id;
	  ARADDR <= #1 addr;
	  ARLEN <= #1 leng-1;
	  ARLOCK <= #1 'b0;
	  ARSIZE <= #1 get_size(size);
	  ARBURST <= #1 type[1:0];

	 `ifdef AMBA_AXI_PROT
	     APPROT <= #1 'h0;
	 `endif

	  ARVALID <= #1 'b1;

     //$display($time,,"%m ARID=%0x ",ARID);
     $display($time,,"%m ARADDR=%0x ",ARADDR);
     $display($time,,"%m ARBURST=%0x",ARBURST);


	  @(posedge ACLK);
	  while(ARREADY == 1'b0) @(posedge ACLK);

	  ARVALID <= #1 'b0;
	  @(negedge ACLK);

	  
end
endtask
//----------------------------------------------------------------
task read_data_channel;
     input [31:0]         id;
     input [WIDTH_AD-1:0] addr;
     input [31:0]         size; // 1 ~ 128 byte in a beat
     input [31:0]         leng; // 1 ~ 16  beats in a burst
     input [31:0]         type; // burst type
     reg   [WIDTH_AD-1:0] naddr;
     reg   [WIDTH_DS-1:0] strb;
     reg   [WIDTH_DA-1:0] maskT;
     reg   [WIDTH_DA-1:0] dataR;
     integer idx, idy, idz;
begin

     idz = 0;
     naddr  = addr;


     @ (posedge ACLK);
     RREADY <= #1 1'b1;

     for (idx=0; idx<leng; idx=idx+1) begin

          @ (posedge ACLK);
          while (RVALID==1'b0) @ (posedge ACLK);
          
          strb = get_strb(naddr, size);
          dataR = RDATA;

 $display("------------------------- < read_data_channel > -------------------------");
          for (idy=0; idy<WIDTH_DS; idy=idy+1) begin
               
               //$display("------------------------- idy=%0d < leng=%0x -------------------------",idy,WIDTH_DS);

               if (strb[idy]) begin
                   dataRB[idz] = dataR&8'hFF; // justified
                   $display($time,,"%m !! dataRB[%0d] = %0x ",idz,dataRB[idz]);
                   idz = idz + 1;
               end
               dataR = dataR>>8;
               //$display($time,,"%m dataR = %0x ",dataR);
          end

          if (id!=RID) begin
             $display($time,,"%m Error id/RID mis-match for read-data-channel", id, RID);
          end

          if (idx==leng-1) begin
             if (RLAST==1'b0) begin
                 $display($time,,"%m Error RLAST expected for read-data-channel");
             end
          end else begin
              @ (negedge ACLK);
              naddr = get_next_addr( naddr  // current address
                                   , size  // num of bytes in a beat
                                   , type);// type of burst
          end
     end

     RREADY <= #1 'b0;
     @ (negedge ACLK);
	 
end
endtask
//----------------------------------------------------------------
task write_task;
     input [31:0]         id;
     input [WIDTH_AD-1:0] addr;
     input [31:0]         size; // 1 ~ 128 byte in a beat
     input [31:0]         leng; // 1 ~ 16  beats in a burst
     input [31:0]         type; // burst type
begin
     
	fork
	    write_address_channel(id,addr,size,leng,type);
		write_data_channel(id,addr,size,leng,type);
		write_resp_channel(id);
	join
	
end
endtask
//----------------------------------------------------------------
task write_address_channel;
     input [31:0]         id;
     input [WIDTH_AD-1:0] addr;
     input [31:0]         size; // 1 ~ 128 byte in a beat
     input [31:0]         leng; // 1 ~ 16  beats in a burst
     input [31:0]         type; // burst type
begin
	
	@(posedge ACLK);
	AWID <= #1 id;
	AWADDR <= #1 addr;
	AWLEN <= #1 leng-1;
	AWLOCK <= #1 1'b0;
	AWSIZE <= #1 get_size(size);
	AWBURST <= #1 type[1:0];
	
	`ifdef AMBA_AXI_PROT
	   AWPROT <= #1 'h0;
	`endif
	 
	 AWVALID <= #1 'b1;
	 
     //$display($time,,"%m AWID=%0x ",AWID);
     $display($time,,"%m AWADDR=%0x ",AWADDR);
     $display($time,,"%m AWBURST=%0x",AWBURST);
     //$display($time,,"%m AWVALID(A) = %0x",AWVALID);

	 @(posedge ACLK);
	 while(AWREADY == 1'b0) @(posedge ACLK);
	 
     AWVALID <= #1 1'b0;
     //$display($time,,"%m AWVALID(B) = %0x",AWVALID);
	 
	 @(negedge ACLK);
	
	
	
end
endtask
//----------------------------------------------------------------
task write_data_channel;
     input [31:0]         id;
     input [WIDTH_AD-1:0] addr;
     input [31:0]         size; // 1 ~ 128 byte in a beat
     input [31:0]         leng; // 1 ~ 16  beats in a burst
     input [31:0]         type; // burst type

     reg   [WIDTH_AD-1:0] naddr;
     integer idx;
begin

     naddr  = addr;
     @ (posedge ACLK);
     WID    <= #1 id;
     WVALID <= #1 1'b1;

    // $display($time,,"%m WID=id=%0x ",WID);
     $display($time,,"%m addr=naddr=%x",naddr);
     $display($time,,"%m size=%0x , leng=%0x",size,leng);
    // $display($time,,"%m burst type = %0d",type);

     for (idx=0; idx<leng; idx=idx+1) begin // burst length ,bleng
        
         $display("------------------------- idx=%0d < leng=%0x -------------------------",idx,leng);

          WDATA <= #1 get_data(addr, naddr, size);
          WSTRB <= #1 get_strb(naddr, size);
          WLAST <= #1 (idx==(leng-1));
          naddr <= get_next_addr(naddr, size, type);

          $display($time,,"%m WDATA=%x",WDATA);
          //$display($time,,"%m WSTRB=%0x",WSTRB);
          $display($time,,"%m WLAST=%0x",WLAST);
          $display($time,,"%m naddr=%x",naddr);

          @ (posedge ACLK);
          while (WREADY==1'b0) @ (posedge ACLK);

     end

     WLAST  <= #1 'b0;
     WVALID <= #1 'b0;
     @ (negedge ACLK);

 //$display($time,,"%m why not here? ");
		 
end
endtask

//----------------------------------------------------------------
task write_resp_channel;
     input [31:0] id;
begin
     
	 BREADY <= #1 1'b1;
	 @(posedge ACLK);
     
	 while(BVALID == 1'b0) begin
         @(posedge ACLK);
     end

     if(id != BID) begin
	  $display($time , "%m Error id mismatch for write-resp-channel 0x%x/0x%x ",id,BID);
	  end else begin
	  case(BRESP)
	     2'b00:begin
              $display($time , "%m OK response for write-resp-channel: OKAY");
            end
		 2'b01: $display($time , "%m OK response for write-resp-channel: EXOKAY");
		 2'b10: $display($time , "%m Error response for write-resp-channel: SLVERR");
		 2'b11: $display($time , "%m Error response for write-resp-channel: DECERR");
		endcase
		end

		BREADY <= #1 1'b0;
		@(negedge ACLK);
	 
end
endtask
//----------------------------------------------------------------
// input: num of bytes
// output: AxSIZE[2:0] code
function [2:0] get_size;
   input [7:0] size;
begin
   case (size)
     1: get_size = 0;
     2: get_size = 1;
     4: get_size = 2;
     8: get_size = 3;
    16: get_size = 4;
    32: get_size = 5;
    64: get_size = 6;
   128: get_size = 7;
   default: get_size = 0;
   endcase
end
endfunction
//----------------------------------------------------------------
function [WIDTH_DS-1:0] get_strb;
    input [31:0] addr;
    input [31:0] size; // num of bytes in a beat
    integer offset;
    reg   [127:0] bit_size;
begin
    offset   = addr%WIDTH_DS;
    
    $display($time,,"%m get_strb ) size:%X ",size);

    case (size)
        1: bit_size = {  1{1'b1}};
        2: bit_size = {  2{1'b1}};
        4: bit_size = {  4{1'b1}};
        8: bit_size = {  8{1'b1}};
        16: bit_size = { 16{1'b1}};
        32: bit_size = { 32{1'b1}};
        64: bit_size = { 64{1'b1}};
        128: bit_size = {128{1'b1}};
        default: bit_size = 0;
    endcase
    
    get_strb = bit_size<<offset;
    $display($time,,"%m get_strb : %X",get_strb);

end
endfunction
//----------------------------------------------------------------
function [WIDTH_AD-1:0] get_next_addr;
    input [31:0] addr; // current address
    input [31:0] size; // num of bytes in a beat
    input [31:0] type; // type of burst
    integer offset;
begin
    case (type[1:0])
    2'b00: get_next_addr = addr; // fixed
    2'b01: begin // increment
           offset = addr%WIDTH_DS;
           if ((offset+size)<=WIDTH_DS) begin
               get_next_addr = addr + size;
           end else begin // (offset+size)>nb
               get_next_addr = addr + WIDTH_DS - size;
           end
           end
    2'b10: begin // wrap
           if ((addr%size)!=0) begin
              $display($time,,"%m wrap-burst not aligned");
              get_next_addr = addr;
           end else begin
               offset = addr%WIDTH_DS;
               if ((offset+size)<=WIDTH_DS) begin
                   get_next_addr = addr + size;
               end else begin // (offset+size)>nb
                   get_next_addr = addr + WIDTH_DS - size;
               end
           end
           end
    default: $display($time,,"%m Error un-defined burst-type: %2b", type);
    endcase
end
endfunction
//----------------------------------------------------------------
// dataWB[0]   = saddr + 0;
// dataWB[1]   = saddr + 1;
// dataWB[2]   = saddr + 2;
//
function [WIDTH_DA-1:0] get_data;
    input [WIDTH_AD-1:0] saddr; // start address
    input [WIDTH_AD-1:0] addr;  // current address
    input [31:0]         size;

    reg   [ 7:0]         data[0:WIDTH_DS-1];
    integer offset, idx, idy, idz, ids;

begin
    `ifdef RIGOR
        $display($time,,"%m RIGOR",);
        for (idx=0; idx<WIDTH_DS; idx=idx+1) begin
            data[idx] = 'bX;
        end
    `endif
    
    offset = addr%WIDTH_DS;
    ids = 0;
   $display($time,,"%m offset:%x",offset);

    //for (idx=addr%WIDTH_DS; (idx<WIDTH_DS)&&(ids<size); idx=idx+1) begin
    for (idx = offset; (idx<WIDTH_DS)&&(ids<size); idx=idx+1) begin
         idz = addr+(idx-offset)-saddr;
   
         $display($time,,"%m dataWB[%0d] = %x", idz,dataWB[idz]);

         data[idx] = dataWB[idz];
   
         ids = ids + 1;
    end

    get_data = 0;
   
    for (idy=0; idy<WIDTH_DS; idy=idy+1) begin
         get_data = get_data|(data[idy]<<(8*idy));
    end
   
end
endfunction
//----------------------------------------------------------------

// task test_raw_burst;
//      input [31:0] id;
//      input [31:0] saddr; // start address
//      input [31:0] depth; // size in byte
//      input [31:0] bsize; // burst size in byte
//      input [31:0] bleng; // burst length
//      reg   [31:0] addr;
//      integer      idx, idy, idz, error;
// begin
//     error = 0;
//     addr = saddr;
//     for (idy=0; idy<depth; idy=idy+bsize*bleng) begin
//         for (idx=0; idx<bsize*bleng; idx=idx+1) begin
//             dataWB[idx] = idy + idx + 1;
//         end
// 	   //$display($time,,"%m idy=%03d", idy);
//         write_task( id //input [31:0]         id;
//                   , addr  //addr;
//                   , bsize //size; // 1 ~ 128 byte in a beat
//                   , bleng //leng; // 1 ~ 16  beats in a burst
//                   , 2'h1     //type; // burst type = INCR
//                   );

//         read_task ( id //input [31:0]         id;
//                   , addr  //addr;
//                   , bsize //size; // 1 ~ 128 byte in a beat
//                   , bleng //leng; // 1 ~ 16  beats in a burst
//                   , 2'h1     //type; // burst type = INCR
//                   );
//         for (idz=0; idz<bsize*bleng; idz=idz+1) begin
//              if (dataWB[idz]!=dataRB[idz]) begin
//                  error = error + 1;
//                  $display($time,,"%m Error A:0x%x D:0x%x, but 0x%x expected",
//                                   addr+idz, dataRB[idz], dataWB[idz]);
//              end
//              `ifdef DEBUG
//              else $display($time,,"%m OK A:0x%x D:0x%x", addr+idy+idz, dataRB[idz]);
//              `endif
//         end
//         addr = addr + bsize*bleng;
//     end
//     if (error==0) $display($time,,"%m test_raw from 0x%08x to 0x%08x %03d-size %03d-leng OK", saddr, saddr+depth-1, bsize, bleng);
// end
// endtask





//----------------------------------------------------------------
// Revision History
//
// 2013.02.03: Started by Ando Ki (adki@future-ds.com)
//----------------------------------------------------------------
`endif
