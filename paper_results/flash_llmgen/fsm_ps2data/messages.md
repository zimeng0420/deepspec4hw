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

The header you have already known is:module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output [23:0] out_bytes,
	output done
);


You can use the technical specification as follows:Okay, I understand the task. Here's a technical specification and Verilog implementation for the finite state machine (FSM) and datapath to detect and output 3-byte messages from an input byte stream.

**Technical Specification**

**1. Functional Overview:**

The module `top_module` receives a serial byte stream (`in[7:0]`) and identifies message boundaries. A message is defined as a sequence of three bytes, where the first byte must have its most significant bit (MSB), `in[3]`, set to 1. The module outputs the 24-bit message (`out_bytes[23:0]`) and asserts the `done` signal for one clock cycle immediately after the third byte of a valid message is received.

**2. Inputs:**

*   `clk`: Clock signal.
*   `in[7:0]`: 8-bit input byte stream.
*   `reset`: Active-high synchronous reset signal.

**3. Outputs:**

*   `out_bytes[23:0]`: 24-bit output representing the received message. `out_bytes[23:16]` is the first byte, `out_bytes[15:8]` is the second byte, and `out_bytes[7:0]` is the third byte.  Valid only when `done` is asserted.
*   `done`: 1-bit output signal. Asserted high for one clock cycle when a complete message has been received.

**4. State Machine Description:**

The FSM will have the following states:

*   **`IDLE`**:  The FSM is waiting for the start of a message. It remains in this state until it receives a byte where `in[3]` is 1.
*   **`BYTE1`**: The first byte of the message has been received. The FSM stores this byte.
*   **`BYTE2`**: The second byte of the message has been received. The FSM stores this byte.
*   **`BYTE3`**: The third byte of the message has been received. The FSM stores this byte, asserts the `done` signal, and prepares to output the complete message.

**5. Datapath Description:**

The datapath will consist of:

*   Three 8-bit registers to store the received bytes (`byte1`, `byte2`, `byte3`).
*   A 24-bit register to hold the concatenated message (`out_bytes`).
*   Logic to concatenate the three byte registers into the `out_bytes` register.

**6. Reset Behavior:**

When the `reset` signal is asserted, the FSM returns to the `IDLE` state, and all registers (byte1, byte2, byte3, out_bytes) are reset to 0.

**7. Timing Considerations:**

*   The `done` signal is asserted synchronously with the clock, immediately after the third byte is received.
*   The `out_bytes` output is valid only when the `done` signal is asserted.  Its value is don't-care at other times.

**8. Error Handling:**

*   The FSM does not explicitly handle error conditions (e.g., a message not starting with a byte where `in[3]` is 1). It simply discards bytes until it finds one that satisfies the condition.

**Verilog Implementation**

```verilog
module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output [23:0] out_bytes,
    output done
);

  // State Definition
  localparam IDLE  = 2'b00;
  localparam BYTE1 = 2'b01;
  localparam BYTE2 = 2'b10;
  localparam BYTE3 = 2'b11;

  // State Register
  reg [1:0] current_state;
  reg [1:0] next_state;

  // Data Registers
  reg [7:0] byte1;
  reg [7:0] byte2;
  reg [7:0] byte3;
  reg [23:0] out_bytes_reg; // Internal register for out_bytes
  reg done_reg;

  // Output Assignment
  assign out_bytes = out_bytes_reg;
  assign done = done_reg;

  // State Transition Logic
  always @(*) begin
    case (current_state)
      IDLE: begin
        if (in[3]) begin
          next_state = BYTE1;
        end else begin
          next_state = IDLE;
        end
      end
      BYTE1: begin
        next_state = BYTE2;
      end
      BYTE2: begin
        next_state = BYTE3;
      end
      BYTE3: begin
        next_state = IDLE;
      end
      default: begin
        next_state = IDLE; // Default case for safety
      end
    endcase
  end

  // State Update Logic
  always @(posedge clk) begin
    if (reset) begin
      current_state <= IDLE;
      byte1 <= 0;
      byte2 <= 0;
      byte3 <= 0;
      out_bytes_reg <= 0;
      done_reg <= 0;
    end else begin
      current_state <= next_state;
      done_reg <= 0; // Default to 0, set to 1 only in BYTE3

      case (current_state)
        IDLE: begin
          if (in[3]) begin
            byte1 <= in;
          end
        end
        BYTE1: begin
          byte2 <= in;
        end
        BYTE2: begin
          byte3 <= in;
        end
        BYTE3: begin
          out_bytes_reg <= {byte1, byte2, byte3};
          done_reg <= 1; // Assert done signal
        end
        default: begin
          byte1 <= 0;
          byte2 <= 0;
          byte3 <= 0;
          out_bytes_reg <= 0;
          done_reg <= 0;
        end
      endcase
    end
  end

endmodule
```

