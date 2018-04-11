LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory is
    port(
        clk, mem_wren:in STD_LOGIC;
         address:in STD_LOGIC_VECTOR(9 downto 0);
         data_in:in STD_LOGIC_VECTOR(31 downto 0);
         data_out:out STD_LOGIC_VECTOR(31 downto 0);
         mem_dataReady:out STD_LOGIC := '0'
     );
end memory;

architecture behavioral of memory is
    type memoryBlocks is array (1023 downto 0) of STD_LOGIC_VECTOR (31 downto 0);
    signal dataArr: memoryBlocks:=(others => "00000000000000000000000000000000");
    signal index: integer:=to_integer(unsigned(address));
begin
    index <= to_integer(unsigned(address));
    data_out <= dataArr(index);

    process(clk)
    begin
        if rising_edge(clk) then
        mem_dataReady <= '0';
        if(mem_wren = '1') then
            dataArr(index) <= data_in;
        end if;
        mem_dataReady <= '1';
        end if;
    end process;

end behavioral;
