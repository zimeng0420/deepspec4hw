# Messages for Task: always_if2

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.Fix any and all bugs in this code:

// module top_module (
//     input      cpu_overheated,
//     output reg shut_off_computer,
//     input      arrived,
//     input      gas_tank_empty,
//     output reg keep_driving  ); //

//     always @(*) begin
//         if (cpu_overheated)
//            shut_off_computer = 1;
//     end

//     always @(*) begin
//         if (~arrived)
//            keep_driving = ~gas_tank_empty;
//     end

// endmodule
The header you have already known is:module top_module (
	input cpu_overheated,
	output reg shut_off_computer,
	input arrived,
	input gas_tank_empty,
	output reg keep_driving
);

```

## User Message

```


You can use the technical specification as follows:```json
{
  "header": "The top module header definition from module top_module ( input cpu_overheated, output reg shut_off_computer, input arrived, input gas_tank_empty, output reg keep_driving );, including the interface definition and their behavior.",
  
  "combinational_logic_function": "The outputs of the combinational logic circuit derive from the inputs based on specific conditions. The output 'shut_off_computer' is directly controlled by the 'cpu_overheated' input, while the output 'keep_driving' is determined by the combination of 'arrived' and 'gas_tank_empty'. The logic can be expressed as follows: 1. shut_off_computer = cpu_overheated; 2. keep_driving = ~arrived & ~gas_tank_empty. The circuit can be organized into two distinct functional blocks: one for controlling the computer shutdown and another for driving behavior. The signal flow is optimized by ensuring that each output is driven by a single condition, minimizing the critical path and avoiding unnecessary logic levels. Operator sharing is implemented by using common conditions across outputs where applicable, and logic level balancing is achieved by ensuring that all paths leading to outputs are of similar complexity to equalize delays. Output multiplexing is not required in this design as each output is directly determined by its respective conditions without the need for selection logic.",
  
  "enhanced_combinational_description": "Comprehensive combinational logic specification derived from User: CMB Fix any and all bugs in this code: // module top_module ( // input cpu_overheated, // output reg shut_off_computer, // input arrived, // input gas_tank_empty, // output reg keep_driving ); // // always @(*) begin // if (cpu_overheated) // shut_off_computer = 1; // end // // always @(*) begin // if (~arrived) // keep_driving = ~gas_tank_empty; // end // endmodule module top_module ( input cpu_overheated, output reg shut_off_computer, input arrived, input gas_tank_empty, output reg keep_driving ); The combinational logic is structured to ensure that all outputs are assigned values under all conditions to prevent unintended latch inference. The 'shut_off_computer' output is set to 1 when 'cpu_overheated' is true and reset to 0 otherwise. The 'keep_driving' output is set to the negation of 'gas_tank_empty' when 'arrived' is false, and reset to 0 otherwise. This ensures that both outputs are always driven by the current state of the inputs, maintaining the integrity of the combinational logic design."
}
```

Please only reply with the Verilog code, no other words.

Please always begin with `module top_module()`. 
```

