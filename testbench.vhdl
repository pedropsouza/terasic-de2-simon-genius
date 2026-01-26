library IEEE;
library work;
use IEEE.std_logic_1164.all;
use work.simon_game.all;

entity simon_tb is end entity;

architecture simon_arch of simon_tb is
  signal buttons: std_logic_vector(3 downto 0) := (others => '0');
  signal button_lights: std_logic_vector(3 downto 0) := (others => '0');
  signal clock: std_logic;
  signal game_stage: game_stage_t;
begin
end architecture;
