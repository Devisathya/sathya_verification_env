//`include "register1.sv"
`include "wwdt.sv"
`include "wdtif.sv"
`include "apbif.sv"
`include "ahb2apb_bridge2.sv"
`include "ahbif2.sv"
`include "transactor.sv"
`include "generator.sv"
`include "driver3.sv"
`include "monitor1.sv"
//`include "scoreboard.sv"
`include "environment.sv"
`include "test.sv"
module top;

bit hclk;
bit hrstn;
bit hresp;
bit hready;

wire psel0;
wire psel1;
wire pready0;
wire pready1;
wire [31:0] prdata0;
wire [31:0] prdata1;
logic pclk;
logic prstn;
//wire penable;
//wire pwrite;
//wire hready_in;
//wire [31:0] pwdata;
//wire [31:0] paddr;
//wire w_int;
apbif p(pclk,prstn);
wdtif w();
ahbif top(hclk,hrstn);
test ins(top,p,w);
assign hready_in = 1;

always #5 hclk = ~hclk;
always #5 pclk = ~pclk;

ahb2apb w1(
           .hclk(top.hclk),
	   .hresetn(top.hrstn),
	   .haddr(top.haddr),
	   .hwdata(top.hwdata),
	   .hsel(top.hsel),
	   .hwrite(top.hwrite),
	   .htrans(top.htrans),
           .hsize(top.hsize),
           .hburst(top.hburst),
           .hreadyin(hready_in),
           .hrdata(top.hrdata),
           .hready(top.hready),
           .hresp(top.hresp),
           .pclk(p.pclk),
           .presetn(p.prstn),
	   .penable(p.penable),
	   .pwrite(p.pwrite),
	   .pwdata(p.pwdata),
	  .psel0(p.psel),
	  .paddr(p.paddr),
	  .prdata0(prdata0),
	  .pready0(pready0),
	  .psel1(psel1),
	  .pready1(pready1),
	  .prdata1(prdata1)
           );

wdt u1(
           .pclk(p.pclk),
	   .prstn(p.prstn),
	   .paddr(p.paddr),
	  .psel(p.psel),
	  .penable(p.penable), 
	  .pwrite(p.pwrite),
	  .pwdata(p.pwdata),
	  .prdata(prdata0),
	  .pready(pready0),
	  .wdt_intr(w.wdt_intr)
            );
/*register1 u2(
           .pclk(pclk),
	   .prstn(prstn),
	   .paddr(paddr),
	  .psel(psel1),
	  .penable(penable), 
	  .pwrite(pwrite),
	  .pwdata(pwdata),
	  .prdata(prdata1),
	  .pready(pready1)
            );
*/



//always #10 hready = ~hready;

initial begin

 hclk = 0;
 pclk = 0;
 hrstn = 0;
 prstn = 0;
 hresp = 0;
 hready = 1;
 end

initial
begin
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 hrstn = 1;
 prstn = 1;
end


endmodule


