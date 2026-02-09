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
begin
  SEQ_GEN: sequence_generator port map (
    clk => clock,
    enable => new_symbol,
    reset => reset_sequence,
    sequence => sequence,
    finished => sequence_finished_bool
  );

  ST_MACH: game_st_mach port map (
    clock => clock,
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
  TEACH_END_GEN: teach_end <= '0'; -- FIXME
  PLAYER_INPUT_MARSHALL: block begin
    player_input.blue <= buttons(0);
    player_input.yellow <= buttons(1);
    player_input.green <= buttons(2);
    player_input.red <= buttons(3);
  end block;

  -- sequence_finished <= std_logic(sequence_finished_bool);
  with sequence_finished_bool select sequence_finished <=
    '1' when true,
    '0' when others;
end architecture;