**Explanation:**

1.  **State Machine:** The code defines the four states (`IDLE`, `BYTE1`, `BYTE2`, `BYTE3`) and the state transition logic.  The `current_state` and `next_state` registers hold the current and next states, respectively.
2.  **Datapath:** The `byte1`, `byte2`, and `byte3` registers store the incoming bytes. The `out_bytes_reg` register stores the concatenated 24-bit message.
3.  **State Transition Logic (`always @(*)`):** This block determines the next state based on the current state and the input.
4.  **State Update Logic (`always @(posedge clk)`):** This block updates the current state, the byte registers, and the `done` signal on the rising edge of the clock.
5.  **Reset Logic:** When `reset` is asserted, the FSM returns to the `IDLE` state, and all registers are cleared.
6.  **Output Assignment:** The `assign` statements connect the internal `out_bytes_reg` and `done_reg` to the output ports `out_bytes` and `done`, respectively.
7.  **`done` Signal:** The `done` signal is asserted only in the `BYTE3` state, indicating that a complete message has been received.
8.  **Concatenation:** The `out_bytes_reg` is updated with the concatenated bytes in the `BYTE3` state: `{byte1, byte2, byte3}`.
9.  **Default Cases:**  The `default` cases in the `case` statements provide a safety net to ensure that the FSM and datapath are in a known state if an unexpected condition occurs.

**How to Test:**

You can use a Verilog simulator (like ModelSim, Icarus Verilog, or Vivado Simulator) to test this module. Create a testbench that provides the clock, reset, and input data, and then observe the outputs (`out_bytes` and `done`).  The waveform example you provided is a good starting point for creating your testbench.

**Testbench Example (Illustrative):**

```verilog
module testbench;

  reg clk;
  reg [7:0] in;
  reg reset;
  wire [23:0] out_bytes;
  wire done;

  // Instantiate the module
  top_module dut (
    .clk(clk),
    .in(in),
    .reset(reset),
    .out_bytes(out_bytes),
    .done(done)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns period
  end

  // Test sequence
  initial begin
    reset = 1;
    in = 0;
    #15 reset = 0;

    #5 in = 8'h2c;
    #10 in = 8'h81;
    #10 in = 8'h09;
    #10 in = 8'h6b;

    #15 in = 8'hd;
    #10 in = 8'h8d;
    #10 in = 8'h6d;

    #15 in = 8'h12;
    #10 in = 8'h01;
    #10 in = 8'hd;

    #15 in = 8'h76;
    #10 in = 8'h3d;
    #10 in = 8'hed;

    #15 in = 8'h8c;
    #10 in = 8'hf9;
    #10 in = 8'hce;

    #15 in = 8'hc5;
    #10 in = 8'haa;
    #10 in = 8'hd;

    #100 $finish;
  end

  // Monitor the outputs
  initial begin
    $monitor("time = %0t, clk = %b, reset = %b, in = %h, done = %b, out_bytes = %h",
             $time, clk, reset, in, done, out_bytes);
  end

endmodule
```

This testbench provides a basic example of how to stimulate the module and observe the outputs.  You should expand this testbench to cover all the cases in your waveform example and any other edge cases you can think of.

This specification and code should fulfill your requirements. Let me know if you have any questions or need further modifications!
Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

