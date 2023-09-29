library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee. std_logic_unsigned.all;
entity counter is
generic (N : integer := 4);
  Port ( 
    clk:            in std_logic;
    rst_n:          in std_logic;
    clock_enable:   in std_logic;
    count_out :     out std_logic_vector(N-1 DOWNTO 0)
  );
end counter;

architecture Behavioral of counter is
    signal cnt : std_logic_vector(N-1 DOWNTO 0);
begin
    process (clk, rst_n) begin
        if rst_n = '0' then
            cnt <= (others => '0');
        elsif rising_edge (clk) then    
            if clock_enable = '1' then
                cnt <= cnt +1;
            end if;
        end if;
    end process;
    count_out <= cnt;
end Behavioral;
