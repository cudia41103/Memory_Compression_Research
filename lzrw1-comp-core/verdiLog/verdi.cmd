simSetSimulator "-vcssv" -exec \
           "/home/cudia2/Desktop/NSK_Research/m_compression/lzrw1-compression-core/simv" \
           -args
debImport "-base" "-dbdir" \
          "/home/cudia2/Desktop/NSK_Research/m_compression/lzrw1-compression-core/simv.daidir"
debLoadSimResult \
           /home/cudia2/Desktop/NSK_Research/m_compression/lzrw1-compression-core/dump.fsdb
wvCreateWindow
srcHBSelect "compinput_tb.ctop" -win $_nTrace1
srcHBSelect "compinput_tb.ctop" -win $_nTrace1
srcSetScope "compinput_tb.ctop" -delim "." -win $_nTrace1
srcHBSelect "compinput_tb.ctop" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "offset" -line 23 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "clock" -line 14 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "clock" -line 14 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "clock" -line 14 -pos 1 -win $_nTrace1
srcSelect -signal "reset" -line 14 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
debReload
srcDeselectAll -win $_nTrace1
srcSelect -signal "clock" -line 14 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "clock" -line 14 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "clock" -line 14 -pos 1 -win $_nTrace1
srcSelect -signal "reset" -line 14 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvZoom -win $_nWave2 404685.672577 1230918.920756
wvZoom -win $_nWave2 0.000000 8601.618547
wvZoom -win $_nWave2 4293.346909 4900.285870
wvSetCursor -win $_nWave2 8.073798 -snap {("G1" 3)}
srcDeselectAll -win $_nTrace1
srcSelect -signal "Done" -line 16 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "Done" -line 16 -pos 1 -win $_nTrace1
srcAction -pos 15 5 2 -win $_nTrace1 -name "Done" -ctrlKey off
debExit
