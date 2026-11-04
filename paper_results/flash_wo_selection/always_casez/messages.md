# Messages for Task: always_casez

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.Build a priority encoder for 8-bit inputs. Given an 8-bit vector, the output should report the first (least significant) bit in the vector that is 1. Report zero if the input vector has no bits that are high. For example, the input 8'b10010000 should output 3'd4, because bit[4] is first bit that is high.

The compressed specification is as follows: ```json
{
  "header": "module top_module (\n\tinput [7:0] in,\n\toutput reg [2:0] pos\n); \n\nThis module implements an 8-bit priority encoder. The input `in` is an 8-bit vector, and the output `pos` is a 3-bit vector representing the position of the least significant bit that is high in the input vector. If no bits are high, the output `pos` is zero.",
  "combinational_logic_function": "The combinational logic function of this priority encoder is to identify the lowest index (least significant) bit in the 8-bit input vector `in` that is equal to '1'. The 3-bit output `pos` represents the binary encoding of this index. If the input vector `in` is entirely zero (i.e., no bits are high), the output `pos` is set to '000'. The logic can be described as a series of prioritized conditional checks. The least significant bit (in[0]) is checked first. If it is '1', the output `pos` is '000'. If not, the next bit (in[1]) is checked, and so on. The logic can be implemented using a cascade of if-else statements or a case statement, effectively creating a priority chain where each bit's evaluation depends on the preceding bits being zero. The output `pos` is directly derived from the index of the first '1' encountered, encoded in binary.",
  "enhanced_combinational_description": "This specification details the combinational logic for an 8-bit priority encoder. The encoder's function is to identify the position of the least significant '1' within an 8-bit input vector, `in[7:0]`. The output, `pos[2:0]`, represents this position as a 3-bit binary number. The priority is assigned from the least significant bit (in[0]) to the most significant bit (in[7]).\n\nThe combinational logic operates as follows:\n\n1.  **Zero Input Condition:** If all input bits are '0' (i.e., `in == 8'b00000000`), the output `pos` is set to `3'b000`. This indicates that no valid '1' was found in the input.\n\n2.  **Priority Encoding:** The input bits are examined sequentially, starting from the least significant bit (in[0]). The first '1' encountered determines the output. The logic can be expressed as a series of mutually exclusive conditions:\n    *   If `in[0] == 1'b1`, then `pos = 3'b000` (position 0).\n    *   Else if `in[1] == 1'b1`, then `pos = 3'b001` (position 1).\n    *   Else if `in[2] == 1'b1`, then `pos = 3'b010` (position 2).\n    *   Else if `in[3] == 1'b1`, then `pos = 3'b011` (position 3).\n    *   Else if `in[4] == 1'b1`, then `pos = 3'b100` (position 4).\n    *   Else if `in[5] == 1'b1`, then `pos = 3'b101` (position 5).\n    *   Else if `in[6] == 1'b1`, then `pos = 3'b110` (position 6).\n    *   Else if `in[7] == 1'b1`, then `pos = 3'b111` (position 7).\n\nThis logic ensures that only the *first* (least significant) '1' is encoded. If multiple bits are '1', only the position of the lowest index '1' is reflected in the output. The output `pos` is a direct binary representation of the index of the first '1' found. The absence of any '1' results in a zero output."
}
```

The header you have already known is:module top_module (
	input [7:0] in,
	output reg [2:0] pos
);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

