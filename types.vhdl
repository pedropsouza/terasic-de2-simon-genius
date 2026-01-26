library IEEE;
use IEEE.std_logic_1164.all;

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
  
  type game_stage_t is (TESTING, CORRECT, INCORRECT, PLAYBACK);
  type sequence_item_t is (BLUE, YELLOW, GREEN, RED);
  type sequence_t is array (0 to 31) of sequence_item_t;

end package;
