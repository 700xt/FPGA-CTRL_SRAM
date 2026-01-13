onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /tb_test_sram/clko_sram
add wave -noupdate -format Logic -radix hexadecimal /tb_test_sram/ncke
add wave -noupdate -format Logic -radix hexadecimal /tb_test_sram/nadvld
add wave -noupdate -format Logic -radix hexadecimal /tb_test_sram/nrw
add wave -noupdate -format Logic -radix hexadecimal /tb_test_sram/noe
add wave -noupdate -format Logic -radix hexadecimal /tb_test_sram/nce
add wave -noupdate -format Logic -radix hexadecimal /tb_test_sram/nce2
add wave -noupdate -format Logic -radix hexadecimal /tb_test_sram/ce2
add wave -noupdate -format Literal -radix hexadecimal /tb_test_sram/sa
add wave -noupdate -format Literal -radix hexadecimal /tb_test_sram/dq
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {80 ns} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {0 ns} {342 ns}
