onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /simon_tb/UUT/clock
add wave -noupdate -radix symbolic /simon_tb/UUT/buttons
add wave -noupdate -radix symbolic /simon_tb/UUT/lights
add wave -noupdate -radix symbolic -childformat {{/simon_tb/UUT/player_input.blue -radix symbolic} {/simon_tb/UUT/player_input.yellow -radix symbolic} {/simon_tb/UUT/player_input.green -radix symbolic} {/simon_tb/UUT/player_input.red -radix symbolic}} -expand -subitemconfig {/simon_tb/UUT/player_input.blue {-height 16 -radix symbolic} /simon_tb/UUT/player_input.yellow {-height 16 -radix symbolic} /simon_tb/UUT/player_input.green {-height 16 -radix symbolic} /simon_tb/UUT/player_input.red {-height 16 -radix symbolic}} /simon_tb/UUT/player_input
add wave -noupdate -radix symbolic -childformat {{/simon_tb/UUT/sequence.arr -radix symbolic} {/simon_tb/UUT/sequence.len -radix symbolic}} -subitemconfig {/simon_tb/UUT/sequence.arr {-height 16 -radix symbolic} /simon_tb/UUT/sequence.len {-height 16 -radix symbolic}} /simon_tb/UUT/sequence
add wave -noupdate /simon_tb/UUT/wakeup
add wave -noupdate /simon_tb/UUT/new_symbol
add wave -noupdate /simon_tb/UUT/reset_sequence
add wave -noupdate /simon_tb/UUT/sequence_finished
add wave -noupdate /simon_tb/UUT/sequence_finished_bool
add wave -noupdate /simon_tb/UUT/teach_enable
add wave -noupdate /simon_tb/UUT/teach_end
add wave -noupdate /simon_tb/UUT/stage
add wave -noupdate -color Orange /simon_tb/UUT/game_clock
add wave -noupdate /simon_tb/UUT/any_btn_pressed
add wave -noupdate -radix symbolic /simon_tb/UUT/latched_symbol
add wave -noupdate -radix symbolic /simon_tb/UUT/teacher_lights
add wave -noupdate /simon_tb/UUT/ST_MACH/cur_stage
add wave -noupdate /simon_tb/UUT/ST_MACH/next_stage
add wave -noupdate /simon_tb/UUT/ST_MACH/test_finishing
add wave -noupdate /simon_tb/UUT/ST_MACH/is_correct
add wave -noupdate /simon_tb/UUT/ST_MACH/correct_symbol
add wave -noupdate /simon_tb/UUT/ST_MACH/needle_clk
add wave -noupdate -radix unsigned /simon_tb/UUT/ST_MACH/sequence_needle
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1237 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 68
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {517 ns} {1542 ns}
