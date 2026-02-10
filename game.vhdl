library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all; -- Contains or_reduce
use work.simon_game.all;

entity game is port(
  clock: std_logic;
  buttons: in std_logic_vector(3 downto 0);
  lights: out std_logic_vector(3 downto 0)
  -- TODO: the whole audio thing
); end entity;

architecture arch of game is
  component sequence_generator is
  port (
    clk, enable, reset: in std_logic;
    sequence: out sequence_t;
    finished: out boolean
    );
  end component;

  component game_st_mach is port (
    clock: in std_logic;
    player_input: in input_t;
    sequence: in sequence_t;
    sequence_finished: in std_logic;

    wakeup: in std_logic;
    teach_end: in std_logic;
    
    new_symbol: out std_logic;
    reset_sequence: out std_logic;
    stage: out game_stage_t
    );
  end component;

  signal player_input: input_t;
  signal sequence: sequence_t;
  signal wakeup: std_logic;
  signal teach_end: std_logic;
  
  signal new_symbol: std_logic;
  signal reset_sequence: std_logic;
  signal sequence_finished: std_logic;
  signal sequence_finished_bool: boolean;
  signal stage: game_stage_t := ASLEEP;
  signal game_clock: std_logic := '0';
begin
  GAME_CLOCK_GEN: process(clock)
    -- remember to check if the set period constants won't overflow the counters
    variable clock_div_counter: unsigned(27 downto 0) := 0;
    constant period_ns: unsigned(27 downto 0) := 100000000; -- 2 seconds
    constant half_period_ns: unsigned(27 downto 0) := period_ns / 2;
  begin
    if rising_edge(clock) then
      if (clock_div_counter > half_period_ns) then
        if (clock_div_counter > period_ns) then
          game_clock <= '0';
        else game_clock <= '1';
        end if;
      else
        -- don't know if necessary
        -- game_clock <= game_clock;
      end if;
      clock_div_counter := clock_div_counter + 1;
    end if;
  end process;
  SEQ_GEN: sequence_generator port map (
    clk => game_clock,
    enable => new_symbol,
    reset => reset_sequence,
    sequence => sequence,
    finished => sequence_finished_bool
  );

  ST_MACH: game_st_mach port map (
    clock => game_clock,
    player_input => player_input,
    sequence => sequence,
    sequence_finished => sequence_finished,

    wakeup => wakeup,
    teach_end => teach_end,

    new_symbol => new_symbol,
    reset_sequence => reset_sequence,
    stage => stage
  );

  WAKEUP_GEN: wakeup <= or_reduce(buttons);
  TEACH_END_GEN: teach_end <= '1'; -- FIXME
  PLAYER_INPUT_FILTER: process(buttons, game_clock)
    variable blue, yellow, green, red: std_logic := '0';
  begin
    blue := buttons(0) or blue;
    yellow := buttons(1) or yellow;
    green := buttons(2) or green;
    red := buttons(3) or red;
    
    if rising_edge(game_clock) then
      if (std_logic(player_input.blue
                    or player_input.yellow
                    or player_input.green
                    or player_input.red) = '1') then
        -- do not clear if button held
      else
        blue := '0';
        yellow := '0';
        green := '0';
        red := '0';
      end if;
    end if;
    player_input.blue <= blue;
    player_input.yellow <= yellow;
    player_input.green <= green;
    player_input.red <= red;
  end process;

  -- sequence_finished <= std_logic(sequence_finished_bool);
  with sequence_finished_bool select sequence_finished <=
    '1' when true,
    '0' when others;
end architecture;
