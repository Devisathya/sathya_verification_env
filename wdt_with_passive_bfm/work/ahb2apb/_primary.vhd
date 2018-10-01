library verilog;
use verilog.vl_types.all;
entity ahb2apb is
    generic(
        PIPELINE_HRDATA : integer := 0
    );
    port(
        hclk            : in     vl_logic;
        hresetn         : in     vl_logic;
        haddr           : in     vl_logic_vector(31 downto 0);
        hwdata          : in     vl_logic_vector(31 downto 0);
        hsel            : in     vl_logic;
        hwrite          : in     vl_logic;
        htrans          : in     vl_logic_vector(1 downto 0);
        hsize           : in     vl_logic_vector(2 downto 0);
        hburst          : in     vl_logic_vector(2 downto 0);
        hreadyin        : in     vl_logic;
        hrdata          : out    vl_logic_vector(31 downto 0);
        hready          : out    vl_logic;
        hresp           : out    vl_logic_vector(1 downto 0);
        pclk            : in     vl_logic;
        presetn         : in     vl_logic;
        paddr           : out    vl_logic_vector(31 downto 0);
        psel0           : out    vl_logic;
        psel1           : out    vl_logic;
        pwdata          : out    vl_logic_vector(31 downto 0);
        pwrite          : out    vl_logic;
        prdata0         : in     vl_logic_vector(31 downto 0);
        prdata1         : in     vl_logic_vector(31 downto 0);
        pready0         : in     vl_logic;
        pready1         : in     vl_logic;
        penable         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of PIPELINE_HRDATA : constant is 1;
end ahb2apb;
