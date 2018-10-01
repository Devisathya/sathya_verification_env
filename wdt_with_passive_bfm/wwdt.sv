//WWDG (Window Watch Dog Timer)
// This watch dog timer will get prescaled clock from APB
// It is a 7-bit down counter


module wdt(
output reg wdt_intr,
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

assign pready =  1;
//watch dog counter register
reg [31:0] wwdg_cr;
//watch dog configuration register
reg[31:0] wwdg_cfr;
//watch dog status register
//reg[31:0] wwdg_sr;
//watchdog activate/deactivate
//reg wdga;


always @(posedge pclk or prstn)
	if (prstn == 1'b0)
	begin
	   wwdg_cr <= 8'h 00; //Disable WWDT. bit 7 is enable/disable bit
           wwdg_cfr<= 7'h 00; //Make Compare window value 0 
   	   wdt_intr <= 0;	   
	end

	else if(penable == 1'b1 && psel==1'b1 && pwrite==1'b1)
	begin
	    case (paddr)
		    4'b0000 : wwdg_cr <= pwdata;
		    4'b0001 : wwdg_cfr <=pwdata;
	    endcase

        end	

//read
always @(posedge pclk)
	if(penable == 1'b1 && psel==1'b1 && pwrite==1'b0)
	begin
	    case (paddr)
		    4'b0000 : prdata <= wwdg_cr;
		    4'b0001 : prdata <= wwdg_cfr;
	    endcase

        end	
//Down counting and wdt logic
always @(posedge pclk)

	if(wwdg_cr[7] == 1)
		 begin
	   		if(wwdg_cr[6:0] > wwdg_cfr[6:0])
			begin
		           wwdg_cr = wwdg_cr-1;
		           //wdt_intr<= 0;
		       end
	   	        else
		           wdt_intr<= 1;
        	 end
endmodule

