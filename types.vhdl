library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package simon_game is
  type input_t is record
    -- wikipedia order, bot left first then clockwise
    blue   : std_logic;
    yellow : std_logic;
    green  : std_logic;
    red    : std_logic;
  end record;

  type lights_t is record
    -- wikipedia order, bot left first then clockwise
    blue   : std_logic;
    yellow : std_logic;
    green  : std_logic;
    red    : std_logic;
  end record;

  -- ordered as to match how the game goes, roughly
  type game_stage_t is (ASLEEP, TEACH, TEST, PASS, FAIL);
  type sequence_item_t is (BLUE, YELLOW, GREEN, RED);
  type sequence_arr_t is array (0 to 31) of sequence_item_t;
  type sequence_t is record
    arr : sequence_arr_t;
    len : unsigned(4 downto 0);
  end record;

end package;
