library IEEE;
library work;
use IEEE.std_logic_1164.all;
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
    sequence_len: out unsigned(4 downto 0);
    finished: out boolean
    );
  end component;

  signal game_stage: game_stage_t := ASLEEP;
  signal sequence: sequence_t;
begin
  SEQ_GEN: sequence_generator port map (
    clk => clock,
    enable => ,
    reset => ,
    sequence => ,
    sequence_len => ,
    finished => 
  );
end architecture;
