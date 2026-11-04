# Messages for Task: m2014_q4k

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.Implement a shift register with four D flops. Reset is active-low synchronous resettable.

The compressed specification is as follows: Pure CMB Logic :
```json
{
  "header": "module top_module (\n input clk,\n input resetn,\n input in,\n output out\n);",
  "combinational_logic_function": "The 'out' signal is derived from the 'in' signal and the 'resetn' signal, but only indirectly through the D flip-flops. The combinational logic component of this design is limited to the reset logic associated with each D flip-flop. Specifically, each D flip-flop's D input is determined by a combination of the previous flip-flop's output and the 'resetn' signal. When 'resetn' is low (active), the flip-flop should be reset to 0 on the next rising clock edge. This reset functionality can be implemented using a 2-to-1 multiplexer at the D input of each flip-flop. One input of the multiplexer is the output of the preceding flip-flop (or the 'in' signal for the first flip-flop), and the other input is a constant 0. The 'resetn' signal acts as the select input for the multiplexer. When 'resetn' is low, the multiplexer selects the 0 input, forcing the flip-flop to reset. When 'resetn' is high, the multiplexer selects the output of the preceding flip-flop, allowing the shift register to operate normally. The 'out' signal is the output of the last D flip-flop in the chain.",
  "enhanced_combinational_description": "The combinational logic within the `top_module` is responsible for generating the D input to each of the four D flip-flops based on the input signal `in`, the reset signal `resetn`, and the outputs of the preceding flip-flops. The core combinational element is a 2-to-1 multiplexer (MUX) associated with each D flip-flop. The MUX selects between the data to be shifted in (either the external input `in` for the first flip-flop or the output of the previous flip-flop for the subsequent flip-flops) and a reset value (logic 0). The `resetn` signal acts as the select input to the MUX. When `resetn` is asserted low (active-low reset), the MUX selects the reset value (0), forcing the corresponding D flip-flop to reset on the next rising clock edge. When `resetn` is asserted high (inactive), the MUX selects the data input, allowing the shift register to operate normally. \n\nSpecifically:\n\n*   **Flip-Flop 1 (closest to 'in'):** The D input to the first flip-flop is determined by a MUX that selects between `in` and 0, controlled by `resetn`. If `resetn` is low, the D input is 0. If `resetn` is high, the D input is `in`.\n*   **Flip-Flop 2:** The D input to the second flip-flop is determined by a MUX that selects between the output of Flip-Flop 1 and 0, controlled by `resetn`. If `resetn` is low, the D input is 0. If `resetn` is high, the D input is the output of Flip-Flop 1.\n*   **Flip-Flop 3:** The D input to the third flip-flop is determined by a MUX that selects between the output of Flip-Flop 2 and 0, controlled by `resetn`. If `resetn` is low, the D input is 0. If `resetn` is high, the D input is the output of Flip-Flop 2.\n*   **Flip-Flop 4 (closest to 'out'):** The D input to the fourth flip-flop is determined by a MUX that selects between the output of Flip-Flop 3 and 0, controlled by `resetn`. If `resetn` is low, the D input is 0. If `resetn` is high, the D input is the output of Flip-Flop 3. The output `out` of the module is the output of this fourth flip-flop.\n\nTherefore, the combinational logic consists of four 2-to-1 multiplexers, each controlled by the `resetn` signal, and each feeding the D input of a corresponding D flip-flop. The output 'out' is directly the output of the last flip-flop and does not involve any additional combinational logic."
}
```

 With Timing Logic Summary:
```json
{
  "header": "The module `top_module` implements a 4-bit shift register with a synchronous active-low reset. It has a clock input `clk`, an active-low reset input `resetn`, a serial data input `in`, and a serial data output `out`.",
  "Interface Behavior": "On the rising edge of `clk`, if `resetn` is low, all flip-flops are reset to 0. Otherwise, the data at `in` is shifted into the first flip-flop, and the data in each flip-flop is shifted to the next flip-flop. The output `out` reflects the value of the last flip-flop after the rising edge of `clk`.",
  "Timing Dependency": "The critical path is from `in` to `out`, through the four D flip-flops. The delay is four times the clock-to-output delay of a single D flip-flop plus the setup time of the last flip-flop. The reset signal `resetn` must be stable before the rising edge of `clk` to ensure proper reset operation. The input `in` must be stable before the rising edge of `clk` to ensure proper shift operation.",
  "Timing logic": "The circuit is a sequential circuit with four D flip-flops. The flip-flops are triggered on the rising edge of `clk`. The reset is synchronous, meaning that the flip-flops are reset only on the rising edge of `clk` when `resetn` is low. The shift operation is implemented using non-blocking assignments within an `always @(posedge clk)` block. The output `out` is the output of the last flip-flop. The internal implementation will contain four `reg` declarations, one for each flip-flop."
}
```

The header you have already known is:module top_module (
	input clk,
	input resetn,
	input in,
	output out
);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

