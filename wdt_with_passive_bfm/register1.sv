module register1(

input logic        pclk  , 
input logic        prstn , 
input logic        psel  ,
input logic        penable,
input logic        pwrite,
input logic [31:0] paddr,
input logic [31:0] pwdata, 
output logic [31:0] prdata,
output logic        pready
);

reg [31:0] memory[1023:0];

always @(posedge pclk or negedge prstn)
begin
if(prstn==0)
begin
	memory[paddr] <= 0;
end
else if((psel==1)&&(pwrite==1)&&(penable==1))
begin
	memory[paddr] <= pwdata;
end
end





always @(*)
begin
 if((psel==1)&&(pwrite==0)&&(penable==1))
begin
prdata <= memory[paddr];
end
end


always @(posedge pclk or negedge prstn)

begin
	if(prstn == 0)
		pready <= 1;
//	else if (psel == 1 && penable == 0)
//		pready <= 0;
	else if (psel == 1 && penable == 1)
		pready <= 1;

end


endmodule

