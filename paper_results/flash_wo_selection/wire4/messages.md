# Messages for Task: wire4

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.Create a module with 3 inputs and 4 outputs that behaves like wires that makes these connections: a -> w
// ; b -> x; b -> y; c -> z.

The compressed specification is as follows: ```json
{
  "header": "Module `top_module` defines a combinational logic circuit with three single-bit inputs (a, b, c) and four single-bit outputs (w, x, y, z). The module implements direct connections between specific inputs and outputs, effectively acting as a set of wires.",
  "combinational_logic_function": "The combinational logic function is defined by the following direct assignments:\n\n*   w = a\n*   x = b\n*   y = b\n*   z = c\n\nThis represents a simple wiring configuration where the value of input 'a' is directly routed to output 'w', input 'b' is directly routed to outputs 'x' and 'y', and input 'c' is directly routed to output 'z'. There are no complex Boolean operations or logic gates involved. The signal flow is unidirectional, from inputs to outputs. There is no operator sharing or resource utilization strategy because the logic is implemented using direct wire connections. Logic level balancing and delay equalization are not applicable due to the simplicity of the design. Output multiplexing and selection logic are not required.",
  "enhanced_combinational_description": "The `top_module` is a combinational logic circuit designed to establish direct connections between its inputs and outputs. The module has three single-bit inputs: `a`, `b`, and `c`. It also has four single-bit outputs: `w`, `x`, `y`, and `z`. The functionality of the module is defined as follows:\n\n1.  Output `w` directly reflects the value of input `a`. Any change in the value of `a` will be immediately reflected in `w`.\n2.  Output `x` directly reflects the value of input `b`. Any change in the value of `b` will be immediately reflected in `x`.\n3.  Output `y` also directly reflects the value of input `b`. Therefore, `x` and `y` will always have the same value, mirroring the value of `b`.\n4.  Output `z` directly reflects the value of input `c`. Any change in the value of `c` will be immediately reflected in `z`.\n\nThis module effectively acts as a set of wires, routing the input signals to the specified output signals. The absence of any logic gates or complex operations makes it a purely combinational circuit with minimal propagation delay. The module's behavior can be summarized as a simple signal distribution network."
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

