# FPGA UART
This project is a customizable UART in SystemVerilog. The board used for the project is an Arty A7, but the underlying UART code can be ported to any FPGA. For details on the operation of the UART module and how to use it, check the documents folder.

## Directory Hierarchy
**This will show folders and have a short description for each. Each folder will have a readme describing in more detail what is contained there and how to use it.**

\- Contraints  : Holds .xdc file and any other contraints
\- documents   : Contains any relevant project documents
\- src         : Contains any .sv files used for project
\- testbench   : Holds top level testbench files (Each module has its own tb in file)
\- tools       : Any tools used, Modelsim is here, but I usually put my Vivado project here as well
\---- Modelsim    : Place to run modelsim tests
