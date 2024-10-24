read_file -type verilog $env(TOP_SRCS)
read_file -type awl lint.awl

set_option top combined_top
set_option language_mode verilog
set_option designread_enable_synthesis no
set_option designread_disable_flatten no
set_option enableSV09 yes
set_option enable_save_restore no
set_option sgsyn_loop_limit 50000
set_option mthresh 2000000000
current_goal Design_Read -top combined_top

current_goal lint/lint_turbo_rtl -top combined_top

set_parameter checkfullstruct true

run_goal