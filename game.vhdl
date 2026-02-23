library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all; -- Contains or_reduce
use IEEE.numeric_std.all;
use work.simon_game.all;

-- variable clock_div_counter: unsigned(27 downto 0) := to_unsigned(0, 28);
-- constant period_ns: unsigned(27 downto 0) := to_unsigned(25000000, 28); -- 0.5 seconds
-- c onstant half_period_ns: unsigned(27 downto 0) := period_ns / 2;
entity game is
  generic(
    GAMELOOP_CLOCK_PERIOD: natural := 25000000 -- 0.5 sec by default
  );
  port(
  clock: std_logic;
  buttons: in std_logic_vector(3 downto 0);
  lights: out std_logic_vector(3 downto 0);
  -- TODO: the whole audio thing
  game_clock_out: out std_logic;
  state_debug: out std_logic_vector(4 downto 0)
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

  component teacher is port(
    clock, enable: in std_logic;
    sequence: in sequence_t;
    finished: out std_logic;
    lights: out lights_t
  ); end component;

  signal player_input: input_t := (blue => '0', yellow => '0', green => '0', red => '0');
  signal sequence: sequence_t;
  signal wakeup: std_logic;
  
  signal new_symbol: std_logic;
  signal reset_sequence: std_logic;
  signal sequence_finished: std_logic;
  signal sequence_finished_bool: boolean;
  signal teach_enable: std_logic;
  signal teach_end: std_logic;

  signal stage: game_stage_t := ASLEEP;
  signal game_clock: std_logic := '0';
  
  signal any_btn_pressed: std_logic := '0';
  signal latched_symbol: std_logic_vector(3 downto 0) := "0000";

  signal teacher_lights: lights_t;
begin
  INVARIANTS_CHECK: process
  begin
    assert(shift_left(to_unsigned(GAMELOOP_CLOCK_PERIOD, 40), 32) /= 1);
    wait;
  end process;
  GAME_CLOCK_GEN: process(clock)
    -- remember to check if the set period constants won't overflow the counters
    variable clock_div_counter: unsigned(31 downto 0) := to_unsigned(0, 32);
    constant period_cycl: unsigned(31 downto 0) := to_unsigned(GAMELOOP_CLOCK_PERIOD, 32); -- 0.5 seconds
    constant half_period_cycl: unsigned(31 downto 0) := period_cycl / 2;
  begin
    if rising_edge(clock) then
      if (clock_div_counter > half_period_cycl) then
        if (clock_div_counter > period_cycl) then
          game_clock <= '0';
			 clock_div_counter := to_unsigned(0, 32);
        else game_clock <= '1';
        end if;
      else
        -- don't know if necessary
        -- game_clock <= game_clock;
      end if;
      clock_div_counter := clock_div_counter + 1;
    end if;
  end process;
  game_clock_out <= game_clock;
  
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
  
  -- debug aid
  with stage select state_debug <=
    "01111" when ASLEEP,
	 "10111" when TEACH,
	 "11011" when TEST,
	 "11101" when PASS,
	 "11110" when FAIL,
	 "11111" when others;

  WAKEUP_GEN: wakeup <= or_reduce(latched_symbol);
  TEACH_BLK: block
  begin
    with stage select teach_enable <= '1' when TEACH, '0' when others;
  TEACHER_INST: teacher port map (
    clock => game_clock,
    enable => teach_enable,
    sequence => sequence,
    finished => teach_end,
    lights => teacher_lights
  );
  end block;

  ANY_BTN_DETECTOR: any_btn_pressed <= or_reduce(buttons);

  SYMBOL_LATCH: process(any_btn_pressed, new_symbol, reset_sequence, teach_enable)
    -- one-hot encoding of possibly "many-hot" buttons vector
    variable latched_symbol_store: std_logic_vector(3 downto 0) := "0000";
  begin
    if new_symbol = '1' or reset_sequence = '1' or teach_enable = '1' then
      latched_symbol_store := "0000";
    elsif rising_edge(any_btn_pressed) then
      if not (or_reduce(latched_symbol_store) = '1') then
        latched_symbol_store := buttons;
      end if;
    end if;
    latched_symbol <= latched_symbol_store;
  end process;
  
  PLAYER_INPUT_FILTER: process(buttons, game_clock)
  begin
    if rising_edge(game_clock) then
      if not any_btn_pressed = '1' then
        case latched_symbol is
          when "0001" => player_input <= (blue => '1', yellow => '0', green => '0', red => '0');
          when "0010" => player_input <= (blue => '0', yellow => '1', green => '0', red => '0');
          when "0100" => player_input <= (blue => '0', yellow => '0', green => '1', red => '0');
          when "1000" => player_input <= (blue => '0', yellow => '0', green => '0', red => '1');
          when others => player_input <= (blue => '0', yellow => '0', green => '0', red => '0');
        end case;
      else
        player_input <= (blue => '0', yellow => '0', green => '0', red => '0');
      end if;
    end if;
    
  end process;

  -- sequence_finished <= std_logic(sequence_finished_bool);
  with sequence_finished_bool select sequence_finished <=
    '1' when true,
    '0' when others;

  LIGHTS_OUT: block
  begin
    lights <= (
      (teacher_lights.blue or latched_symbol(0)),
      (teacher_lights.yellow or latched_symbol(1)),
      (teacher_lights.green or latched_symbol(2)),
      (teacher_lights.red or latched_symbol(3))
    );
  end block;
end architecture;
