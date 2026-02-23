library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.simon_game.all;

entity sequence_generator is
  port (
    clk, enable, reset: in std_logic;
    sequence: out sequence_t;
    finished: out boolean
);
end entity;

architecture behav of sequence_generator is
  component lfsr is
    generic
      (
        seed: integer;
        width: integer
        );
    port (
      cout : out std_logic_vector (width-1 downto 0);  -- Output of the counter
      CE   : in  std_logic;                            -- Enable counting
      CLK  : in  std_logic;                            -- Input rlock
      SCLR : in  std_logic                             -- Input reset
      );
  end component;

  signal random_num: std_logic_vector(8-1 downto 0);
  function item_from_num(num: in std_logic_vector(random_num'range)) return sequence_item_t is
    variable temp: std_logic_vector(1 downto 0);
    begin
       temp := (num(6) & num(2));
       if    (temp = "00") then return BLUE;
       elsif (temp = "01") then return YELLOW;
       elsif (temp = "10") then return GREEN;
       elsif (temp = "11") then return RED;
       end if;
       return BLUE; -- if we ever get invalid input, blue's the default
    end function;
  signal next_item: sequence_item_t;
begin
  GENERATOR: lfsr generic map (
      seed => 42,
      width => 8
    ) port map (
    cout => random_num,
    ce => enable,
    clk => clk,
    sclr => reset
    );

  next_item <= item_from_num(random_num);
  PROC: process (clk, reset, enable)
    variable sequence_store: sequence_arr_t := (others => BLUE);
    variable sequence_len_store: unsigned(2 downto 0) := "000";
    variable next_len: unsigned(3 downto 0) := "0000";
    variable finished_store: boolean := false;
  begin
    if (reset = '1') then
      sequence_store := (others => BLUE);
      sequence_len_store := "000";
      finished_store := false;
    elsif (enable = '1' and rising_edge(clk) and not finished_store) then
      sequence_store(to_integer(sequence_len_store)) := next_item;
      next_len := resize(sequence_len_store, 4) + 1; -- might be better to use a
                                          -- shift register for this
      if (next_len > 4) then
        -- report "got to the overflow guard";
        finished_store := true;
      else
        sequence_len_store := next_len(2 downto 0);
      end if;
    end if;

    sequence.arr <= sequence_store;
    sequence.len <= sequence_len_store;
    finished <= finished_store;
  end process;
  
end architecture;

