library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;


entity cacheDataInSelector is
  port (
    read: in std_logic;
    write: in std_logic;
    ramData: in std_logic_vector(31 downto 0);
    inData: in std_logic_vector(31 downto 0);
    cacheIn: out std_logic_vector(31 downto 0)

  );
end entity;

architecture arch1 of cacheDataInSelector is

begin
    process(inData,ramData,read,write)
    begin
        if write = '1' then
            cacheIn <= inData;
        elsif read = '1' then
            cacheIn <= ramData;
        else
            cacheIn <= "00000000000000000000000000000000";
        end if;
    end process;

end architecture;
