# Messages for Task: fsm_ps2

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.The PS/2 mouse protocol sends messages that are three bytes long. However, within a continuous byte stream, it's not obvious where messages start and end. The only indication is that the first byte of each three byte message always has in[3]=1 (but in[3] of the other two bytes may be 1 or 0 depending on data). We want a finite state machine that will search for message boundaries when given an input byte stream. The algorithm we'll use is to discard bytes until we see one with in[3]=1. We then assume that this is byte 1 of a message, and signal the receipt of a message once all 3 bytes have been received (done). The FSM should signal done in the cycle immediately after the third byte of each message was successfully received. Reset should be active high synchronous.The header you have already known is:module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output done
);

```

## User Message

```


You can use the technical specification as follows:Pure CMB Logic :
```json
{
  "header": "The top module header definition from module top_module ( input clk, input [7:0] in, input reset, output done );, including the interface definition and their behavior.",
  
  "combinational_logic_function": "The combinational logic for the FSM is structured to derive the output 'done' based on the state transitions and the input signal 'in'. The logic organization is divided into distinct functional blocks: state detection, message boundary identification, and output generation. The state detection logic evaluates the current state and the input signal 'in[3]' to determine the next state. The message boundary identification logic discards bytes until 'in[3] = 1' is detected, indicating the start of a new message. The output generation logic asserts 'done' when the third byte of a message is received. The signal flow is optimized to minimize critical paths by ensuring that state transitions and output generation occur in a single clock cycle. Operator sharing is implemented where possible to reduce resource usage, and logic level balancing is applied to equalize delays across the combinational paths. The output multiplexing logic is organized to select the appropriate output based on the current state, ensuring that 'done' is only asserted for one clock cycle after the third byte is received.",

  "enhanced_combinational_description": "Comprehensive combinational logic specification derived from User: SEQ The PS/2 mouse protocol sends messages that are three bytes long. However, within a continuous byte stream, it's not obvious where messages start and end. The only indication is that the first byte of each three-byte message always has in[3]=1 (but in[3] of the other two bytes may be 1 or 0 depending on data). We want a finite state machine that will search for message boundaries when given an input byte stream. The algorithm we'll use is to discard bytes until we see one with in[3]=1. We then assume that this is byte 1 of a message, and signal the receipt of a message once all 3 bytes have been received (done). The FSM should signal done in the cycle immediately after the third byte of each message was successfully received. Reset should be active high synchronous. The combinational logic will consist of the following states: 1) Discard: In this state, the FSM continuously checks the input 'in[3]'. If 'in[3] = 1', it transitions to the Byte1 state. 2) Byte1: This state indicates that the first byte of a message has been detected. The FSM will transition to Byte2 on the next clock cycle. 3) Byte2: The FSM receives the second byte and transitions to Byte3 on the next clock cycle. 4) Byte3: The FSM receives the third byte and asserts 'done' for one clock cycle before transitioning back to the Discard state. The combinational logic will ensure that the transitions between these states are seamless and that the 'done' signal is generated correctly based on the state transitions. The synchronous reset will return the FSM to the Discard state when activated, ensuring that the FSM starts in a known state ready to detect the next message."
}
```

 With Timing Logic Summary:
```json
{
  "header": "module top_module (\n    input clk,\n    input [7:0] in,\n    input reset,\n    output done\n);",
  "Interface Behavior": "The module has a clock input (clk) that triggers state transitions on the rising edge. The reset input is active high and synchronous, resetting the FSM to its initial state on the next clock edge when asserted. The output done is asserted for one clock cycle immediately after the third byte of a message is received.",
  "Timing Dependency": "The FSM transitions occur on the rising edge of clk. The reset signal must be asserted high for the FSM to reset to the initial state. The done signal is asserted in the clock cycle immediately following the reception of the third byte. The timing characteristics are critical as the FSM must correctly identify the start of a message (when in[3]=1) and ensure that done is only asserted after the third byte is received.",
  "Timing logic": "The FSM consists of three registers to hold the current state. The state transitions occur on the positive edge of clk using non-blocking assignments. The states are: Discard, Byte1, Byte2, and Byte3. The done signal is generated based on the current state and is asserted for one clock cycle after transitioning from Byte3. The reset condition is handled synchronously, ensuring that the FSM returns to the Discard state when reset is high."
}
```

Please only reply with the Verilog code, no other words.

Please always begin with `module top_module()`. 
```

