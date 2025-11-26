----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.11.2025 15:49:46
-- Design Name: 
-- Module Name: tb_io - tb_io_arch
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- synopsys translate_off
library unisim;
use unisim.VComponents.all;
-- synopsys translate_on

entity tb_io is
--  Port ( );
end tb_io;

architecture tb_io_arch of tb_io is

component IOBUF_F_16
  port(
    O  : out   std_logic;
    IO : inout std_logic;
    I  : in    std_logic;
    T  : in    std_logic
    );
end component; 

signal Data_out_s,Dq_s,Data_in_s : std_logic_vector(31 downto 0);
signal Trig_r : std_logic;

begin
    IOb: for I in 0 to 31 generate
    Iobx: IOBUF_F_16  port map(
        O => Data_out_s(I),
        IO => Dq_s(I),  
        I => Data_in_s(I), 
		T => Trig_r
        );
    process 
    begin
    Data_in_s <= x"FFFFFFFF";
    Trig_r <='1';
    wait for 10 ns;
    Data_in_s <= x"FFFFFFFF";
    Trig_r <='0';
    wait for 100 ns;
    wait;
    end process;
end generate;

end tb_io_arch;
