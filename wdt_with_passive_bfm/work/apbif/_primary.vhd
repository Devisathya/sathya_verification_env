library verilog;
use verilog.vl_types.all;
entity apbif is
    port(
        pclk            : in     vl_logic;
        prstn           : in     vl_logic
    );
end apbif;
