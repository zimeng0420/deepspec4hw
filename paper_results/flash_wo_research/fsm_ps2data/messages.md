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
// 190ns           0               0               aa              0                    x          

The compressed specification is as follows: Pure CMB Logic :
```json
{
  "header": "module top_module (\n\tinput clk,\n\tinput [7:0] in,\n\tinput reset,\n\toutput [23:0] out_bytes,\n\toutput done\n); \n\nThe module `top_module` receives an 8-bit input `in`, a clock signal `clk`, and a reset signal `reset`. It outputs a 24-bit value `out_bytes` and a single-bit signal `done`. The `done` signal indicates the completion of a 3-byte message reception, and `out_bytes` holds the concatenated 3-byte message when `done` is asserted. The `reset` signal is a synchronous reset.",
  "combinational_logic_function": "The combinational logic is responsible for generating the `out_bytes` and `done` signals based on the current state and the input `in`. The `done` signal is asserted only when the third byte of a message has been received, and the `out_bytes` signal must be valid at the same time. The combinational logic for `out_bytes` involves multiplexing the input `in` into the appropriate byte positions based on the current state. The `done` signal is generated by ANDing the appropriate state bits. The combinational logic for the next state is based on the current state and the input `in[3]`. If `in[3]` is 1, the FSM transitions to the 'byte1_received' state. The combinational logic for the datapath involves shifting and storing the incoming bytes into the `out_bytes` register. The combinational logic for the reset signal ensures that the FSM returns to the 'searching' state when reset is asserted.",
  "enhanced_combinational_description": "The combinational logic within `top_module` is responsible for generating the `done` signal and the `out_bytes` value. The `done` signal is asserted high for one clock cycle immediately after the third byte of a valid message is received. A valid message is defined as a sequence of three bytes, where the first byte has `in[3]` equal to 1. The `out_bytes` signal holds the concatenated value of the three received bytes, with the first byte in `out_bytes[23:16]`, the second byte in `out_bytes[15:8]`, and the third byte in `out_bytes[7:0]`. The value of `out_bytes` is only valid when `done` is asserted. At all other times, the value of `out_bytes` is a don't-care. The combinational logic determines when to assert `done` based on the history of the input stream `in`. Specifically, it must detect when a byte with `in[3] = 1` has been received, followed by two subsequent bytes. The `out_bytes` value is generated by concatenating the three bytes received in the correct order. The combinational logic also handles the reset condition. When `reset` is asserted, the FSM returns to the 'searching' state, and the `done` signal is deasserted. The combinational logic ensures that the `done` signal remains deasserted until a new valid message is received. The combinational logic for the datapath involves storing the incoming bytes into the `out_bytes` register. The combinational logic for the reset signal ensures that the FSM returns to the 'searching' state when reset is asserted."
}
```

 With Timing Logic Summary:
```json
{
  "header": "The module `top_module` implements a finite state machine (FSM) that detects 3-byte messages within an input byte stream. It has a clock input `clk`, an 8-bit data input `in`, a synchronous active-high reset input `reset`, a 24-bit output `out_bytes` representing the received message, and a 1-bit output `done` signaling the completion of message reception.",
  "Interface Behavior": "The `reset` signal, when asserted high on a rising edge of `clk`, resets the FSM to its initial state. The `in` signal provides the byte stream. The `done` signal is asserted for one clock cycle immediately after the third byte of a message is received. The `out_bytes` signal is valid only when `done` is asserted, containing the 24-bit message formed by the three received bytes. The most significant byte of `out_bytes` (out_bytes[23:16]) corresponds to the first received byte, the middle byte (out_bytes[15:8]) to the second, and the least significant byte (out_bytes[7:0]) to the third.",
  "Timing Dependency": "The FSM's state transitions occur on the rising edge of `clk`. The `reset` signal must be stable before the rising edge of `clk` to ensure proper reset operation. The `in` signal must be stable for a setup time before the rising edge of `clk` and held stable for a hold time after the rising edge of `clk` to ensure correct data capture. The `done` signal is asserted synchronously with the rising edge of `clk`, one clock cycle after the third byte is received. The `out_bytes` signal becomes valid at the same time as `done` is asserted, also synchronously with the rising edge of `clk`.",
  "Timing logic": "The FSM likely uses registers to store the current state and the received bytes. The state transitions are determined by the current state and the input `in`. The `done` signal is asserted based on the FSM's state. The `out_bytes` signal is assigned the concatenated values of the three stored bytes when `done` is asserted. The FSM likely uses non-blocking assignments (`<=`) within an `always @(posedge clk)` block to update the state and byte registers. The number of registers depends on the number of states in the FSM and the number of bytes being stored (at least 3 registers, one for each byte). The FSM transitions on the positive edge of the clock. The reset signal is synchronous, so the registers are reset when reset is high on the rising edge of the clock."
}
```

The header you have already known is:module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output [23:0] out_bytes,
	output done
);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

