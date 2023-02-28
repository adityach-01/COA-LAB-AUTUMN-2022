# file_name = ALU_control_tb.v
file_name = CPU_tb.v
file=assembler/test1.s
# file=assembler/test.s

# g++ assembler/assembler.cpp
# assembler/a.out $(file)
a.vvp: ${file_name} 
	iverilog -o a.vvp ${file_name}
	vvp a.vvp
	
clean:
	rm -f a.vvp