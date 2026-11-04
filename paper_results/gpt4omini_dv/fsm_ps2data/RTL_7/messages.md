# Messages for Task: fsm_ps2data

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.We want a finite state machine that will search for message boundaries when given an input byte stream. The algorithm we'll use is to discard bytes until we see one with in[3]=1. We then assume that this is byte 1 of a message, and signal the receipt of a message once all 3 bytes have been received (done). The FSM should signal done in the cycle immediately after the third byte of each message was successfully received.

// Implement the datapath module that will output the 24-bit (3 byte) message whenever a packet is received (out_bytes[23:16] is the first byte, out_bytes[15:8] is the second byte, etc.). The reset signal is active high synchronous. out_bytes needs to be valid whenever the done signal is asserted. You may output anything at other times (i.e., don't-care). 

// Waveform example:
// time            clk             reset           in[7:0]         done            out_bytes       
// 0ns             0               1                0              x                    x          
// 5ns             1               1                0              0                    x          
// 10ns            0               1                0              0                    x          
// 15ns            1               0               2c              0                    x          
// 20ns            0               0               2c              0                    x          
// 25ns            1               0               81              0                    x          
// 30ns            0               0               81              0                    x          
// 35ns            1               0                9              0                    x          
// 40ns            0               0                9              0                    x          
// 45ns            1               0               6b              1               2c8109          
// 50ns            0               0               6b              1               2c8109          
// 55ns            1               0                d              0                    x          
// 60ns            0               0                d              0                    x          
// 65ns            1               0               8d              0                    x          
// 70ns            0               0               8d              0                    x          
// 75ns            1               0               6d              1               6b0d8d          
// 80ns            0               0               6d              1               6b0d8d          
// 85ns            1               0               12              0                    x          
// 90ns            0               0               12              0                    x          
// 95ns            1               0                1              0                    x          
// 100ns           0               0                1              0                    x          
// 105ns           1               0                d              1               6d1201          
// 110ns           0               0                d              1               6d1201          
// 115ns           1               0               76              0                    x          
// 120ns           0               0               76              0                    x          
// 125ns           1               0               3d              0                    x          
// 130ns           0               0               3d              0                    x          
// 135ns           1               0               ed              1                d763d          
// 140ns           0               0               ed              1                d763d          
// 145ns           1               0               8c              0                    x          
// 150ns           0               0               8c              0                    x          
// 155ns           1               0               f9              0                    x          
// 160ns           0               0               f9              0                    x          
// 165ns           1               0               ce              1               ed8cf9          
// 170ns           0               0               ce              1               ed8cf9          
// 175ns           1               0               c5              0                    x          
// 180ns           0               0               c5              0                    x          
// 185ns           1               0               aa              0                    x          
// 190ns           0               0               aa              0                    x          The header you have already known is:module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output [23:0] out_bytes,
	output done
);

```

## User Message

```


You can use the technical specification as follows:Pure CMB Logic :
```json
{
  "header": "The top module header definition from module top_module ( input clk, input [7:0] in, input reset, output [23:0] out_bytes, output done );, including the interface definition and their behavior.",
  
  "combinational_logic_function": "The combinational logic for the FSM is structured to derive outputs based on the input byte stream and the current state of the FSM. The output 'done' is asserted when three valid bytes have been received, with the first byte being identified by the condition 'in[3]=1'. The output 'out_bytes' is constructed as follows: when the FSM transitions to the state indicating that the first byte has been received, the first byte is stored in 'out_bytes[23:16]'. The second byte is stored in 'out_bytes[15:8]' upon the next valid input, and the third byte is stored in 'out_bytes[7:0]'. The logic organization is divided into state detection logic, byte storage logic, and output generation logic. Signal flow is optimized by ensuring that the state transitions and output assignments occur in a single combinational block, minimizing the critical path. Operator sharing is implemented by reusing the same logic for state detection and output assignment, while logic level balancing is achieved by ensuring that all outputs are derived from the same set of input conditions. Output multiplexing is organized such that 'out_bytes' is only valid when 'done' is asserted, allowing for don't-care conditions at other times.",
  
  "enhanced_combinational_description": "Comprehensive combinational logic specification derived from User: SEQ We want a finite state machine that will search for message boundaries when given an input byte stream. The algorithm we'll use is to discard bytes until we see one with in[3]=1. We then assume that this is byte 1 of a message, and signal the receipt of a message once all 3 bytes have been received (done). The FSM should signal done in the cycle immediately after the third byte of each message was successfully received. The datapath module will output the 24-bit (3 byte) message whenever a packet is received (out_bytes[23:16] is the first byte, out_bytes[15:8] is the second byte, etc.). The reset signal is active high synchronous. out_bytes needs to be valid whenever the done signal is asserted. You may output anything at other times (i.e., don't-care)."
}
```

 With Timing Logic Summary:
```json
{
  "header": "The module 'top_module' is a finite state machine (FSM) designed to detect message boundaries in an input byte stream. It has three input ports: 'clk' (clock), 'in' (8-bit input byte), and 'reset' (active high synchronous reset). The outputs are 'out_bytes' (24-bit output message) and 'done' (signal indicating message receipt). The FSM discards bytes until it detects a byte with in[3]=1, then collects three bytes and asserts 'done' immediately after the third byte is received.",
  "Interface Behavior": "The 'clk' signal toggles every 5ns, while 'reset' is high at 0ns and transitions to low at 15ns. The 'in' signal changes at every clock cycle, with specific values indicating the bytes being processed. The 'done' signal is asserted in the cycle immediately after the third byte is received (e.g., at 45ns, 75ns, 105ns, 135ns, and 165ns). The 'out_bytes' is valid only when 'done' is asserted.",
  "Timing Dependency": "The FSM is sensitive to the rising edge of 'clk'. The critical timing events are as follows: 'reset' is high at 0ns, and the FSM begins processing at 15ns when 'reset' goes low. The 'done' signal is asserted at 45ns, 75ns, 105ns, 135ns, and 165ns, corresponding to the completion of receiving three bytes. The output 'out_bytes' is valid during the clock cycle immediately following the assertion of 'done'.",
  "Timing logic": "The FSM consists of a state register that captures the current state on the rising edge of 'clk'. There are three registers to hold the received bytes, with non-blocking assignments used to update 'out_bytes' on the clock edge. The state transitions occur based on the input 'in' and the current state, with the output 'done' being asserted immediately after the third byte is received. The design uses synchronous reset to initialize the state and output registers."
}
```

Please only reply with the Verilog code, no other words.

Please always begin with `module top_module()`. 
```

