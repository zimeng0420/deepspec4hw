# Messages for Task: hadd

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.Create a half adder. A half adder adds two bits (with no carry-in) and produces a sum and carry-out.

The compressed specification is as follows: ```json
{
  "header": "The top module `top_module` defines a half adder with two single-bit inputs, `a` and `b`, and two single-bit outputs, `sum` and `cout`. The `sum` output represents the least significant bit of the addition result, and the `cout` output represents the carry-out bit.",
  "combinational_logic_function": "The `sum` output is derived from the exclusive OR (XOR) of the inputs `a` and `b`. The `cout` output is derived from the logical AND of the inputs `a` and `b`.  The Boolean expressions are as follows:\n\n*   `sum = a XOR b`\n*   `cout = a AND b`\n\nThe truth table for the half adder is:\n\n| a | b | sum | cout |\n|---|---|-----|------|\n| 0 | 0 |  0  |  0   |\n| 0 | 1 |  1  |  0   |\n| 1 | 0 |  1  |  0   |\n| 1 | 1 |  0  |  1   |\n\nThe combinational logic structure consists of two independent logic gates: an XOR gate for the `sum` output and an AND gate for the `cout` output. There is no operator sharing or resource utilization strategy applicable in this simple design. Logic level balancing and delay equalization are not relevant due to the simplicity of the circuit. Output multiplexing and selection logic are not required.",
  "enhanced_combinational_description": "This specification details the combinational logic for a half adder circuit. The half adder takes two single-bit inputs, `a` and `b`, and produces two single-bit outputs: `sum` and `cout`. The `sum` output represents the binary sum of `a` and `b`, while the `cout` output represents the carry-out bit generated when both `a` and `b` are 1. The `sum` output is the result of the XOR operation between `a` and `b`. The `cout` output is the result of the AND operation between `a` and `b`. The circuit is implemented using two logic gates: an XOR gate and an AND gate. The XOR gate takes `a` and `b` as inputs and produces `sum` as the output. The AND gate takes `a` and `b` as inputs and produces `cout` as the output. The half adder does not have a carry-in input. The truth table fully defines the combinational behavior of the half adder. The Boolean equations `sum = a XOR b` and `cout = a AND b` completely describe the functionality. The circuit is purely combinational; the outputs respond directly and immediately to changes in the inputs, subject to gate propagation delays. No sequential elements are involved. The circuit is memoryless; the outputs depend only on the current inputs and not on any previous inputs or states."
}
```

The header you have already known is:module top_module (
	input a,
	input b,
	output sum,
	output cout
);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

