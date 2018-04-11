library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder is
  port (
    input: in std_logic;
    output: out std_logic_vector(1 downto 0);
    control: in std_logic
  );
end entity;

architecture rtl of decoder is

begin
    output(0) <= (not control) and input;
    output(1) <= control and input;
end architecture;
