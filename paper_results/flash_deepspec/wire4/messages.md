# Messages for Task: wire4

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.Create a module with 3 inputs and 4 outputs that behaves like wires that makes these connections: a -> w
// ; b -> x; b -> y; c -> z.

The compressed specification is as follows: ```json
{
  "header": "The top module header definition is:\n\n```verilog\nmodule top_module (\n    input a,\n    input b,\n    input c,\n    output w,\n    output x,\n    output y,\n    output z\n);\n```\n\nThis module, `top_module`, defines a combinational logic circuit with three single-bit inputs (a, b, c) and four single-bit outputs (w, x, y, z). The module's behavior is defined by how these inputs are connected to the outputs, as detailed in the `combinational_logic_function` section.",
  "combinational_logic_function": "The combinational logic function of `top_module` is defined by direct wire connections between the inputs and outputs. Specifically:\n\n*   Output `w` is directly connected to input `a`.  This means `w` will always have the same logic level as `a`.\n*   Output `x` is directly connected to input `b`.  This means `x` will always have the same logic level as `b`.\n*   Output `y` is directly connected to input `b`.  This means `y` will always have the same logic level as `b`.\n*   Output `z` is directly connected to input `c`.  This means `z` will always have the same logic level as `c`.\n\nThis is a simple fanout circuit where input `b` drives two outputs (`x` and `y`). There are no complex Boolean expressions or truth table patterns involved. The logic organization is a set of direct connections, making signal flow straightforward. There is no operator sharing or resource utilization strategy beyond the inherent wire connections. Logic level balancing and delay equalization are not applicable due to the simplicity of the connections. Output multiplexing and selection logic are not present.",
  "enhanced_combinational_description": "The `top_module` implements a combinational logic circuit that essentially acts as a set of wires connecting inputs to outputs. The functionality is defined as follows:\n\n1.  **Input `a` to Output `w`:** The logic level of input `a` is directly propagated to output `w`. If `a` is logic high (1), then `w` will be logic high (1). If `a` is logic low (0), then `w` will be logic low (0).\n\n2.  **Input `b` to Outputs `x` and `y`:** The logic level of input `b` is directly propagated to both outputs `x` and `y`. This represents a fanout scenario. If `b` is logic high (1), then both `x` and `y` will be logic high (1). If `b` is logic low (0), then both `x` and `y` will be logic low (0).\n\n3.  **Input `c` to Output `z`:** The logic level of input `c` is directly propagated to output `z`. If `c` is logic high (1), then `z` will be logic high (1). If `c` is logic low (0), then `z` will be logic low (0).\n\nThis circuit does not perform any logical operations beyond direct signal propagation. The outputs are purely dependent on the instantaneous values of the inputs. The circuit can be described using the following Verilog assign statements:\n\n```verilog\nassign w = a;\nassign x = b;\nassign y = b;\nassign z = c;\n```\n\nThese assignments continuously update the outputs whenever the corresponding inputs change. The circuit is purely combinational and memoryless."
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

