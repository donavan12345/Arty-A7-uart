# FPGA UART
This project is a customizable UART in SystemVerilog. The board used for the project is an Arty A7, but the underlying UART code can be ported to any FPGA using the uart_top.sv file. For details on the operation of the UART module and how to use it, check the documents folder.

## Quick Features
The UART module instantiated in uart_top.sv is able to handle most types of standard UART communication. 

The UART top module is parameterizable for the following options:
<br>
- CLK_PER_BIT: This lets you set the desired baud rate based on your clock. The equation to find out what the parameter should be is (clock rate Hz) / (desired baud rate). For the example that I have in my project, the parameter is (100 MHz clk) / (115200 baud) = 868.

- PACK_SIZE: This lets you choose the desired amount of data bits in each UART packet. For this project, 8 bits was chosen.

- PARITY_EN: This is a 1 bit on or off parameter. If the value is 1, then the parity bit is enabled. If the value is 0, then the parity bit is disabled.

- EVEN_PAR: This is a 1 bit on or off parameter. If the value is 1, then the module will use even parity. If the value is 0, then the module will use odd parity. If PARITY_EN is 0, then this parameter doesn't matter because parity will be disabled.



## Directory Hierarchy
**This will show folders and have a short description for each. Each folder will have a readme describing in more detail what is contained there and how to use it.**

<pre>
|- contraints  : Holds .xdc file and any other contraints  
|- documents   : Contains any relevant project documents  
|- src         : Contains any .sv files used for project  
|- testbench   : Holds top level testbench files (Each module has its own tb in file)  
|- tools       : Any tools used, Modelsim is here, but I usually put my Vivado project here as well  
|---- Modelsim    : Place to run modelsim tests
</pre>
