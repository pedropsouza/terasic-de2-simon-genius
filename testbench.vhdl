library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.simon_game.all;

entity simon_tb is end entity;

architecture simon_arch of simon_tb is
  signal buttons: std_logic_vector(3 downto 0) := (others => '0');
  signal button_lights: std_logic_vector(3 downto 0) := (others => '0');
  signal clock: std_logic;
  signal game_stage: game_stage_t;
begin
  UUT: entity work.game port map(
    clock => clock,
    buttons => buttons,
    lights => button_lights
);
  
  CLOCK_SIM: process
  begin
    clock <= '0', '1' after 10 ns;
  -- repeat indefinitely
  end process;
  
  PERFECT_PLAYER: process
    -- dunno why i didn't just instance the same generator with the same seed
    constant sequence: sequence_t := (
      arr => ( BLUE, BLUE, RED, BLUE
        ),
      len => to_unsigned(4, 3));
  begin
    -- wakeup and get taught
    buttons(0) <= '1', '0' after 100 ns;

    -- play perfectly
    for i in 1 to to_integer(sequence.len) loop
      wait for i * 1 sec + 0.5 sec; -- teaching phase
      for j in 0 to i - 1 loop
        case sequence.arr(j) is
          when BLUE => buttons(0) <= '1', '0' after 20 ms;
          when YELLOW => buttons(1) <= '1', '0' after 20 ms;
          when GREEN => buttons(2) <= '1', '0' after 20 ms;
          when RED => buttons(3) <= '1', '0' after 20 ms;
        end case; 
        wait for 1 sec;
      end loop;
    end loop;
    wait; -- do not repeat
  end process;
end architecture;
