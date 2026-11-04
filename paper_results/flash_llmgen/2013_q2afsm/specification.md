Okay, I understand the task. I will generate a complete Verilog code for the described FSM, adhering to the specified requirements: separate `always` blocks for the state table and state flip-flops, active-low synchronous reset, priority-based arbitration, and the provided module header. I will also choose appropriate state encodings.

Here's the technical specification and the Verilog code:

**Technical Specification**

*   **Functionality:** This module implements a priority-based arbiter for three requesting devices. The arbiter grants access to a shared resource based on the following priority: Device 1 > Device 2 > Device 3.
*   **Inputs:**
    *   `clk`: Clock signal.
    *   `resetn`: Active-low synchronous reset.
    *   `r[3:1]`: Request signals from the three devices. `r[i] = 1` indicates a request from device `i`.
*   **Outputs:**
    *   `g[3:1]`: Grant signals to the three devices. `g[i] = 1` indicates that device `i` has been granted access to the resource.
*   **States:**
    *   `A`: Idle state. No grant is active.
    *   `B`: Device 1 is granted access (`g[1] = 1`).
    *   `C`: Device 2 is granted access (`g[2] = 1`).
    *   `D`: Device 3 is granted access (`g[3] = 1`).
*   **State Transitions:**
    *   **A:**
        *   If `r[1] = 1`: Transition to state `B`.
        *   If `r[1] = 0` and `r[2] = 1`: Transition to state `C`.
        *   If `r[1] = 0` and `r[2] = 0` and `r[3] = 1`: Transition to state `D`.
        *   Otherwise (no requests or multiple requests with higher priority): Stay in state `A`.
    *   **B:**
        *   If `r[1] = 1`: Stay in state `B`.
        *   If `r[1] = 0`: Transition to state `A`.
    *   **C:**
        *   If `r[2] = 1`: Stay in state `C`.
        *   If `r[2] = 0`: Transition to state `A`.
    *   **D:**
        *   If `r[3] = 1`: Stay in state `D`.
        *   If `r[3] = 0`: Transition to state `A`.
*   **Reset:** When `resetn = 0`, the FSM synchronously resets to state `A`.
*   **State Encoding:**
    *   `A = 2'b00`
    *   `B = 2'b01`
    *   `C = 2'b10`
    *   `D = 2'b11`
*   **Output Logic:** The grant signals `g[i]` are asserted based on the current state.

**Verilog Code**

```verilog
module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output [3:1] g
);

  // State definition
  localparam A = 2'b00;
  localparam B = 2'b01;
  localparam C = 2'b10;
  localparam D = 2'b11;

  // State variable
  reg [1:0] current_state, next_state;

  // State flip-flops (Sequential Logic)
  always @(posedge clk) begin
    if (!resetn) begin
      current_state <= A;
    end else begin
      current_state <= next_state;
    end
  end

  // State transition logic (Combinational Logic)
  always @(*) begin
    case (current_state)
      A: begin
        if (r[1]) begin
          next_state = B;
        end else if (r[2]) begin
          next_state = C;
        end else if (r[3]) begin
          next_state = D;
        end else begin
          next_state = A;
        end
      end
      B: begin
        if (r[1]) begin
          next_state = B;
        end else begin
          next_state = A;
        end
      end
      C: begin
        if (r[2]) begin
          next_state = C;
        end else begin
          next_state = A;
        end
      end
      D: begin
        if (r[3]) begin
          next_state = D;
        end else begin
          next_state = A;
        end
      end
      default: next_state = A; // Should not happen, but good practice
    endcase
  end

  // Output logic (Combinational Logic)
  always @(*) begin
    case (current_state)
      A: begin
        g[1] = 0;
        g[2] = 0;
        g[3] = 0;
      end
      B: begin
        g[1] = 1;
        g[2] = 0;
        g[3] = 0;
      end
      C: begin
        g[1] = 0;
        g[2] = 1;
        g[3] = 0;
      end
      D: begin
        g[1] = 0;
        g[2] = 0;
        g[3] = 1;
      end
      default: begin
        g[1] = 0;
        g[2] = 0;
        g[3] = 0;
      end
    endcase
  end

endmodule
```

**Explanation:**

1.  **Module Declaration:** The code starts with the module declaration, including the input and output signals as specified.
2.  **State Definition:**  `localparam` is used to define the state encodings for clarity and maintainability.
3.  **State Variable:** `current_state` and `next_state` are declared as registers to store the current and next states of the FSM.
4.  **State Flip-Flops:** This `always` block implements the sequential logic. It updates the `current_state` with the `next_state` on the rising edge of the clock, unless the reset signal is asserted (low), in which case it resets to state `A`.
5.  **State Transition Logic:** This `always` block implements the combinational logic that determines the `next_state` based on the `current_state` and the input signals `r[3:1]`.  It uses a `case` statement to define the state transitions according to the state diagram and priority rules.
6.  **Output Logic:** This `always` block implements the combinational logic that determines the output signals `g[3:1]` based on the `current_state`.  It uses a `case` statement to assign the appropriate grant signals for each state.
7.  **Default Cases:**  The `default` cases in the `case` statements are included for robustness.  While they should ideally never be reached, they provide a safe fallback in case of unexpected state values.

This code fulfills all the requirements of the task. It's well-structured, easy to understand, and implements the specified FSM behavior correctly.  The separate `always` blocks for state transitions and state flip-flops make the code more readable and easier to debug. The output logic is also clearly defined.