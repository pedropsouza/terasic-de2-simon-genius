library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.simon_game.all;

-- game control signals come from this state machine
entity game_st_mach is port (
  clock: in std_logic;
  player_input: in input_t;
  sequence: in sequence_t;
  sequence_finished: in std_logic;

  wakeup: in std_logic;
  teach_ending: in std_logic;
  
  new_symbol: out std_logic;
  reset_sequence: out std_logic;
  stage: out game_stage_t
);
end entity;

-- type game_stage_t is (ASLEEP, TEACH, TEST, PASS, FAIL)

architecture behav of game_st_mach is
  signal cur_stage, next_stage: game_stage_t := ASLEEP;
  signal correct_symbol: sequence_item_t;
  signal sequence_needle: unsigned(4 downto 0);
  signal needle_clk: std_logic := '0';
  signal test_finishing: std_logic := '0';
  signal is_correct: std_logic;
begin

  NEEDLE_PROC: process (needle_clk, cur_stage)
  begin
    if not (cur_stage = TEST or cur_stage = PASS) then
	   sequence_needle <= to_unsigned(0, 5);
    elsif rising_edge(needle_clk) then
      sequence_needle <= sequence_needle + 1;
	 end if;
  end process;

  RETRIEVE_SYMBOL_PROC: process (clock)
  begin
    if rising_edge(clock) then
      -- shouldn't race -- needle is incremented on X -> PASS transition
      -- and this assignment runs every transition
      -- (including the X -> TEST transition we are interested in)
      correct_symbol <= sequence.arr(to_integer(sequence_needle));
    end if;
  end process;
  
  INPUT_TEST:
  with correct_symbol select is_correct <=
    player_input.blue when BLUE,
    player_input.yellow when YELLOW,
	 player_input.green when GREEN,
	 player_input.red when RED,
	 '0' when others;
  TEST_FINISHING_CLOGIC:
    -- needs to be high by the time the last PASS is reached, hence the
    -- finishING instead of finished
    test_finishing <= '1' when not (sequence_needle < sequence.len) else '0';
  
  STAGE_REG_PROC: process (clock)
  begin
    if rising_edge(clock) then
      cur_stage <= next_stage;
    end if;
  end process;

  -- this should lodge exclusively combinational logic using the
  -- other latched/registered variables
  STAGE_TRANSITIONS: process
    (cur_stage, player_input, wakeup, teach_ending, sequence_finished, is_correct, test_finishing)
  begin
    case cur_stage is
      when ASLEEP =>
        new_symbol <= '0';
        reset_sequence <= '0';
        needle_clk <= '0';
        
        if wakeup = '1'
        then next_stage <= INIT;
        else next_stage <= ASLEEP;
        end if;
      when INIT =>
        new_symbol <= '1';
        reset_sequence <= '0';
        needle_clk <= '0';
        next_stage <= TEACH;
      when TEACH =>
        new_symbol <= '0';
        reset_sequence <= '0';
        needle_clk <= '0';

        if teach_ending = '1'
        then next_stage <= TEST;
        else next_stage <= TEACH;
        end if;
      when TEST =>
        new_symbol <= '0';
        reset_sequence <= '0';
        needle_clk <= '0';
        
        if (std_logic(
               player_input.blue
            or player_input.yellow
            or player_input.green
            or player_input.red) = '1')
        then
          if (is_correct = '1')
          then next_stage <= PASS;
          else next_stage <= FAIL;
          end if;
        else next_stage <= TEST;
        end if;
      when PASS =>
        new_symbol <= '0';
        reset_sequence <= '0';
        needle_clk <= '1';
        if test_finishing = '1' then
          next_stage <= SEQ_PASS;
        else
          next_stage <= TEST;
        end if;
      when FAIL =>
        needle_clk <= '0';
        new_symbol <= '0';
        reset_sequence <= '1';
        next_stage <= ASLEEP;
      when SEQ_PASS =>
        needle_clk <= '0';
        new_symbol <= '1';
        reset_sequence <= '0';
        if not (sequence.len < max_sequence_length) then
          next_stage <= WIN;
        else
          next_stage <= TEACH;
        end if;
      when WIN =>
        needle_clk <= '0';
        new_symbol <= '0';
        reset_sequence <= '1';
        next_stage <= ASLEEP;
      when others =>
        needle_clk <= '0';
        new_symbol <= '0';
        reset_sequence <= '1';
        next_stage <= ERROR;
    end case;
  end process;

  stage <= cur_stage;
end architecture;
