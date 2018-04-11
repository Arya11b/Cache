library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;


entity DataArray is port(
    clk: in std_logic;
    address: in std_logic_vector (5 downto 0);
    wren: in std_logic;
    wrdata: in std_logic_vector (31 downto 0);
    data: out std_logic_vector (31 downto 0)
);
end entity;

architecture behavioral of DataArray is
type ssArray is array (63 downto 0) of std_logic_vector (31 downto 0);
signal DataArrays:ssArray:=(others => "00000000000000000000000000000000");
signal index: integer:=to_integer(unsigned(address));
begin
    index<=to_integer(unsigned(address));
    data <= DataArrays(index);
    process(clk)
    begin
        if rising_edge(clk) then
        if(wren = '1') then
            DataArrays(index) <= wrdata;
        end if;
    end if;
    end process;
end behavioral;
