# Task: rule90

## Analyze Report

Top_Analyze="Analyze the module header and ports: clk, load, data[511:0], and q[511:0]. Describe the overall behavior of the Rule 90 cellular automaton, focusing on how the inputs influence the output q. Specifically, detail how the 'load' signal affects the system's state and how the 'clk' signal advances the simulation. Note the boundary conditions (q[-1] and q[512] are zero)." Topic_Analyze='Provide a structured analysis of Rule 90 cellular automata, focusing on its implementation in hardware (Verilog). Research the following: 1) Rule 90 definition and properties; 2) XOR-based implementation of Rule 90; 3) Implementation of boundary conditions in cellular automata; 4) Parallel implementation of cellular automata; 5) Verilog implementation of Rule 90 cellular automata with load functionality. Ensure the analysis includes the latest research findings as of September 12, 2025.' Solving_Strategies="Outline the overall reasoning strategies and methodology: 1) Understand the Rule 90 algorithm and its XOR-based implementation. 2) Design the circuit to implement the Rule 90 update rule for each cell. 3) Implement the boundary conditions by treating the neighbors of the boundary cells as zero. 4) Implement the load functionality to initialize the cellular automaton with the input data. 5) Use clock signal to advance the simulation by one time step. 6) Verify the Verilog implementation using simulation. Each step should relate to the module's inputs, outputs, and internal state."

## Generated Queries

['Rule 90 cellular automaton Verilog implementation', 'Rule 90 boundary conditions implementation', 'Parallel implementation of cellular automata in Verilog', 'XOR based cellular automaton implementation', 'Verilog implementation of Rule 90 cellular automata with load functionality']

