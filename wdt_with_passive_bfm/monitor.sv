class monitor;

reg [31:0] m_wwdg_cr=0;
reg[31:0] m_wwdg_cfr=0;
virtual apbif vif;
virtual wdtif vif1;
reg m_wdt_intr=0;	   
function new(virtual wdtif vif1, virtual apbif vif);
	this.vif = vif;
	this.vif1 = vif1;

endfunction

task run;

forever 
begin
@(posedge vif.pclk);
fork
	configure();
        wdtint(); 
join
end
endtask

task configure;

if(vif.penable == 1'b1 && vif.psel==1'b1 && vif.pwrite==1'b1)
	begin
		$display("in configure else task");
	    case (vif.paddr)
		    4'b0000 : m_wwdg_cr = vif.pwdata;
		    4'b0001 : m_wwdg_cfr =vif.pwdata;
	    endcase
	end
endtask

task wdtint;
	if(m_wwdg_cr[7] == 1)
		 begin
		$display("in wdtint task");
	   		if(m_wwdg_cr[6:0] > m_wwdg_cfr[6:0])
		           m_wwdg_cr = m_wwdg_cr-1;
	   	        else
		           m_wdt_intr= 1;
        	 end
endtask
endclass


