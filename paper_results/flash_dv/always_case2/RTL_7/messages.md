# Messages for Task: always_case2

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.

A priority encoder is a combinational circuit that, when given an input bit vector, outputs the position of the first 1 bit in the vector. For example, a 8-bit priority encoder given the input 8'b10010000 would output 3'd4, because bit[4] is first bit that is high. Build a 4-bit priority encoder. For this problem, if none of the input bits are high (i.e., input is zero), output zero. Note that a 4-bit number has 16 possible combinations.

The specification is as follows:
# Agent Response for Task: always_case2

```json
{
  "header": "The top module header definition is:\n\n```verilog\nmodule top_module (\n input [3:0] in,\n output reg [1:0] pos\n);\n```\n\nThis module defines a 4-bit priority encoder. The input `in` is a 4-bit vector, and the output `pos` is a 2-bit vector representing the index of the highest priority (leftmost) '1' in the input vector. If all input bits are '0', the output `pos` should be '00'.",
  "combinational_logic_function": "The combinational logic function implements a 4-bit priority encoder. The output `pos` is determined based on the highest priority (leftmost) '1' in the input `in`. The priority is assigned as follows: `in[3]` has the highest priority, followed by `in[2]`, `in[1]`, and `in[0]`. If `in[3]` is '1', `pos` is '11'. If `in[3]` is '0' and `in[2]` is '1', `pos` is '10'. If `in[3]` and `in[2]` are '0' and `in[1]` is '1', `pos` is '01'. If `in[3]`, `in[2]`, and `in[1]` are '0' and `in[0]` is '1', `pos` is '00'. If all inputs are '0', `pos` is '00'.\n\nThis can be expressed using the following logic equations:\n\npos[1] = in[3] | (~in[3] & in[2])\npos[0] = (~in[3] & ~in[2] & in[1]) | (~in[3] & ~in[2] & ~in[1] & in[0])\n\nAlternatively, the logic can be described by the following:\n\nIf (in[3] == 1) then pos = 3;\nElse If (in[2] == 1) then pos = 2;\nElse If (in[1] == 1) then pos = 1;\nElse If (in[0] == 1) then pos = 0;\nElse pos = 0;",
  "enhanced_combinational_description": "This specification details the combinational logic for a 4-bit priority encoder. The encoder's function is to identify the highest priority (leftmost) '1' in a 4-bit input vector and output its index. The input is a 4-bit vector named `in`, where `in[3]` is the most significant bit (MSB) and has the highest priority, and `in[0]` is the least significant bit (LSB) with the lowest priority. The output is a 2-bit vector named `pos`, which represents the index of the highest priority '1' in the input. The encoding for `pos` is as follows:\n\n*   If `in[3]` is '1', then `pos` is '11' (decimal 3).\n*   If `in[3]` is '0' and `in[2]` is '1', then `pos` is '10' (decimal 2).\n*   If `in[3]` and `in[2]` are '0' and `in[1]` is '1', then `pos` is '01' (decimal 1).\n*   If `in[3]`, `in[2]`, and `in[1]` are '0' and `in[0]` is '1', then `pos` is '00' (decimal 0).\n*   If all bits of `in` are '0', then `pos` is '00' (decimal 0).\n\nTruth Table:\n\n| in[3] | in[2] | in[1] | in[0] | pos[1] | pos[0] |\n|-------|-------|-------|-------|--------|--------|\n| 1     | X     | X     | X     | 1      | 1      |\n| 0     | 1     | X     | X     | 1      | 0      |\n| 0     | 0     | 1     | X     | 0      | 1      |\n| 0     | 0     | 0     | 1     | 0      | 0      |\n| 0     | 0     | 0     | 0     | 0      | 0      |\n\nWhere 'X' denotes a 'don't care' condition.\n\nThe combinational logic must implement this priority encoding scheme accurately. The all-zero input condition is a critical aspect of the design and must be handled correctly to ensure proper functionality. The output `pos` must be '00' when all inputs are '0'."
}
```

Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

