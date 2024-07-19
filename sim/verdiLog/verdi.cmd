sidCmdLineBehaviorAnalysisOpt -incr -clockSkew 0 -loopUnroll 0 -bboxEmptyModule 0  -cellModel 0 -bboxIgnoreProtected 0 
debImport "-sv" "-top" "top" "-f" "filelist.f"
debLoadSimResult \
           /Business/EDA_wx_company/xingchangwen/RISC-V/7_19_cheat_version/RISCV_project/RISCV_verification_cheat_version/sim/sim.fsdb
wvCreateWindow
srcHBSelect "top.pkt_bus" -win $_nTrace1
srcHBSelect "top.pkt_bus" -win $_nTrace1
srcSetScope "top.pkt_bus" -delim "." -win $_nTrace1
srcHBSelect "top.pkt_bus" -win $_nTrace1
srcHBSelect "top.pkt_bus.pkt_out_rm" -win $_nTrace1
srcHBSelect "top.pkt_bus.pkt_out_dut" -win $_nTrace1
srcHBSelect "top.pkt_bus.pkt_out_rm" -win $_nTrace1 -add
srcHBSelect "top.pkt_bus.pkt_out_dut" -win $_nTrace1
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 5212851.213282 -snap {("pkt_out_rm(pkt_if)" 6)}
