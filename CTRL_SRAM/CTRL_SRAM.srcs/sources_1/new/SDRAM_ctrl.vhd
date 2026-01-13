library IEEE;
library unisim;
use IEEE.STD_LOGIC_1164.ALL;
use unisim.VComponents.all;

entity SDRAM_ctrl is
    Port ( 
        usr_data_in  : in  STD_LOGIC_VECTOR (31 downto 0);
        usr_data_out : out STD_LOGIC_VECTOR (31 downto 0);
        M_Burst      : in STD_LOGIC; 
        RW           : in  STD_LOGIC;  -- 0 = write, 1 = read
        ctrl_RW      : in  STD_LOGIC;  -- commande active
        clk          : in  STD_LOGIC;
        usr_addr     : in  STD_LOGIC_VECTOR (18 downto 0);
        DQ           : inout STD_LOGIC_VECTOR (35 downto 0);
        addr         : out STD_LOGIC_VECTOR (18 downto 0);
        reset        : in STD_LOGIC;
        nCKE         : out STD_LOGIC;                                   -- Clock Enable
        Lbo_n        : out STD_LOGIC;                                   -- Burst Mode
        Cke_n        : out STD_LOGIC;                                   -- Cke#
        Ld_n         : out STD_LOGIC;                                   -- Adv/Ld#
        Bwa_n        : out STD_LOGIC;                                   -- Bwa#
        Bwb_n        : out STD_LOGIC;                                   -- BWb#
        Bwc_n        : out STD_LOGIC;                                   -- Bwc#
        Bwd_n        : out STD_LOGIC;                                   -- BWd#
        Rw_n         : out STD_LOGIC;                                   -- RW#
        Oe_n         : out STD_LOGIC;                                   -- OE#
        Ce_n         : out STD_LOGIC;                                   -- CE#
        Ce2_n        : out STD_LOGIC;                                   -- CE2#
        Ce2          : out STD_LOGIC;                                   -- CE2
        Zz           : out STD_LOGIC                                    -- Snooze Mode
    );
end SDRAM_ctrl;

architecture Behavioral of SDRAM_ctrl is
    component IOBUF_F_16
      port(
        O  : out   std_logic;
        IO : inout std_logic;
        I  : in    std_logic;
        T  : in    std_logic
        );
    end component; 
    signal Data_out_s, Data_in_s : STD_LOGIC_VECTOR (35 downto 0);
    signal decalage_data_in_1, decalage_data_in_2 : std_logic_vector (31 downto 0);
    signal Trig_s : STD_LOGIC;
    type StateType is(INIT, IDLE, READ, WRITE, B_WRITE, B_READ);
    signal state : StateType;
    
    -------------------------------------------------------------------
    -- Instanciation de l'IOBUF
    -------------------------------------------------------------------
    begin
        IOb: for I in 0 to 35 generate
        Iobx: IOBUF_F_16  port map(
            O => Data_out_s(I),
            IO => Dq(I),  
            I => Data_in_s(I), 
            T => Trig_s);
    end generate;

    -------------------------------------------------------------------
    -- Exemple simple : stockage des données utilisateur
    -------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            Data_in_s <= "0000" & usr_data_in;
            usr_data_out <= Data_out_s(31 downto 0);   
        end if;
    end process;


    -------------------------------------------------------------------
    -- FSM principal
    -------------------------------------------------------------------    
process(clk, reset)
begin
    if reset = '1' then
        state <= INIT;

    elsif rising_edge(clk) then
        case state is

            when INIT =>
                state <= IDLE;

            when IDLE | READ | WRITE | B_READ | B_WRITE =>
                if ctrl_RW = '1' then
                    if M_burst = '1' then
                        if RW = '1' then
                            state <= B_READ;
                        else
                            state <= B_WRITE;
                        end if;
                    else
                        if RW = '1' then
                            state <= READ;
                        else
                            state <= WRITE;
                        end if;
                    end if;
                else
                    state <= IDLE;
                end if;

        end case;
    end if;
end process;
 

    -------------------------------------------------------------------
    -- Sorties combinatoires selon l'état
    -------------------------------------------------------------------
    process(state)
    begin
        nCKE   <= '0';
        Lbo_n  <= '0';
        Cke_n  <= '0';
        Ld_n   <= '0';
        Bwa_n  <= '0';
        Bwb_n  <= '0';
        Bwc_n  <= '0';
        Bwd_n  <= '0';
        Rw_n   <= '0';
        Oe_n   <= '0';
        Ce_n   <= '0';
        Ce2_n  <= '0';
        Ce2    <= '1';
        Zz     <= '0';
        Trig_s <= '1';

        case state is
            when INIT =>
                Rw_n <='1';
                Trig_s <= '1';
                
            when IDLE =>
                Rw_n <='1';
                Trig_s <= '1';
                Oe_n   <= '1';
                Ce_n   <= '1';

            when READ =>
                Trig_s <= '1';
                Rw_n <='1';
                Oe_n   <= '0';
                Ce_n   <= '0';

            when WRITE =>
                Trig_s <= '0';
                Rw_n <='0';
                Oe_n   <= '1';
                Ce_n   <= '0';
            
            when B_WRITE =>
                Trig_s <= '0';
                Rw_n <= '0';
                Ld_n <= '1';
                Oe_n   <= '1';
                Ce_n   <= '0';
            
            when B_READ =>
                Trig_s <= '1';
                Rw_n <='1';
                Ld_n <= '1';
                Oe_n   <= '1';
                Ce_n   <= '0';
         
        end case;
    end process;

end Behavioral;
