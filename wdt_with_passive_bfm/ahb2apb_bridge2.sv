
module ahb2apb #
(
   parameter PIPELINE_HRDATA = 0
)
(

  // AHB signals
  input                hclk,
  input                hresetn,
  input        [31:0]  haddr,
  input        [31:0]  hwdata,
  input                hsel,
  input                hwrite,
  input        [ 1:0]  htrans,
  input        [ 2:0]  hsize,
  input        [ 2:0]  hburst,
//  input        [ 3:0]  hprot, 
  input                hreadyin,

  output   reg [31:0]  hrdata,
  output   reg         hready,
  output   reg [ 1:0]  hresp,

  // APB signals

  input                pclk, 
  input                presetn,
  output   reg [31:0]  paddr,
  output       reg     psel0,
  output       reg     psel1,
  output   reg [31:0]  pwdata,
  output   reg         pwrite,
  
  input       [31:0]  prdata0,
  input       [31:0]  prdata1,
 // input               pslverr0,
 // input               pslverr1,
  input               pready0,
  input               pready1,
  output   reg         penable
);

  enum         { BUS_IDLE,
		 SETUP,
		 ACCESS,
		 ACCESS_PIPELINE} next_state, current_state;
  enum integer {IDLE=0,
	        BUSY=1,
		NSEQ=2,
		SEQ=3} htrans_state;

  reg           hready_reg   ;
  reg   [ 1:0]  hresp_reg    ;
  reg   [31:0]  paddr_reg    ;
  reg           psel_reg     ;                
  reg   [31:0]  pwdata_reg   ;
  reg           pwrite_reg   ;
  reg           penable_reg  ;
  reg   [31:0]  prdata_reg   ;
  //reg           pslverr_reg  ;
  
  reg           pready_reg   ;

  generate
     if (PIPELINE_HRDATA == 1)
	 begin
	    always @ (posedge hclk or negedge hresetn)
	    begin
               if(~hresetn)
               begin
                  hrdata <= 32'h00000000;
                  hresp  <= 2'b00;    
               end
               else
               begin
                  hrdata <= prdata_reg;  
                  hresp  <= hresp_reg;
               end
          end
      end
      else
      begin
          assign hrdata     = prdata_reg;
          assign hresp      = hresp_reg;
      end
   endgenerate
   always @(*)
   begin      
   case(paddr[31:11])
//   case(haddr[31:11])
      22'h0:
      begin
        psel0 = 1;
        pready_reg = pready0;
        prdata_reg = prdata0;
    //    pslverr_reg= pslverr0;
      end
      22'h1:
      begin
        psel1 = 1;
        pready_reg = pready1;
        prdata_reg = prdata1;
      //  pslverr_reg= pslverr1;
      end
      default:
      begin
        psel0=0;
        psel1=0;
        pready_reg = pready0;
        prdata_reg = prdata0;
      //  pslverr_reg= pslverr0;
      end
   endcase
   end        
   //assign prdata_reg = prdata;
   //assign pslverr_reg = pslverr;
   //assign pready_reg = pready;
   assign pwdata     = hwdata;

   always @(posedge hclk or negedge hresetn)
   begin
     if(~hresetn)
       current_state <= BUS_IDLE;
     else 
       current_state <= next_state;
   end
   
   always @(*)
   begin
     case (current_state)
        BUS_IDLE :
          if (hsel && htrans == NSEQ && hreadyin) 
          begin
            next_state = SETUP;
            psel_reg   = 1'b1;
            paddr_reg  = haddr;
            hresp_reg  = 2'b00;
            hready_reg = 1'b0;
            penable_reg = 1'b0;
            pwrite_reg = hwrite;
          end
          else
          begin
            next_state = BUS_IDLE;
            psel_reg   = 1'b0;
            paddr_reg  = paddr;
            hresp_reg  = 2'b00;
            hready_reg = 1'b1;
            penable_reg = 1'b0;
            pwrite_reg = 1'b0;     
          end
        SETUP :
          begin
            next_state = ACCESS;
            psel_reg   = 1'b1;
            paddr_reg  = paddr;
            hresp_reg  = 2'b00;
            hready_reg = (PIPELINE_HRDATA) ? 0:1;
            penable_reg = 1'b1;
            pwrite_reg = pwrite_reg;
         end
        ACCESS :
          if(pready0)
            if(PIPELINE_HRDATA == 0)
              if (hsel && (htrans == NSEQ || (htrans == SEQ && hburst != 3'b000)) ) 
              begin
                next_state = SETUP;
                psel_reg   = 1'b1;
                paddr_reg  = haddr;
                hresp_reg  = 2'b00;
                hready_reg = 1'b0;
                penable_reg = 1'b0;
                pwrite_reg = hwrite;
              end
              else
              begin
                next_state = BUS_IDLE;
                psel_reg   = 1'b0;
                paddr_reg  = paddr;
                hresp_reg  = 2'b00;
                hready_reg = 1'b1;
                penable_reg = 1'b0;
                pwrite_reg = pwrite;   
              end
            else
              begin
                next_state = ACCESS_PIPELINE;
                psel_reg   = 1'b0;
                paddr_reg  = paddr;
                hresp_reg  = 2'b00;
                hready_reg = 1'b0;
                penable_reg = 1'b0;
                pwrite_reg = pwrite;
              end
          else   // wait states introduced by slave (pready = 0)
          begin
            next_state = ACCESS  ;
            psel_reg   = psel0;
            paddr_reg  = paddr;
            hresp_reg  = 2'b00;
            hready_reg = 1'b0;
            penable_reg = penable;
            pwrite_reg = pwrite;   
          end
		   
     endcase
   end 
   
   always @(posedge hclk or negedge hresetn)
   begin
      if (~hresetn)
      begin
         hready <= 1'b1;
         paddr  <= 32'h00000000;
         psel0  <= 1'b0;       
         pwrite <= 1'b0;
         penable <= 1'b0;
      end
      else
         hready <= hready_reg;
         paddr  <= paddr_reg;   
         psel0  <= psel_reg;   
         pwrite <= pwrite_reg;
         penable <= penable_reg;
      begin
      end
   end
endmodule


