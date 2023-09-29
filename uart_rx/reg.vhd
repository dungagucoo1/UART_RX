library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is
generic (N: integer := 8);
port(
    WE : in std_logic; 
    D : in std_logic_vector(N-1 downto 0);
    clk : in std_logic;
    rst_n : in std_logic;
    Q : out std_logic_vector(N-1 downto 0)
 );
end reg;

architecture behavioral of reg is

begin
    process (clk, rst_n)
 begin
        if rst_n = '0' then
            Q <= (others => '0');
        elsif rising_edge(clk) then
            if WE = '1' then
                Q <= D;
            end if;
        end if;
    end process ;

end behavioral;
