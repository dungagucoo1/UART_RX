library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_RX is
    generic (
        N_CNT: integer := 4;
        N_BIT: integer := 4
     );
    Port ( 
        rst_n : in std_logic;
        Rx : in std_logic;
        clk : in std_logic;
        shift_enable : out std_logic;
        WE : out std_logic;
        cnt_16_check : out std_logic_vector (N_CNT - 1 downto 0);
        cnt_bit_check : out std_logic_vector (N_BIT - 1 downto 0);
        state_check : out std_logic_vector (1 downto 0);
        Rx_check: out std_logic
    );

end FSM_RX;

architecture Behavioral of FSM_RX is
    component counter 
        generic (N : integer := 4);
        Port ( 
            clk:            in std_logic;
            rst_n:          in std_logic;
            clock_enable:   in std_logic;
            count_out :     out std_logic_vector(N-1 DOWNTO 0)
        );
    end component;
    
    signal   Rx_reg : std_logic;
    
    signal   state: std_logic_vector(1 downto 0);
    constant IDLE: std_logic_vector(1 downto 0)         := "00";
    constant Start: std_logic_vector(1 downto 0)        := "01";
    constant Receive_data: std_logic_vector(1 downto 0) := "10";
    signal en_16: std_logic;
    signal rst_16 : std_logic;
    signal cnt_16 : std_logic_vector (N_CNT - 1 downto 0);
    signal en_bit: std_logic;
    signal rst_bit : std_logic;
    signal cnt_bit : std_logic_vector (N_BIT - 1 downto 0);
begin
    sample_counter: counter
        generic map (N => N_CNT)
        port map (
            clk => clk,
            rst_n => rst_16,
            clock_enable => en_16,
            count_out => cnt_16
        );
    ----------------------------------------
    bit_counter: counter
        generic map (N => N_CNT)
        port map (
            clk => clk,
            rst_n => rst_bit,
            clock_enable => en_bit,
            count_out => cnt_bit
        );
    ----------------------------------------
    reg_RX: process(clk) begin
        if rising_edge(clk) then
            Rx_reg <= Rx;
            Rx_check <= Rx;
        end if;
    end process reg_RX;
 
    process (clk, rst_n) begin
        if rst_n = '0' then
            state <= IDLE;
        else
            cnt_16_check <= cnt_16;
            cnt_bit_check <= cnt_bit;
            state_check <= state;
            if rising_edge(clk) then
                case state is
                    -----------
                    when IDLE =>
                        WE <= '0';
                        shift_enable <= '0';
                        rst_16 <= '0';
                        rst_bit <= '0';
                        if Rx = '0' and Rx_reg = '1' then 
                            state <= Start;
                            rst_16 <= '1';
                            en_16 <= '1';
                        end if;
                    -----------
                    when Start =>
                        if cnt_16 = "0101" then
                            if Rx <= '0' then
                                state <= Receive_data;
                                rst_16 <= '0';
                                rst_bit <= '1';
                                en_bit <= '0';
                            else
                                state <= IDLE;
                            end if;
                        end if;
                    -----------
                    when Receive_data =>
                        rst_16 <= '1';
                        --ghi data vao khoi nhan du lieu
                        if cnt_16 = "1111" then
                            shift_enable <= '1';
                            en_bit <= '1';
                        else
                            en_bit <= '0';
                            shift_enable <= '0';
                        end if;
                        
                        if cnt_bit = "1000" then
                            WE <= '1';
                            state <= IDLE;
                        else
                            WE <= '0';
                        end if;
                    -----------
                    when others =>
                        state <= IDLE;                  
                end case;
            end if; 
        end if;
    end process;
end Behavioral;
