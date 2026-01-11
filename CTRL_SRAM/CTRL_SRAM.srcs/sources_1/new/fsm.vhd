library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
    Port (
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        ctrl_RW : in  STD_LOGIC;
        RW      : in  STD_LOGIC;
        Rw_n    : out STD_LOGIC;
        Trig_s  : out STD_LOGIC
    );
end fsm;

architecture Behavioral of fsm is

    type state_type is (INIT, IDLE, READ, WRITE);
    signal state : state_type;

begin

    -------------------------------------------------------------------
    -- FSM séquentielle
    -------------------------------------------------------------------
    process(clk, reset)
    begin
        if reset = '1' then
            state <= INIT;
        elsif rising_edge(clk) then
            case state is
                when INIT =>
                    state <= IDLE;

                when IDLE =>
                    if ctrl_RW = '1' and RW = '1' then
                        state <= READ;
                    elsif ctrl_RW = '1' and RW = '0' then
                        state <= WRITE;
                    else
                        state <= IDLE;
                    end if;

                when READ =>
                    if ctrl_RW = '1' and RW = '0' then
                        state <= WRITE;
                    elsif ctrl_RW = '0' then
                        state <= IDLE;
                    else
                        state <= READ;
                    end if;

                when WRITE =>
                    if ctrl_RW = '1' and RW = '1' then
                        state <= READ;
                    elsif ctrl_RW = '0' then
                        state <= IDLE;
                    else
                        state <= WRITE;
                    end if;
            end case;
        end if;
    end process;

    -------------------------------------------------------------------
    -- Sorties Moore
    -------------------------------------------------------------------
    process(state)
    begin
        Rw_n   <= '0';
        Trig_s <= '1';
        case state is
            when INIT =>
                Rw_n <='1';
                Trig_s <= '1';
                
            when IDLE =>
                Rw_n <='1';
                Trig_s <= '1';

            when READ =>
                Trig_s <= '1';
                Rw_n <='1';

            when WRITE =>
                Trig_s <= '0';
                Rw_n <='0';
        end case;
    end process;

end Behavioral;
