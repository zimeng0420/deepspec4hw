# Messages for Task: wire4

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.Create a module with 3 inputs and 4 outputs that behaves like wires that makes these connections: a -> w
// ; b -> x; b -> y; c -> z.

The compressed specification is as follows: ```json
{
  "header": "The top module, `top_module`, is defined with three single-bit inputs: `a`, `b`, and `c`; and four single-bit outputs: `w`, `x`, `y`, and `z`. The module's behavior is to directly connect the input signals to the output signals as specified. Specifically, input `a` is connected to output `w`, input `b` is connected to both outputs `x` and `y`, and input `c` is connected to output `z`. This module acts as a simple signal routing or fan-out circuit.",
  "combinational_logic_function": "The combinational logic function is a direct mapping of inputs to outputs. The output `w` is logically equivalent to the input `a`. The outputs `x` and `y` are both logically equivalent to the input `b`. The output `z` is logically equivalent to the input `c`. This can be represented by the following Boolean expressions:\n\n*   w = a\n*   x = b\n*   y = b\n*   z = c\n\nThere is no complex logic organization, signal flow optimization, or critical path identification needed due to the simplicity of the direct connections. No operator sharing or resource utilization strategies are applicable. Logic level balancing and delay equalization techniques are not required. Output multiplexing and selection logic are not present.",
  "enhanced_combinational_description": "The `top_module` implements a straightforward combinational logic function where inputs are directly routed to outputs. Input `a` is directly connected to output `w`. Input `b` is fanned out and connected to both outputs `x` and `y`. Input `c` is directly connected to output `z`. The module's functionality can be summarized as follows:\n\n*   Output `w` mirrors the value of input `a`.\n*   Output `x` mirrors the value of input `b`.\n*   Output `y` mirrors the value of input `b`.\n*   Output `z` mirrors the value of input `c`.\n\nThis module serves as a basic signal distribution network. The absence of any complex logic gates or operations results in minimal propagation delay. The module's primary function is to replicate and route signals from the input ports to the designated output ports. The connections are static and do not change based on any internal logic or control signals. The module's behavior is entirely determined by the direct wire connections between the inputs and outputs."
}
```

The header you have already known is:module top_module (
	input a,
	input b,
	input c,
	output w,
	output x,
	output y,
	output z  );


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

