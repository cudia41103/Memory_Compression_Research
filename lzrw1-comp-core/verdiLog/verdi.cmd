simSetSimulator "-vcssv" -exec \
           "/home/cudia2/Desktop/NSK_Research/m_compression/lzrw1-comp-core/simv" \
           -args
debImport "-base" "-dbdir" \
          "/home/cudia2/Desktop/NSK_Research/m_compression/lzrw1-comp-core/simv.daidir"
debLoadSimResult \
           /home/cudia2/Desktop/NSK_Research/m_compression/lzrw1-comp-core/dump.fsdb
wvCreateWindow
srcHBSelect "compinput_tb.ctop" -win $_nTrace1
srcSetScope "compinput_tb.ctop" -delim "." -win $_nTrace1
srcHBSelect "compinput_tb.ctop" -win $_nTrace1
srcHBSelect "compinput_tb.ctop.CV" -win $_nTrace1
srcSetScope "compinput_tb.ctop.CV" -delim "." -win $_nTrace1
srcHBSelect "compinput_tb.ctop.CV" -win $_nTrace1
srcHBSelect "compinput_tb.ctop" -win $_nTrace1
srcSetScope "compinput_tb.ctop" -delim "." -win $_nTrace1
srcHBSelect "compinput_tb.ctop" -win $_nTrace1
srcDeselectAll -win $_nTrace1
debReload
srcHBSelect "compinput_tb.ctop.CV" -win $_nTrace1
srcHBSelect "compinput_tb" -win $_nTrace1
srcSetScope "compinput_tb" -delim "." -win $_nTrace1
debReload
srcDeselectAll -win $_nTrace1
srcSelect -signal "testString\[k\]" -line 63 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcHBSelect "compinput_tb.ctop" -win $_nTrace1
srcSetScope "compinput_tb.ctop" -delim "." -win $_nTrace1
srcHBSelect "compinput_tb.ctop" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "CurByte" -line 15 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
debReload
srcHBSelect "compinput_tb" -win $_nTrace1
srcSetScope "compinput_tb" -delim "." -win $_nTrace1
srcHBSelect "compinput_tb" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "CurByte" -line 18 -pos 1 -win $_nTrace1
debReload
srcHBSelect "compinput_tb.ctop" -win $_nTrace1
srcSetScope "compinput_tb.ctop" -delim "." -win $_nTrace1
srcHBSelect "compinput_tb.ctop" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "CurByte" -line 15 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "compArray" -line 17 -pos 1 -win $_nTrace1
srcHBSelect "compinput_tb" -win $_nTrace1
srcSetScope "compinput_tb" -delim "." -win $_nTrace1
srcHBSelect "compinput_tb" -win $_nTrace1
srcDeselectAll -win $_nTrace1
debReload
srcDeselectAll -win $_nTrace1
srcSelect -signal "compArray" -line 22 -pos 1 -win $_nTrace1
srcHBSelect "compinput_tb.ctop" -win $_nTrace1
srcSetScope "compinput_tb.ctop" -delim "." -win $_nTrace1
srcHBSelect "compinput_tb.ctop" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "compArray" -line 17 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "compArray" -line 17 -pos 1 -win $_nTrace1
srcAction -pos 16 18 5 -win $_nTrace1 -name "compArray" -ctrlKey off
srcHBSelect "compinput_tb.ctop" -win $_nTrace1
srcSetScope "compinput_tb.ctop" -delim "." -win $_nTrace1
srcHBSelect "compinput_tb.ctop" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -range {11 21 1 1 1 1} -backward
srcHBSelect "compinput_tb.ctop.CV" -win $_nTrace1
srcSetScope "compinput_tb.ctop.CV" -delim "." -win $_nTrace1
srcHBSelect "compinput_tb.ctop.CV" -win $_nTrace1
