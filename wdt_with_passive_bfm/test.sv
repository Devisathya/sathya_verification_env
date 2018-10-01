program test(ahbif _if,apbif _if1,wdtif _if2);

 environment env;
initial
begin
 env = new(_if,_if1,_if2);
 env.run();
end

endprogram
