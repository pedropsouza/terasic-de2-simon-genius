library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all; -- Contains or_reduce
use IEEE.numeric_std.all;
use work.simon_game.all;

entity teacher is port(
  clock, enable: in std_logic;
  sequence: in sequence_t;
  finished: out std_logic;
  lights: out lights_t
); end entity;

architecture arch of teacher is
  signal i, next_i: unsigned(4 downto 0) := to_unsigned(0, 5);
  signal cur_symb: sequence_item_t;
  signal gated_clock: std_logic := '0';
  signal inner_lights: lights_t := ( blue => '0', yellow => '0', green => '0', red => '0' );
begin
  finished <= '1' when ((i > sequence.len)) else '0';
  -- finished <= '1' when ((i > sequence.len) or (i = sequence.len)) else '0';
  gated_clock <= enable and clock;
  TEACH_PROC: process(clock, gated_clock, enable, i)
  begin
    if rising_edge(clock) then
      next_i <= to_unsigned(0, 5);
		if enable = '1' then
		  i <= next_i;
		else
		  i <= to_unsigned(0, 5);
		end if;
    end if;

    next_i <= i + 1;

    if rising_edge(gated_clock) then
      cur_symb <= sequence.arr(to_integer(i));
      case cur_symb is
        when BLUE =>
          inner_lights <= ( blue => '1', yellow => '0', green => '0', red => '0' );
        when YELLOW =>
          inner_lights <= ( blue => '0', yellow => '1', green => '0', red => '0' );
        when GREEN =>
          inner_lights <= ( blue => '0', yellow => '0', green => '1', red => '0' );
        when RED =>
          inner_lights <= ( blue => '0', yellow => '0', green => '0', red => '1' );
        when others =>
          inner_lights <= ( blue => '0', yellow => '0', green => '0', red => '0' );
      end case;
    end if;
  end process;
  
  lights <= (
    blue => inner_lights.blue and enable,
	 yellow => inner_lights.yellow and enable,
	 green => inner_lights.green and enable,
	 red => inner_lights.red and enable);
end architecture;
