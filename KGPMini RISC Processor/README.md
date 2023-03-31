# COA_LAB_AUTUMN_2022
This repository contains the code for Assignment 7 for Computer Organization and Architecture Laboratory. The `assembler` folder includes some test `.s` files and their corresponding `.coe` and `.txt` files to test the architecture. The `codefiles` folder contains the verilog code and test modules along with the ucf file. The `Test Benches` folder inside `codefiles` folder includes the verilog test fixtures for all the modules developed. The design documentation and the problem statement is available in the `docs` folder. Images of the Data Path and the ALU architecture along with the ISA have been documented in the report. The `testfiles` folder contains some custom assembly files along with their binaries for testing purposes. 

## Group Information
Group 17
1. Aditya Choudhary (20CS10005)
2. Rishi Raj (20CS30040)

# How to run the code
1. Write code example `test.s` and save it in the `/assembler` folder. You can even edit the files in `testfiles` folder by copying them in `test.s` and editing them.
2. Run the command `make` inside `/assembler` folder, the assembler would produce `test.coe` and `memory.txt` files which would contain the binary of the source file.
4. Load files with `_tb.v` as the simulation files and the `.v` files as implementation files. I should be noted that `CPU_tb.v` is the top module that should be simulated.
5. Load and initialise bram modules `data_mem` (single port RAM) and `instr_mem` (single port RAM), initialise `instr_mem` with the `test.coe` file. Set width to 32 and depth to 4096 in both of them.
6. Simulate `CPU_tb.v`. For some test files all the tests may not complete in 1000ns. Hence, it is recommended to set the simulation time to 10000ns.
7. Add a `user constraint file` or `ucf` file to the project by adding `KGPminiRISC.ucf`. The ucf file specifies the mapping of FPGA ports to out verilog ports. Two special buttons have been added. `reset` button restarts the program in execution and `cont` button gets the processor out of the halt state.
8. Generate the corresponding bit file after synthesizing the modules and dump the file on FPGA. 

<b>Note</b> : 
The given ucf file has been written for the SPARTAN boards. For any other board, the file may differ and has to be written again.

# A note on the test files
In the test bench of the KGPminiRISC module, the output of the MUX that has ALU and Data Memory input is being monitored. A special instruction `halt` has been added to halt the CPU and stabilize the output. Use the halt instruction after the final answer has been computed and use `halt` after `addi rx 0`, where `rx` stores the final computed answer. Using this the final answer can be seen even on FPGA. Here we provide the output format for the main test file which is `bubble_sort.s`.

1. For `bubble_sort.s` the inputs are loaded in registers r0 and are stored in the data memory after which the `bubble_sort` algorithm runs. To add a new number `num` to the code, use the snippet :-
``` bash
ld r1 num
sw r1 0(r0)
addi r0 1
```
        
After creating the bitfile and dumping the code on FPGA, allow the output to stabilize for the first time. After that, press the `cont` button on the FPGA to view numbers stored in the memory in sorted order.
