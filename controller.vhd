library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity controller is port(
    clk: in std_logic;
    hit: in std_logic;
    read: in std_logic;
    write: in std_logic;
    cache_dataReady: in std_logic;
    mem_dataReady: in std_logic;
    w_validNo: std_logic_vector(1 downto 0);
    reset_n: out std_logic;
    cache_wren: out std_logic;
    mem_wren: out std_logic;
    invalidate: out std_logic;
    enableDSC: out std_logic;
    resetDSC: out std_logic
);
end entity;

architecture behavioral of controller is

    constant init: integer:=0;
    constant writeS: integer:=1;
    constant readS: integer:=2;
    signal state, nextState : integer:=init;

begin
    process( clk )
	begin
		if rising_edge(clk) then
			state <= nextState;
		end if ;
	end process ;
    process(clk)
    begin
        cache_wren <= '0';
        invalidate <= '0';
        mem_wren <= '0';
        reset_n <= '0';
        enableDSC <= '1';
        resetDSC <= '0';
        case state is
            when init =>
                if read = '1' then
                    if cache_dataReady = '1' then
                        if hit = '0' then
                            cache_wren <= '1';
                        end if;
                        if w_validNo(0) = '0' or w_validNo(1) = '0'  then
                            invalidate <= '1';
                        end if;
                        nextState<=readS;
                    end if;
                elsif write = '1' then
                    mem_wren<='1';
                    cache_wren <= '1';
                    if w_validNo(0) = '0' or w_validNo(1) = '0'  then
                        invalidate <= '1';
                    end if;
                    nextState<=writeS;
                end if;
            when readS =>
                nextState <= init;
            when writeS =>
                mem_wren <= '1';
                nextState <= init;
            when others =>


        end case;
    end process;
end architecture;
