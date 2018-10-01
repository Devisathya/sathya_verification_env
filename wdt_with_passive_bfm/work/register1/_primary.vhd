library verilog;
use verilog.vl_types.all;
entity register1 is
    port(
        pclk            : in     vl_logic;
        prstn           : in     vl_logic;
        psel            : in     vl_logic;
        penable         : in     vl_logic;
        pwrite          : in     vl_logic;
        paddr           : in     vl_logic_vector(31 downto 0);
        pwdata          : in     vl_logic_vector(31 downto 0);
        prdata          : out    vl_logic_vector(31 downto 0);
        pready          : out    vl_logic
    );
end register1;
