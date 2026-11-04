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
  "header": "The top module `top_module` has the following interface:\n\n*   **Inputs:**\n    *   `clk`: Clock signal for synchronous operation.\n    *   `in[7:0]`: 8-bit input data stream.\n    *   `reset`: Reset signal (active high, synchronous).\n*   **Outputs:**\n    *   `out_bytes[23:0]`: 24-bit output representing the concatenated three-byte message.\n    *   `done`: Output signal indicating that a complete three-byte message has been received and `out_bytes` is valid. `done` is asserted in the cycle immediately after the third byte is received.",
  "combinational_logic_function": "The combinational logic is responsible for:\n\n1.  **Message Boundary Detection:** Detecting the start of a message by checking if `in[3]` is equal to 1.\n2.  **Byte Storage:** Storing the incoming bytes in a sequence.\n3.  **Output Generation:** Concatenating the three stored bytes to form the `out_bytes` output.\n4.  **Done Signal Assertion:** Asserting the `done` signal when three valid bytes have been received.\n\nThe combinational logic can be structured as follows:\n\n*   **Input Filtering Logic:** A comparator checks if `in[3]` is high. This signal is used to enable the byte storage logic.\n*   **Byte Storage Logic:** Three 8-bit registers (implemented using flip-flops, but the combinational logic controls their loading) to store the incoming bytes. The loading of these registers is controlled by the message boundary detection logic and a counter.\n*   **Concatenation Logic:** A concatenation operator combines the three 8-bit registers into a single 24-bit output (`out_bytes`).\n*   **Done Signal Logic:** A counter counts the number of received bytes. When the counter reaches 3, the `done` signal is asserted. This signal is generated by combinational logic based on the counter's value.\n\n**Signal Flow Optimization:**\n\n*   The critical path is likely to be the path from the input `in` to the `done` signal. This path includes the comparator, the counter, and the logic that asserts `done`. Minimizing the delay in this path is crucial for performance.\n\n**Operator Sharing and Resource Utilization Strategies:**\n\n*   If the target technology supports it, use dedicated comparators for the message boundary detection logic.\n\n**Logic Level Balancing and Delay Equalization Techniques:**\n\n*   Ensure that the delays in the paths to the byte storage registers are balanced to avoid skew.\n\n**Output Multiplexing and Selection Logic Organization:**\n\n*   No multiplexing is required for the `out_bytes` output. The concatenation operator directly combines the three byte registers.",
  "enhanced_combinational_description": "The combinational logic within the `top_module` is designed to process an incoming byte stream (`in[7:0]`) and identify message boundaries. A message is defined as a sequence of three bytes, where the first byte is identified by having its bit 3 (`in[3]`) set to 1. The module outputs the concatenated three-byte message (`out_bytes[23:0]`) and asserts the `done` signal after receiving all three bytes.\n\n**1. Message Boundary Detection Logic:**\n\n*   This logic is responsible for identifying the start of a new message. It continuously monitors the input byte stream (`in[7:0]`) and checks if `in[3]` is equal to 1. This is achieved using a bitwise AND operation with a mask: `in & 8'b00001000`. If the result is non-zero, it indicates that `in[3]` is set, and a potential message start is detected.\n*   The output of this logic is a single-bit signal, `message_start`, which is asserted when a potential message start is detected.\n\n**2. Byte Storage and Sequencing Logic:**\n\n*   This logic consists of three 8-bit storage elements (conceptually registers, but the loading is controlled combinatorially) to hold the three bytes of the message: `byte1[7:0]`, `byte2[7:0]`, and `byte3[7:0]`. These storage elements are loaded sequentially with the incoming bytes after a message start is detected.\n*   A 2-bit counter, `byte_count[1:0]`, is used to track the number of bytes received since the last message start. The counter increments on each clock cycle after `message_start` is asserted, up to a maximum value of 2 (representing three bytes).\n*   The loading of the byte storage elements is controlled by the `byte_count` value:\n    *   When `byte_count == 0`, `byte1` is loaded with the current input byte (`in`).\n    *   When `byte_count == 1`, `byte2` is loaded with the current input byte (`in`).\n    *   When `byte_count == 2`, `byte3` is loaded with the current input byte (`in`).\n*   The loading of the storage elements is enabled only when `message_start` is asserted or when `byte_count` is less than 3. This ensures that only valid bytes within a message are stored.\n\n**3. Output Generation Logic:**\n\n*   This logic concatenates the three stored bytes (`byte1`, `byte2`, and `byte3`) to form the 24-bit output `out_bytes[23:0]`. The concatenation is performed as follows: `out_bytes = {byte1, byte2, byte3}`. `byte1` represents the most significant byte (MSB) of `out_bytes`, and `byte3` represents the least significant byte (LSB).\n*   The `out_bytes` output is valid only when the `done` signal is asserted.\n\n**4. Done Signal Generation Logic:**\n\n*   The `done` signal is asserted when all three bytes of a message have been received. This occurs when `byte_count` reaches 2. The `done` signal is asserted in the clock cycle immediately after `byte3` is loaded.\n*   The `done` signal is generated by comparing `byte_count` to 2. If `byte_count == 2`, then `done` is asserted; otherwise, `done` is de-asserted.\n\n**5. Reset Logic:**\n\n*   The `reset` signal is a synchronous, active-high reset. When `reset` is asserted, the `byte_count` counter is reset to 0, effectively discarding any partially received message. The byte storage elements (`byte1`, `byte2`, and `byte3`) are also reset to a default value (e.g., all zeros). The `done` signal is de-asserted.\n\n**Detailed Combinational Logic Breakdown:**\n\n*   **`message_start` Generation:**\n    *   `message_start = in[3]`\n*   **`byte_count` Increment Logic:**\n    *   `next_byte_count = (reset) ? 0 : ((message_start || (byte_count < 3'd3)) ? (byte_count + 1'b1) : byte_count)`\n*   **Byte Storage Load Enable Logic:**\n    *   `load_byte1 = (message_start && (byte_count == 0))`\n    *   `load_byte2 = (message_start && (byte_count == 1))`\n    *   `load_byte3 = (message_start && (byte_count == 2))`\n*   **`out_bytes` Generation:**\n    *   `out_bytes = {byte1, byte2, byte3}`\n*   **`done` Signal Generation:**\n    *   `done = (byte_count == 3'd3)`\n\nThis specification provides a comprehensive description of the combinational logic required to implement the message boundary detection and data path functionality. It details the logic functions, signal flow, and control signals necessary for the correct operation of the module."
}
```

 With Timing Logic Summary:
```json
{
  "header analysis": "The module `top_module` implements a finite state machine (FSM) that detects message boundaries in an input byte stream. It has a clock input `clk`, an 8-bit data input `in`, a synchronous active-high reset input `reset`, a 24-bit output `out_bytes` representing the received message, and a 1-bit output `done` signaling the completion of message reception. The FSM searches for a start byte where `in[3]` is 1, then collects the next two bytes. After receiving three bytes, it asserts `done` for one clock cycle and outputs the 24-bit message on `out_bytes`. `out_bytes` is only valid when `done` is asserted.",
  "Circuit type": "Sequential (posedge)",
  "Timing Dependency": "The `reset` signal is synchronous and active-high. When `reset` is asserted high on a rising edge of `clk`, the FSM returns to its initial state. The `done` signal is asserted for one clock cycle immediately after the third byte of a message is received. The `out_bytes` output is valid only when `done` is asserted, meaning it's valid for one clock cycle after the third byte is received. The FSM transitions between states on the rising edge of `clk`.",
  "Timing Logic Implementation": "The FSM requires at least 3 registers: one for the current state, and two to store the incoming bytes. The state register will determine the current state of the FSM. The FSM transitions between states on the rising edge of the clock (`clk`). The `out_bytes` register is updated with the received bytes. The `done` signal is asserted for one clock cycle after the third byte is received. All state transitions and register updates should be implemented using non-blocking assignments (`<=`). The FSM will likely have the following states: IDLE, BYTE1, BYTE2, BYTE3, DONE. The state transitions are triggered by the input `in` and the current state. The reset signal synchronously resets the state register to the IDLE state on the rising edge of the clock."
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

