# Messages for Task: always_casez

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.Build a priority encoder for 8-bit inputs. Given an 8-bit vector, the output should report the first (least significant) bit in the vector that is 1. Report zero if the input vector has no bits that are high. For example, the input 8'b10010000 should output 3'd4, because bit[4] is first bit that is high.

The compressed specification is as follows: ```json
{
  "header": "The top module `top_module` has one 8-bit input port named `in` and one 3-bit output port named `pos`. The `in` port receives an 8-bit vector. The `pos` port outputs a 3-bit value representing the position of the least significant bit that is set to 1 in the input vector `in`. If no bits are set in the input vector, the output `pos` should be zero.",
  "combinational_logic_function": "The combinational logic function implements a priority encoder. The output `pos` is derived from the input `in` based on the following priority scheme: the least significant bit of `in` has the highest priority. The logic checks each bit of `in` sequentially, starting from the least significant bit (bit 0). If `in[0]` is 1, then `pos` is 0. Otherwise, if `in[1]` is 1, then `pos` is 1, and so on. If none of the bits in `in` are 1, then `pos` is 0. The logic can be implemented using a series of if-else statements or a case statement. The critical path is the chain of if-else statements or the decoding logic within the case statement. There is no operator sharing or resource utilization optimization in this purely combinational implementation. The output multiplexing is implicitly handled by the if-else or case statement logic, where the appropriate value is selected based on the input conditions.",
  "enhanced_combinational_description": "The `top_module` implements an 8-bit priority encoder. The function of the priority encoder is to identify the index of the least significant bit (LSB) that is set to '1' within the 8-bit input vector `in[7:0]`. The output `pos[2:0]` represents this index in binary format. The priority encoder adheres to the following truth table pattern:\n\n1.  If `in[0]` is '1', then `pos` is `3'b000` (decimal 0).\n2.  Else if `in[1]` is '1', then `pos` is `3'b001` (decimal 1).\n3.  Else if `in[2]` is '1', then `pos` is `3'b010` (decimal 2).\n4.  Else if `in[3]` is '1', then `pos` is `3'b011` (decimal 3).\n5.  Else if `in[4]` is '1', then `pos` is `3'b100` (decimal 4).\n6.  Else if `in[5]` is '1', then `pos` is `3'b101` (decimal 5).\n7.  Else if `in[6]` is '1', then `pos` is `3'b110` (decimal 6).\n8.  Else if `in[7]` is '1', then `pos` is `3'b111` (decimal 7).\n9.  If all bits of `in` are '0' (i.e., `in == 8'b00000000`), then `pos` is `3'b000` (decimal 0).\n\nThe combinational logic structure is organized as a series of conditional checks, where each check corresponds to a specific bit position in the input vector. The signal flow starts from the least significant bit `in[0]` and proceeds towards the most significant bit `in[7]`. The output `pos` is assigned a value based on the first '1' encountered in this sequence. The all-zeros case is handled by a default condition that assigns `pos` to zero. The logic level balancing is achieved by ensuring that each conditional check has a similar delay. The output multiplexing is implicitly handled by the conditional assignment of `pos` within the logic."
}
```

The header you have already known is:module top_module (
	input [7:0] in,
	output reg [2:0] pos
);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

