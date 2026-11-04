# Messages for Task: count_clock

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate only a technical specification for the given task. I will tip you $200 if you can fulfill the tasks I give you.Create a set of counters suitable for use as a 12-hour clock (with am/pm indicator). Your counters are clocked by a fast-running clk, with a pulse on ena whenever your clock should increment (i.e., once per second, while "clk" is much faster than once per second). The signal "pm" is asserted if the clock is PM, or is otherwise AM. hh, mm, and ss are two BCD (Binary-Coded Decimal) digits each for hours (01-12), minutes (00-59), and seconds (00-59). Reset is the active high synchronous signal that resets the clock to "12:00 AM." Reset has higher priority than enable and can occur even when not enabled.


```

## User Message

```
The header you have already known is:module top_module(
	input clk,
	input reset,
	input ena,
	output reg pm,
	output reg [7:0] hh,
	output reg [7:0] mm,
	output reg [7:0] ss);

```

