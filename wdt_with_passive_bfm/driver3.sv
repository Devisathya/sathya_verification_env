class driver;
 int i;
 int j;
mailbox dmbx;
virtual ahbif hif;
transactor tr;
int inc_num1 = 2;

function new(mailbox dmbx,virtual ahbif hif);
 this.dmbx=dmbx;
 this.hif=hif;
endfunction

task run();
forever 
begin
 wait(hif.hrstn)
begin
 dmbx.get(tr);
 drive_dut(tr);
 hif.hsel <= 0;

/* $display("hburst",tr.hburst);
 $display("hsize",tr.hsize);
 $display("haddr",tr.haddr);
 $display("inc",tr.inc);
 $display("addr array %p",tr.haddr_a);
 $display("hwdata",tr.hwdata);
 $display("hwdata array %p",tr.hwdata_a);
 $display("------------------------------------------------------");
 $display("hburst",hif.hburst);
 $display("hsize",hif.hsize);
 $display("haddr %p",hif.haddr);
 $display("hwdata %p",hif.hwdata);
 $display("******************************************************");*/
end
end
endtask

task drive_dut(transactor tr);
 hif.hburst <= tr.hburst;
 hif.hwrite <= tr.hwrite;
 hif.hsize <= tr.hsize;
 hif.hsel <= 1;

 if(tr.hburst == 'd0)
 begin
 for(i=0;i<1;i++)
 begin
   hif.haddr = tr.haddr_a[i];
   hif.htrans = tr.htrans_a[i];
   @(posedge hif.hclk);
   if(tr.hwrite == 1)
   hif.hwdata = tr.hwdata_a[i];
   while(hif.hready==0)
   //if(hif.hready==0)
  begin
   @(posedge hif.hclk);
 end
 end
 end

if(tr.hburst == 'd3 || tr.hburst == 'd2 )
begin
 for(i=0;i<4;i++)
 begin
 begin
   hif.haddr = tr.haddr_a[i];
   hif.htrans = tr.htrans_a[i];
   @(posedge hif.hclk);
  begin
   hif.haddr = tr.haddr_a[i+1];
   hif.htrans = tr.htrans_a[i+1];
   if(tr.hwrite == 1)
   hif.hwdata = tr.hwdata_a[i];
   while(hif.hready==0)
   //if(hif.hready==0)
  begin
   @(posedge hif.hclk);
 end
 end
 end
 end
end


if(tr.hburst == 'd4 || tr.hburst == 'd5 )
begin
 for(i=0;i<8;i++)
 begin
 begin
   hif.haddr = tr.haddr_a[i];
   hif.htrans = tr.htrans_a[i];
   @(posedge hif.hclk);
  begin
   hif.haddr = tr.haddr_a[i+1];
   hif.htrans = tr.htrans_a[i+1];
   if(tr.hwrite == 1)
   hif.hwdata = tr.hwdata_a[i];
   while(hif.hready==0)
   //if(hif.hready==0)
  begin
   @(posedge hif.hclk);
 end
 end
 end
 end
 end

if(tr.hburst == 'd6 || tr.hburst == 'd7 )
begin
 for(i=0;i<16;i++)
 begin
 begin
   hif.haddr = tr.haddr_a[i];
   hif.htrans = tr.htrans_a[i];
   @(posedge hif.hclk);
  begin
   hif.haddr = tr.haddr_a[i+1];
   hif.htrans = tr.htrans_a[i+1];
   if(tr.hwrite == 1)
   hif.hwdata = tr.hwdata_a[i];
   while(hif.hready==0)
   //if(hif.hready==0)
  begin
   @(posedge hif.hclk);
 end
 end
 end
 end
 end

 if(tr.hburst == 'd1  )
begin
 for(i=0;i<inc_num1;i++)
 begin
 begin
   hif.haddr = tr.haddr_a[i];
   hif.htrans = tr.htrans_a[i];
   @(posedge hif.hclk);
  begin
   hif.haddr = tr.haddr_a[i+1];
   hif.htrans = tr.htrans_a[i+1];
   if(tr.hwrite == 1)
   hif.hwdata = tr.hwdata_a[i];
   while(hif.hready==0)
   //if(hif.hready==0)
  begin
   @(posedge hif.hclk);
 end
 end
 end
 end
 end

endtask

endclass
