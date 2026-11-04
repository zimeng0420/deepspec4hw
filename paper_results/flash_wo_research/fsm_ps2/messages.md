# Messages for Task: fsm_ps2

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.The PS/2 mouse protocol sends messages that are three bytes long. However, within a continuous byte stream, it's not obvious where messages start and end. The only indication is that the first byte of each three byte message always has in[3]=1 (but in[3] of the other two bytes may be 1 or 0 depending on data). We want a finite state machine that will search for message boundaries when given an input byte stream. The algorithm we'll use is to discard bytes until we see one with in[3]=1. We then assume that this is byte 1 of a message, and signal the receipt of a message once all 3 bytes have been received (done). The FSM should signal done in the cycle immediately after the third byte of each message was successfully received. Reset should be active high synchronous.

The compressed specification is as follows: Pure CMB Logic :
```json
{
  "header": "The top module header definition from module top_module (\n\tinput clk,\n\tinput [7:0] in,\n\tinput reset,\n\toutput done\n);\n, including the interface definition and their behavior. The 'in' input is an 8-bit wide signal representing the input byte stream. The 'reset' input is a synchronous reset signal. The 'done' output signal indicates that a complete three-byte message has been received.",
  "combinational_logic_function": "The combinational logic determines the 'done' output based on the current state and the input 'in'. The 'done' signal is asserted only when the FSM is in the state corresponding to the reception of the third byte of a valid message. The validity of a message is determined by the condition in[3]=1 for the first byte. The combinational logic for 'done' can be represented as: done = (current_state == STATE_3BYTE). The next state logic depends on the current state and the input 'in'. The combinational logic for the next state is defined by the state transition table. The reset signal forces the FSM to the initial state, which is searching for the first byte (in[3]=1).",
  "enhanced_combinational_description": "The combinational logic is responsible for generating the 'done' output signal based on the current state of the implied FSM. The 'done' signal is asserted high only when the FSM has received three consecutive bytes, where the first byte has in[3] equal to 1. The combinational logic for 'done' is a direct mapping from the 'third byte received' state to the output. Specifically, 'done' is asserted if and only if the FSM is in the state representing the third byte of a valid message. The combinational logic also determines the next state of the FSM based on the current state and the input 'in'. If the current state is 'searching', the next state is 'byte1' if in[3] is 1, otherwise it remains in 'searching'. If the current state is 'byte1', the next state is 'byte2' regardless of the input. If the current state is 'byte2', the next state is 'byte3' regardless of the input. If the current state is 'byte3', the next state is 'searching' regardless of the input. The reset signal, when asserted high, forces the FSM to the 'searching' state. This reset functionality is implemented using combinational logic that overrides the next state logic when reset is active. The combinational logic for the next state can be described as follows:\n\nnext_state = reset ? SEARCHING : (\n current_state == SEARCHING ? (in[3] ? BYTE1 : SEARCHING) :\n current_state == BYTE1 ? BYTE2 :\n current_state == BYTE2 ? BYTE3 :\n SEARCHING\n);\n\nThe 'done' signal is asserted only when current_state is BYTE3.\n\ndone = (current_state == BYTE3);\n\nWhere SEARCHING, BYTE1, BYTE2, and BYTE3 are symbolic representations of the FSM's states."
}
```

 With Timing Logic Summary:
```json
{
  "header": "The module `top_module` implements a finite state machine (FSM) to detect 3-byte PS/2 mouse messages within a continuous byte stream. The FSM searches for a byte with in[3] == 1, then assumes the next two bytes complete the message. The `done` signal is asserted for one clock cycle after the third byte is received. The reset is synchronous and active high.",
  "Interface Behavior": "The `clk` input is the clock signal. The `in` input is an 8-bit data input. The `reset` input is a synchronous, active-high reset. The `done` output is asserted for one clock cycle after the third byte of a potential message is received, where a potential message starts with a byte where in[3] == 1. The `done` signal is asserted in the clock cycle immediately after the third byte is received.",
  "Timing Dependency": "The FSM's state transitions are synchronized to the rising edge of `clk`. The `reset` signal, when high, synchronously resets the FSM to its initial state on the rising edge of `clk`. The `done` signal's assertion is dependent on the arrival of three consecutive bytes, with the first byte having `in[3] == 1`, and is asserted on the rising edge of `clk` after the third byte is received. There are no specified timing constraints or delays.",
  "Timing logic": "The FSM likely uses a register to store its current state. The state transitions occur on the rising edge of `clk` using non-blocking assignments (`<=`). The number of registers depends on the number of states in the FSM (at least 3 states are needed: searching for the first byte, receiving the second byte, and receiving the third byte). The `done` signal is likely a registered output, asserted for one clock cycle. The FSM uses the rising edge of `clk` to update its state and output."
}
```

The header you have already known is:module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output done
);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

