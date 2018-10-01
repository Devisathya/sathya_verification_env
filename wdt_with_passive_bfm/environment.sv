class environment;
generator    gen;
driver       dr;

mailbox      g2d;
mailbox      m2s;
monitor      m;
//scoreboard   sb;

function new(virtual ahbif _if,virtual apbif _if1,virtual wdtif w);
g2d = new();
m2s = new();
gen = new(g2d);
dr  = new(g2d,_if);
m = new(w,_if1);
//sb = new(m2s);
endfunction

task run();
 fork
gen.run();
dr.run();
m.run();
//sb.run();
 join
endtask

endclass
