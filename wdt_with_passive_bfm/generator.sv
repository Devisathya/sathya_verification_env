class generator;
  transactor tr;

 mailbox gmbx; 

 function new(mailbox gmbx);
  this.gmbx=gmbx;
 endfunction

 task run();
//  repeat(2)
 begin
  tr = new();
 assert(tr.randomize());
/* $display("hburst",tr.hburst);
 $display("hsize",tr.hsize);
 $display("haddr",tr.haddr);
 $display("inc",tr.inc);
 $display("addr array %p",tr.haddr_a);
 $display("hwadata",tr.hwdata);
 $display("hwadata array %p",tr.hwdata_a);
 $display("------------------------------------------------------");*/
  gmbx.put(tr);
 end
 endtask

endclass
