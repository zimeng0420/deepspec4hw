# Messages for Task: wire4

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.Create a module with 3 inputs and 4 outputs that behaves like wires that makes these connections: a -> w
// ; b -> x; b -> y; c -> z.

The compressed specification is as follows: ```json
{
  "header": "The top module header definition is:\n\n```verilog\nmodule top_module (\n    input a,\n    input b,\n    input c,\n    output w,\n    output x,\n    output y,\n    output z\n);\n```\n\nThis module, named `top_module`, defines a combinational logic circuit with three single-bit inputs (a, b, c) and four single-bit outputs (w, x, y, z). The module's behavior is defined by how these inputs are connected to the outputs.",
  "combinational_logic_function": "The combinational logic function is defined by direct wire connections between the inputs and outputs. Specifically:\n\n*   Output `w` is directly connected to input `a`.  This can be represented as `w = a`.\n*   Output `x` is directly connected to input `b`.  This can be represented as `x = b`.\n*   Output `y` is directly connected to input `b`.  This can be represented as `y = b`.\n*   Output `z` is directly connected to input `c`.  This can be represented as `z = c`.\n\nThis is a simple wiring configuration, where the output signals directly follow the input signals. There are no complex Boolean expressions or truth table patterns involved. The logic organization is a set of parallel wire connections. Signal flow is unidirectional, from inputs to outputs. There is no operator sharing or resource utilization strategy beyond the inherent sharing of input `b` driving both outputs `x` and `y`. Logic level balancing is inherent due to the direct connections. There is no output multiplexing or selection logic.",
  "enhanced_combinational_description": "This specification describes a combinational logic module named `top_module` that functions as a set of direct wire connections. The module has three single-bit inputs: `a`, `b`, and `c`. It also has four single-bit outputs: `w`, `x`, `y`, and `z`. The functionality of the module is as follows:\n\n*   Input `a` is directly connected to output `w`. Any logic level applied to input `a` will be directly reflected on output `w`.\n*   Input `b` is directly connected to output `x`. Any logic level applied to input `b` will be directly reflected on output `x`.\n*   Input `b` is also directly connected to output `y`. This means that the same logic level applied to input `b` will be reflected on both outputs `x` and `y` simultaneously. This demonstrates a fan-out of the signal from input `b` to two separate outputs.\n*   Input `c` is directly connected to output `z`. Any logic level applied to input `c` will be directly reflected on output `z`.\n\nThe implementation uses continuous assignment statements to achieve these direct connections. The `assign` keyword in Verilog ensures that the outputs continuously reflect the values of their corresponding inputs. The absence of any other logic gates or operations implies that the propagation delay through this module will be minimal, primarily determined by the physical characteristics of the wires themselves. The module effectively acts as a set of wires, routing the input signals to the specified outputs. The connection of input `b` to both outputs `x` and `y` is a key aspect of the module's functionality."
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

