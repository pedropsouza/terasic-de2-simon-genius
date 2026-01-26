library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.simon_game.all;

entity simon_seq_tb is end entity;

architecture arch of simon_seq_tb is
  signal clock: std_logic;
  signal sequence: sequence_t;
  signal finished: boolean;

  component sequence_generator is
  port (
    clk, enable, reset: in std_logic;
    sequence: out sequence_t;
    finished: out boolean
    );
  end component;
begin
  SEQ_GEN: sequence_generator port map (
    clk => clock,
    enable => '1',
    reset => '0',
    sequence => sequence,
    finished => finished
  );

  CLK_PROC: process begin
    clock <= '0', '1' after 10 ns;
    wait for 20 ns;
  end process;
end architecture;
