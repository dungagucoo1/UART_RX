library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shifter is
generic (N: integer := 8);
  Port ( 
    Rx: in std_logic;
    clk: in std_logic;
    rst_n: in std_logic;
    shift_enable: in std_logic;
    shift_value: inout std_logic_vector(N-1 downto 0)
  );
end shifter;

architecture Behavioral of shifter is
    
begin
    process (clk, rst_n) begin
        if rst_n = '0' then
                shift_value <= (others => '1');
        else
            if rising_edge(clk) then
                if shift_enable = '1' then
                    shift_value <= Rx & shift_value(N-1 downto 1);
                end if;
            end if; 
        end if;
    end process;
end Behavioral;
