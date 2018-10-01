interface ahbif(input hclk, input hrstn);
logic 	[31:0]	haddr;
logic 	[02:0]  hburst;
logic 		hready;
logic   [01:0]		hresp ;
logic 	[31:0] 	hwdata;
logic	[31:0] 	hrdata;
logic 	[02:0]	hsize;
logic 	[01:0] 	htrans;
logic		hsel;
logic 	        hwrite;
logic  		hready_in;
endinterface
