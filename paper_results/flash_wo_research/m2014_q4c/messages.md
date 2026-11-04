# Messages for Task: m2014_q4c

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.Implement a simple D flip flop with active high synchronous reset (reset output to 0).

The compressed specification is as follows: Pure CMB Logic :
```json
{
  "header": "The top module header defines the interface of the circuit: `module top_module (input clk, input d, input r, output logic q);`.  This module has three inputs: `clk` (clock), `d` (data), and `r` (reset), and one output: `q`. The `q` output represents the state of the flip-flop.",
  "combinational_logic_function": "The combinational logic function describes the next state of the output `q` based on the current inputs `d` and `r`. When the reset input `r` is asserted (logic high), the output `q` is forced to 0. When the reset input `r` is not asserted (logic low), the output `q` takes the value of the input `d`. This behavior can be summarized as follows:\n\n*   If `r = 1`, then `q = 0`.\n*   If `r = 0`, then `q = d`.\n\nThis can be expressed as the following Boolean expression for the next state of `q` (q_next):\n\n`q_next = (!r) & d`\n\nThis expression represents the combinational logic required to determine the next state of the flip-flop before the clock edge. The actual update of `q` happens at the clock edge, but the value to be loaded is determined by this combinational logic.",
  "enhanced_combinational_description": "The combinational logic within the D flip-flop with synchronous reset determines the next value that will be loaded into the output `q` on the rising edge of the clock `clk`. The reset input `r` has priority. When `r` is high (logic 1), the combinational logic ensures that the next value of `q` will be 0, overriding the data input `d`. When `r` is low (logic 0), the combinational logic passes the value of the data input `d` to the next value of `q`. This behavior can be described by the following truth table, which represents the combinational logic function:\n\n| r | d | q_next |\n|---|---|--------|\n| 0 | 0 | 0      |\n| 0 | 1 | 1      |\n| 1 | 0 | 0      |\n| 1 | 1 | 0      |\n\nThe combinational logic can be implemented using a simple AND gate and an inverter. The reset input `r` is inverted, and the output of the inverter is ANDed with the data input `d`. The output of the AND gate represents the next value of `q` (q_next). This ensures that when `r` is high, the output of the inverter is low, forcing the output of the AND gate (q_next) to be low (0), regardless of the value of `d`. When `r` is low, the output of the inverter is high, and the output of the AND gate (q_next) is equal to the value of `d`. The combinational logic block's function is to compute `q_next` based on `r` and `d` according to the equation: `q_next = (!r) & d`. This value is then loaded into the `q` output on the rising edge of the clock `clk`."
}
```

 With Timing Logic Summary:
```json
{
  "header": "The module `top_module` implements a D flip-flop with synchronous reset. It has three inputs: `clk` (clock), `d` (data), and `r` (reset), and one output: `q`.",
  "Interface Behavior": "At the rising edge of `clk`, if `r` is high, `q` is set to 0. At the rising edge of `clk`, if `r` is low, `q` is set to the value of `d`.",
  "Timing Dependency": "The value of `d` and `r` must be stable before the rising edge of `clk` for a setup time, and must remain stable after the rising edge of `clk` for a hold time. The exact setup and hold times are not specified and are properties of the underlying flip-flop implementation.",
  "Timing logic": "The circuit is a positive edge-triggered sequential circuit. It contains one register, `q`, which is updated using a non-blocking assignment (`<=`). The register `q` is declared as `output logic q`."
}
```

The header you have already known is:module top_module (
	input clk,
	input d,
	input r,
	output logic q
);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

