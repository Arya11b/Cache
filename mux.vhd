library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
  port (
    input: in std_logic_vector(1 downto 0);
    output: out std_logic;
    control: in std_logic
  );
end entity;

architecture rtl of mux is

begin
    output <= (not control and input(0)) or (control and input(1));
end architecture;
