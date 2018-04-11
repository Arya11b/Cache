library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;


entity DataSelectionCircuit is port(
    clk: in std_logic;
    address: in std_logic_vector(5 downto 0);
    w_validNo: in std_logic_vector(1 downto 0);
    enable: in std_logic;
    reset: in std_logic;
    w: out std_logic
);
end entity;

architecture behavioral of DataSelectionCircuit is
type ssArray is array (63 downto 0) of integer; --64*6
signal w0s:ssArray:=(others => 0);
signal w1s:ssArray:=(others => 0);
signal index: integer:=to_integer(unsigned(address));
signal lastW: std_logic;
signal lastAddress: std_logic_vector(5 downto 0);
signal wNo:std_logic;
begin
    wNo <= w_validNo(1) or (not w_validNo(0));
    index <= to_integer(unsigned(address));
    process(clk)
    begin
        if rising_edge(clk) then
        if reset = '1' then
            if wNo = '0' then
                w0s(index)<=0;
            else
                w1s(index)<=0;
            end if;
            lastW <= 'Z';
            lastAddress <= "ZZZZZZ";
        elsif enable = '1' then
            if (wNo /= lastW or address /= lastAddress) then -- if the same index is called twice in a row it should not be counted
                if wNo = '0' then
                    w0s(index) <= w0s(index) + 1;
                elsif wNo = '1' then
                    w1s(index) <= w1s(index) + 1;
                end if;
            end if;
            lastW <= wNo;
            lastAddress <= address;
        end if;
        if w0s(index) >= w1s(index) then
            w <= '1';
        else
            w <= '0';
        end if;
    end if;
    end process;
end behavioral;
