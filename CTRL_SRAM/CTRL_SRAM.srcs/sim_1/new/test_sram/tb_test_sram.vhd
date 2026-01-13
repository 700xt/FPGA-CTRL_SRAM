library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_SDRAM_ctrl_sram is
end tb_SDRAM_ctrl_sram;

architecture behavior of tb_SDRAM_ctrl_sram is

    --------------------------------------------------------------------
    -- Composant SDRAM_ctrl (COPIE EXACTE DE L'ENTITY)
    --------------------------------------------------------------------
    component SDRAM_ctrl is
        Port ( 
            usr_data_in  : in  STD_LOGIC_VECTOR (31 downto 0);
            usr_data_out : out STD_LOGIC_VECTOR (31 downto 0);
            RW           : in  STD_LOGIC;
            ctrl_RW      : in  STD_LOGIC;
            clk          : in  STD_LOGIC;
            usr_addr     : in  STD_LOGIC_VECTOR (18 downto 0);
            DQ           : inout STD_LOGIC_VECTOR (35 downto 0);
            addr         : out STD_LOGIC_VECTOR (18 downto 0);
            reset        : in  STD_LOGIC;
            nCKE         : out STD_LOGIC;
            Lbo_n        : out STD_LOGIC;
            Cke_n        : out STD_LOGIC;
            Ld_n         : out STD_LOGIC;
            Bwa_n        : out STD_LOGIC;
            Bwb_n        : out STD_LOGIC;
            Bwc_n        : out STD_LOGIC;
            Bwd_n        : out STD_LOGIC;
            Rw_n         : out STD_LOGIC;
            Oe_n         : out STD_LOGIC;
            Ce_n         : out STD_LOGIC;
            Ce2_n        : out STD_LOGIC;
            Ce2          : out STD_LOGIC;
            Zz           : out STD_LOGIC
        );
    end component;

    --------------------------------------------------------------------
    -- Modèle SRAM Micron
    --------------------------------------------------------------------
    component mt55l512y36f is
        port (
            DQ    : inout std_logic_vector (35 downto 0);
            Addr  : in    std_logic_vector (18 downto 0);
            Lbo_n : in    std_logic;
            Clk   : in    std_logic;
            Cke_n : in    std_logic;
            Ld_n  : in    std_logic;
            Bwa_n : in    std_logic;
            Bwb_n : in    std_logic;
            Bwc_n : in    std_logic;
            Bwd_n : in    std_logic;
            Rw_n  : in    std_logic;
            Oe_n  : in    std_logic;
            Ce_n  : in    std_logic;
            Ce2_n : in    std_logic;
            Ce2   : in    std_logic;
            Zz    : in    std_logic
        );
    end component;

    --------------------------------------------------------------------
    -- Signaux TB
    --------------------------------------------------------------------
    signal clk_s          : std_logic := '0';
    signal reset_s        : std_logic := '0';

    signal usr_data_in_s  : std_logic_vector(31 downto 0) := (others => '0');
    signal usr_data_out_s : std_logic_vector(31 downto 0);
    signal usr_addr_s     : std_logic_vector(18 downto 0) := (others => '0');
    signal RW_s           : std_logic := '0';
    signal ctrl_RW_s      : std_logic := '0';

    -- Bus mémoire
    signal DQ_s   : std_logic_vector(35 downto 0);
    signal addr_s : std_logic_vector(18 downto 0);

    -- Signaux mémoire (pilotés UNIQUEMENT par le contrôleur)
    signal nCKE_s  : std_logic;
    signal Lbo_n_s : std_logic;
    signal Cke_n_s : std_logic;
    signal Ld_n_s  : std_logic;
    signal Bwa_n_s : std_logic;
    signal Bwb_n_s : std_logic;
    signal Bwc_n_s : std_logic;
    signal Bwd_n_s : std_logic;
    signal Rw_n_s  : std_logic;
    signal Oe_n_s  : std_logic;
    signal Ce_n_s  : std_logic;
    signal Ce2_n_s : std_logic;
    signal Ce2_s   : std_logic;
    signal Zz_s    : std_logic;

    constant CLK_PERIOD : time := 20 ns;

begin

    --------------------------------------------------------------------
    -- Génération horloge
    --------------------------------------------------------------------
    clk_process : process
    begin
        while now < 2 us loop
            clk_s <= '0';
            wait for CLK_PERIOD / 2;
            clk_s <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    --------------------------------------------------------------------
    -- UUT : Contrôleur SDRAM
    --------------------------------------------------------------------
    UUT : SDRAM_ctrl
        port map (
            usr_data_in  => usr_data_in_s,
            usr_data_out => usr_data_out_s,
            RW           => RW_s,
            ctrl_RW      => ctrl_RW_s,
            clk          => clk_s,
            usr_addr     => usr_addr_s,
            DQ           => DQ_s,
            addr         => addr_s,
            reset        => reset_s,
            nCKE         => nCKE_s,
            Lbo_n        => Lbo_n_s,
            Cke_n        => Cke_n_s,
            Ld_n         => Ld_n_s,
            Bwa_n        => Bwa_n_s,
            Bwb_n        => Bwb_n_s,
            Bwc_n        => Bwc_n_s,
            Bwd_n        => Bwd_n_s,
            Rw_n         => Rw_n_s,
            Oe_n         => Oe_n_s,
            Ce_n         => Ce_n_s,
            Ce2_n        => Ce2_n_s,
            Ce2          => Ce2_s,
            Zz           => Zz_s
        );

    --------------------------------------------------------------------
    -- SRAM Micron
    --------------------------------------------------------------------
    SRAM1 : mt55l512y36f
        port map (
            DQ    => DQ_s,
            Addr  => addr_s,
            Lbo_n => Lbo_n_s,
            Clk   => clk_s,
            Cke_n => nCKE_s,
            Ld_n  => Ld_n_s,
            Bwa_n => Bwa_n_s,
            Bwb_n => Bwb_n_s,
            Bwc_n => Bwc_n_s,
            Bwd_n => Bwd_n_s,
            Rw_n  => Rw_n_s,
            Oe_n  => Oe_n_s,
            Ce_n  => Ce_n_s,
            Ce2_n => Ce2_n_s,
            Ce2   => Ce2_s,
            Zz    => Zz_s
        );

    --------------------------------------------------------------------
    -- Stimuli
    --------------------------------------------------------------------
    stim_proc : process
    begin
        report "===== Début simulation =====";

        -- Reset
        reset_s <= '1';
        wait for 100 ns;
        reset_s <= '0';

        wait for 40ns;

        -- WRITE @1
        usr_addr_s    <= "0000000000000000001";
        usr_data_in_s <= x"BEEF0001";
        RW_s          <= '0';
        ctrl_RW_s     <= '1';
        wait for CLK_PERIOD*2;

        -- READ @1
        usr_addr_s <= "0000000000000000001";
        RW_s <= '1';
        wait for CLK_PERIOD*2;
        
        -- WRITE @2
        usr_addr_s <= "0000000000000000010";
        usr_data_in_s <= x"BEEF0002";
        RW_s          <= '0';
        wait for CLK_PERIOD*2;

        -- READ @2
        usr_addr_s <= "0000000000000000010";
        RW_s <= '1';
        wait for CLK_PERIOD*2;
        
        --IDLE
        ctrl_RW_s <= '0';
        RW_s <= '0';
        wait for 100 ns;

        wait;
    end process;

end behavior;
