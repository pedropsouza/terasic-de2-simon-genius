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
  signal game_clock: std_logic;
  signal sequence: sequence_t;
begin
  UUT: entity work.game
  generic map(
    GAMELOOP_CLOCK_PERIOD => 4
  )
  port map(
    clock => clock,
    buttons => buttons,
    lights => button_lights,
    game_clock_out => game_clock,
    state_debug => open, -- can't/won't retrieve stage info from an arbitrary
                        -- bit repr
    sequence_debug => sequence
  );
  
  CLOCK_SIM: process
  begin
    clock <= '0', '1' after 10 ns;
  -- repeat indefinitely
    wait for 20 ns;
  end process;
  
  PERFECT_PLAYER: process
    variable i: integer := 1;
    variable l: boolean := true;
  begin
    -- wakeup and get taught
    buttons(0) <= '1', '0' after 120 ns;

    -- sync to the hi-lo period (instead of the lo-hi)
    wait until rising_edge(game_clock);
    -- INIT takes one period
    wait until rising_edge(game_clock);

    -- play perfectly
    -- 20 ns is the period of the 50 Mhz clock
    -- one game clock is 4 * 20 ns = 80 ns
    -- no clue if this re-evaluates the end of the range like i expect it to
    -- for i in 1 to to_integer(sequence.len) loop -- (it didn't)
    while l loop
      for j in 0 to i loop
        -- teaching takes i + 1 periods
        wait until rising_edge(game_clock);
      end loop;
      for j in 0 to i - 1 loop
        case sequence.arr(j) is
          when BLUE => buttons(0) <= '1', '0' after 40 ns;
          when YELLOW => buttons(1) <= '1', '0' after 40 ns;
          when GREEN => buttons(2) <= '1', '0' after 40 ns;
          when RED => buttons(3) <= '1', '0' after 40 ns;
        end case; 
        wait until rising_edge(game_clock); -- player_input ingest
        wait until rising_edge(game_clock); -- PASS transition
        wait until rising_edge(game_clock); -- TEST transition
      end loop;
      wait until rising_edge(game_clock); -- SEQ_PASS transition
      wait for 40 ns; -- miscellaneous delay, not sure if needed
      i := i + 1;
      if i > to_integer(sequence.len) then
        wait until not (i > to_integer(sequence.len)); -- trying something different
      end if;
    end loop;
  end process;
end architecture;
