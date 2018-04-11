library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;


entity TagValidArray is port(
    clk: in std_logic;
    reset_n: in std_logic;
    address: in std_logic_vector (5 downto 0);
    wren: in std_logic;
    invalidate: in std_logic;
    wrdata: in std_logic_vector (3 downto 0);
    output: out std_logic_vector (4 downto 0)
);
end entity;

architecture behavioral of TagValidArray is
type sfArray is array (63 downto 0) of std_logic_vector (4 downto 0); --64*5
signal TagValidArrays:sfArray:=(others => "00000");
signal index: integer:=to_integer(unsigned(address));
begin
    index <= to_integer(unsigned(address));
    output <= TagValidArrays(index);
    process(clk)
    begin
        if rising_edge(clk) then
        TagValidArrays(index)(4 downto 1) <= wrdata;
        if(wren = '1') then
            TagValidArrays(index) <= wrdata & '1';
        end if;
        if(invalidate = '1') then
            TagValidArrays(index)(0) <= '0';
        end if;
        end if;

    end process;
end behavioral;
