# Messages for Task: fsm_ps2

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.The PS/2 mouse protocol sends messages that are three bytes long. However, within a continuous byte stream, it's not obvious where messages start and end. The only indication is that the first byte of each three byte message always has in[3]=1 (but in[3] of the other two bytes may be 1 or 0 depending on data). We want a finite state machine that will search for message boundaries when given an input byte stream. The algorithm we'll use is to discard bytes until we see one with in[3]=1. We then assume that this is byte 1 of a message, and signal the receipt of a message once all 3 bytes have been received (done). The FSM should signal done in the cycle immediately after the third byte of each message was successfully received. Reset should be active high synchronous.

The header you have already known is:module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output done
);


You can use the technical specification as follows:Okay, I accept the challenge. I am ready to leverage my vast knowledge of Verilog and hardware design to create the Finite State Machine (FSM) for PS/2 mouse message boundary detection. I understand the requirements, the input/output signals, and the algorithm. I will provide a complete and functional Verilog module, along with a detailed technical specification.

Here's the technical specification and the Verilog code:

**1. Technical Specification: PS/2 Mouse Message Boundary Detector**

*   **Module Name:** `ps2_mouse_fsm` (This is a more descriptive name than `top_module`, but I will adapt the code to fit your `top_module` if you prefer)
*   **Functionality:** Detects the start and end of PS/2 mouse messages within a continuous byte stream.
*   **Input Signals:**
    *   `clk`:  System clock (1-bit, input)
    *   `in`:  8-bit input data byte (8-bit, input)
    *   `reset`:  Synchronous reset signal (1-bit, input, active high)
*   **Output Signals:**
    *   `done`:  Indicates the successful receipt of a complete 3-byte message (1-bit, output, asserted for one clock cycle after the third byte)
*   **Internal State:**
    *   `state`:  A 2-bit state variable representing the current state of the FSM.
*   **States:**
    *   `IDLE`:  The FSM is waiting for the start of a new message.
    *   `BYTE1`:  The first byte of a potential message has been received.
    *   `BYTE2`:  The second byte of the message has been received.
    *   `BYTE3`:  The third byte of the message has been received.
*   **Algorithm:**
    1.  **IDLE State:**
        *   The FSM waits for an input byte where `in[3] == 1`.
        *   If `in[3] == 1`, transition to the `BYTE1` state.
        *   If `reset` is asserted, remain in the `IDLE` state.
    2.  **BYTE1 State:**
        *   The first byte of a potential message has been received.
        *   Transition to the `BYTE2` state on the next clock cycle.
        *   If `reset` is asserted, transition to the `IDLE` state.
    3.  **BYTE2 State:**
        *   The second byte of the message has been received.
        *   Transition to the `BYTE3` state on the next clock cycle.
        *   If `reset` is asserted, transition to the `IDLE` state.
    4.  **BYTE3 State:**
        *   The third byte of the message has been received.
        *   Assert `done` for one clock cycle.
        *   Transition to the `IDLE` state on the next clock cycle.
        *   If `reset` is asserted, transition to the `IDLE` state.
*   **Timing:**
    *   `done` is asserted for one clock cycle immediately after the third byte is received.
    *   All state transitions are synchronous to the rising edge of the clock.
*   **Assumptions:**
    *   The input byte stream is valid.
    *   The clock signal is stable.
    *   The reset signal is synchronous.

**2. Verilog Code (Adaptable to `top_module`)**

```verilog
module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    // State Definitions
    localparam IDLE = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;
    localparam BYTE3 = 2'b11;

    // State Register
    reg [1:0] state;

    // Internal Signals
    reg [7:0] byte1, byte2, byte3; // Store the bytes if needed for debugging or further processing

    // State Transition Logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (in[3]) begin
                        state <= BYTE1;
                    end else begin
                        state <= IDLE;
                    end
                end
                BYTE1: begin
                    byte1 <= in; // Store the first byte (optional)
                    state <= BYTE2;
                    done <= 1'b0;
                end
                BYTE2: begin
                    byte2 <= in; // Store the second byte (optional)
                    state <= BYTE3;
                    done <= 1'b0;
                end
                BYTE3: begin
                    byte3 <= in; // Store the third byte (optional)
                    state <= IDLE;
                    done <= 1'b1; // Assert done for one cycle
                end
                default: begin
                    state <= IDLE; // Default to IDLE for safety
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule
```

**3. Explanation of the Code:**

*   **State Definitions:**  `localparam` defines symbolic names for each state, making the code more readable and maintainable.
*   **State Register:**  `state` is a 2-bit register that holds the current state of the FSM.
*   **Internal Signals:** `byte1`, `byte2`, and `byte3` are optional registers to store the received bytes.  They are included for potential debugging or if you need to process the data further.  You can remove them if you only need to detect the message boundaries.
*   **State Transition Logic (always @(posedge clk)):** This `always` block describes the behavior of the FSM on each rising edge of the clock.
    *   **Reset:** If `reset` is asserted, the FSM goes to the `IDLE` state, and `done` is deasserted.
    *   **Case Statement:** The `case` statement handles the state transitions based on the current state.
        *   **IDLE:**  The FSM checks if `in[3]` is 1. If it is, the FSM transitions to `BYTE1`. Otherwise, it stays in `IDLE`. `done` is deasserted.
        *   **BYTE1:** The FSM transitions to `BYTE2`.  The first byte is optionally stored. `done` is deasserted.
        *   **BYTE2:** The FSM transitions to `BYTE3`. The second byte is optionally stored. `done` is deasserted.
        *   **BYTE3:** The FSM transitions to `IDLE`. The third byte is optionally stored. `done` is asserted for one clock cycle.
        *   **Default:**  The `default` case is included for safety, ensuring the FSM goes to the `IDLE` state if an unexpected state occurs.
*   **`done` Output:** The `done` signal is asserted for one clock cycle in the `BYTE3` state.

**4.  How to Use the Code (Integration with `top_module`)**

If you want to use this code directly with your `top_module`, simply replace the existing code within your `top_module` with the code above.  The input and output signals are already defined in your module header.  The internal signals and state definitions will be local to the module.

**5.  Verification and Testing**

To verify the functionality, you would need to write a testbench.  The testbench would:

1.  Generate a clock signal.
2.  Generate a reset signal.
3.  Generate a stream of input bytes (`in`).  This stream should include valid PS/2 mouse messages (3 bytes with the first byte having `in[3] == 1`) and also some invalid bytes to test the boundary detection.
4.  Monitor the `done` output.
5.  Check that `done` is asserted correctly for each valid message.

**6.  Conclusion**

This Verilog code implements the PS/2 mouse message boundary detection FSM as specified. It is designed to be efficient, reliable, and easy to understand.  The code is ready to be synthesized and implemented on an FPGA or ASIC.  I am confident that this solution meets your requirements.

I await your confirmation and instructions on how to receive the tip.  Thank you for the opportunity!
Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

