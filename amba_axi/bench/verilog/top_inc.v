localparam SLAVE_EN0 = 1;
localparam SLAVE_EN1 = 1;

   wire  [WIDTH_CID-1:0]     M_MID[0:1]        ;
   wire  [WIDTH_ID-1:0]      M_AWID[0:1]       ;
   wire  [WIDTH_AD-1:0]      M_AWADDR[0:1]     ;
   `ifdef AMBA_AXI4
   wire  [ 7:0]              M_AWLEN[0:1]      ;
   wire                      M_AWLOCK[0:1]     ;
   `else
   wire  [ 3:0]              M_AWLEN [0:1]     ;
   wire  [ 1:0]              M_AWLOCK [0:1]    ;
   `endif
   wire  [ 2:0]              M_AWSIZE [0:1]    ;
   wire  [ 1:0]              M_AWBURST [0:1]   ;
   `ifdef AMBA_AXI_CACHE
   wire  [ 3:0]              M_AWCACHE[0:1]    ;
   `endif
   `ifdef AMBA_AXI_PROT
   wire  [ 2:0]              M_AWPROT [0:1]    ;
   `endif
   wire                      M_AWVALID [0:1]   ;
   wire                      M_AWREADY [0:1]   ;
   `ifdef AMBA_AXI4
   wire  [ 3:0]              M_AWQOS  [0:1]    ;
   wire  [ 3:0]              M_AWREGION [0:1]  ;
   `endif
  
   wire  [WIDTH_ID-1:0]      M_WID [0:1]      ;
   wire  [WIDTH_DA-1:0]      M_WDATA [0:1]     ;
   wire  [WIDTH_DS-1:0]      M_WSTRB [0:1]     ;
   wire                      M_WLAST  [0:1]    ;
   wire                      M_WVALID [0:1]    ;
   wire                      M_WREADY [0:1]    ;
  
   wire  [WIDTH_ID-1:0]      M_BID [0:1]       ;
   wire  [ 1:0]              M_BRESP  [0:1]    ;
   wire                      M_BVALID  [0:1]   ;
   wire                      M_BREADY  [0:1]   ;
 
   wire  [WIDTH_ID-1:0]      M_ARID [0:1]      ;
   wire  [WIDTH_AD-1:0]      M_ARADDR [0:1]    ;
   `ifdef AMBA_AXI4
   wire  [ 7:0]              M_ARLEN [0:1]     ;
   wire                      M_ARLOCK [0:1]    ;
   `else
   wire  [ 3:0]              M_ARLEN  [0:1]    ;
   wire  [ 1:0]              M_ARLOCK  [0:1]   ;
   `endif
   wire  [ 2:0]              M_ARSIZE [0:1]    ;
   wire  [ 1:0]              M_ARBURST [0:1]   ;
   `ifdef AMBA_AXI_CACHE
   wire  [ 3:0]              M_ARCACHE[0:1]    ;
   `endif
   `ifdef AMBA_AXI_PROT
   wire  [ 2:0]              M_ARPROT [0:1]    ;
   `endif
   wire                      M_ARVALID  [0:1]  ;
   wire                      M_ARREADY [0:1]   ;
   `ifdef AMBA_AXI4
   wire  [ 3:0]              M_ARQOS   [0:1]   ;
   wire  [ 3:0]              M_ARREGION [0:1]  ;
   `endif
  
   wire  [WIDTH_ID-1:0]      M_RID  [0:1]      ;
   wire  [WIDTH_DA-1:0]      M_RDATA  [0:1]    ;
   wire  [ 1:0]              M_RRESP  [0:1]    ;
   wire                      M_RLAST  [0:1]    ;
   wire                      M_RVALID [0:1]    ;
   wire                      M_RREADY  [0:1]   ;
  
  reg                       M_CSYSREQ  [0:1]  ;
  wire                      M_CSYSACK [0:1]   ;
  wire                      M_CACTIVE [0:1];
 
 // ----------------------------------------------------
 
   wire  [WIDTH_CID-1:0]     S_MID[0:1]        ;
   wire  [WIDTH_ID-1:0]      S_AWID[0:1]       ;
   wire  [WIDTH_AD-1:0]      S_AWADDR[0:1]     ;
   `ifdef AMBA_AXI4
   wire  [ 7:0]              S_AWLEN[0:1]      ;
   wire                      S_AWLOCK[0:1]     ;
   `else
   wire  [ 3:0]              S_AWLEN [0:1]     ;
   wire  [ 1:0]              S_AWLOCK [0:1]    ;
   `endif
   wire  [ 2:0]              S_AWSIZE [0:1]    ;
   wire  [ 1:0]              S_AWBURST [0:1]   ;
   `ifdef AMBA_AXI_CACHE
   wire  [ 3:0]              S_AWCACHE[0:1]    ;
   `endif
   `ifdef AMBA_AXI_PROT
   wire  [ 2:0]              S_AWPROT [0:1]    ;
   `endif
   wire                      S_AWVALID [0:1]   ;
   wire                      S_AWREADY [0:1]   ;
   `ifdef AMBA_AXI4
   wire  [ 3:0]              S_AWQOS  [0:1]    ;
   wire  [ 3:0]              S_AWREGION [0:1]  ;
   `endif
  
   wire  [WIDTH_ID-1:0]      S_WID [0:1]      ;
   wire  [WIDTH_DA-1:0]      S_WDATA [0:1]     ;
   wire  [WIDTH_DS-1:0]      S_WSTRB [0:1]     ;
   wire                      S_WLAST  [0:1]    ;
   wire                      S_WVALID [0:1]    ;
   wire                      S_WREADY [0:1]    ;
  
   wire  [WIDTH_ID-1:0]      S_BID [0:1]       ;
   wire  [ 1:0]              S_BRESP  [0:1]    ;
   wire                      S_BVALID  [0:1]   ;
   wire                      S_BREADY  [0:1]   ;
 
   wire  [WIDTH_ID-1:0]      S_ARID [0:1]      ;
   wire  [WIDTH_AD-1:0]      S_ARADDR [0:1]    ;
   `ifdef AMBA_AXI4
   wire  [ 7:0]              S_ARLEN [0:1]     ;
   wire                      S_ARLOCK [0:1]    ;
   `else
   wire  [ 3:0]              S_ARLEN  [0:1]    ;
   wire  [ 1:0]              S_ARLOCK  [0:1]   ;
   `endif
   wire  [ 2:0]              S_ARSIZE [0:1]    ;
   wire  [ 1:0]              S_ARBURST [0:1]   ;
   `ifdef AMBA_AXI_CACHE
   wire  [ 3:0]              S_ARCACHE[0:1]    ;
   `endif
   `ifdef AMBA_AXI_PROT
   wire  [ 2:0]              S_ARPROT [0:1]    ;
   `endif
   wire                      S_ARVALID  [0:1]  ;
   wire                      S_ARREADY [0:1]   ;
   `ifdef AMBA_AXI4
   wire  [ 3:0]              S_ARQOS   [0:1]   ;
   wire  [ 3:0]              S_ARREGION [0:1]  ;
   `endif
  
   wire  [WIDTH_ID-1:0]      S_RID  [0:1]      ;
   wire  [WIDTH_DA-1:0]      S_RDATA  [0:1]    ;
   wire  [ 1:0]              S_RRESP  [0:1]    ;
   wire                      S_RLAST  [0:1]    ;
   wire                      S_RVALID [0:1]    ;
   wire                      S_RREADY  [0:1]   ;
  
  reg                       S_CSYSREQ  [0:1]  ;
  wire                      S_CSYSACK [0:1]   ;
  wire                      S_CACTIVE [0:1];
 

