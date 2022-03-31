vcs		:
		vcs 	\
		-f dut.f 	\
		-fsdb -full64 -R +vc +v2k -sverilog -debug_all \
		| tee vcs.log
verdi 	:
		verdi -sv -f dut.f -ssf tb_top_uart.fsdb &
clean	:
		rm -rf *.log simv *.daidir csrc *.key DVEfiles *.vpd *.conf *.rc *.fsdb verdiLog
