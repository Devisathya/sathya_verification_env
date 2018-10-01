library verilog;
use verilog.vl_types.all;
entity ahbif is
    port(
        hclk            : in     vl_logic;
        hrstn           : in     vl_logic
    );
end ahbif;
