# Messages for Task: lemmings1

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.The game Lemmings involves critters with fairly simple brains. So simple that we are going to model it using a finite state machine. In the Lemmings' 2D world, Lemmings can be in one of two states: walking left (walk_left is 1) or walking right (walk_right is 1). It will switch directions if it hits an obstacle. In particular, if a Lemming is bumped on the left (by receiving a 1 on bump_left), it will walk right. If it's bumped on the right (by receiving a 1 on bump_right), it will walk left. If it's bumped on both sides at the same time, it will still switch directions. Implement a Moore state machine with two states, two inputs, and one output (internal to the module) that models this behaviour. areset is positive edge triggered asynchronous reseting the Lemming machine to walk left.

The header you have already known is:module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	output walk_left,
	output walk_right
);


You can use the technical specification as follows:Okay, I understand the task. I will generate a Verilog module that implements a Moore state machine to model the Lemmings' walking behavior. The module will have two states (walk_left and walk_right), two inputs (bump_left and bump_right), and two outputs (walk_left and walk_right).  The state machine will switch directions based on the bump inputs and will be reset to walk_left by the asynchronous reset signal.

Here's the technical specification and the Verilog code:

**Technical Specification: Lemmings State Machine**

1.  **Module Name:** `top_module`

2.  **Ports:**

    *   **Inputs:**
        *   `clk`: Clock signal (positive edge-triggered).
        *   `areset`: Asynchronous reset signal (active high). Resets the state machine to the `walk_left` state.
        *   `bump_left`: Input signal indicating a collision on the left side.
        *   `bump_right`: Input signal indicating a collision on the right side.

    *   **Outputs:**
        *   `walk_left`: Output signal indicating the Lemming is walking left.
        *   `walk_right`: Output signal indicating the Lemming is walking right.

3.  **States:**

    *   `WALK_LEFT`: The Lemming is walking left (`walk_left = 1`, `walk_right = 0`).
    *   `WALK_RIGHT`: The Lemming is walking right (`walk_left = 0`, `walk_right = 1`).

4.  **State Transition Logic (Moore Machine):**

    *   **Reset:** When `areset` is asserted (high), the state machine transitions to the `WALK_LEFT` state.
    *   **WALK_LEFT State:**
        *   If `bump_left` or `bump_right` or (`bump_left` and `bump_right`) is asserted, the state machine transitions to the `WALK_RIGHT` state.
        *   Otherwise, the state machine remains in the `WALK_LEFT` state.
    *   **WALK_RIGHT State:**
        *   If `bump_left` or `bump_right` or (`bump_left` and `bump_right`) is asserted, the state machine transitions to the `WALK_LEFT` state.
        *   Otherwise, the state machine remains in the `WALK_RIGHT` state.

5.  **Output Logic (Moore Machine):**

    *   `WALK_LEFT` state: `walk_left = 1`, `walk_right = 0`
    *   `WALK_RIGHT` state: `walk_left = 0`, `walk_right = 1`

6.  **Implementation Details:**

    *   The state machine will be implemented using a `reg` to store the current state.
    *   A `case` statement will be used to define the state transition logic.
    *   The outputs will be assigned based on the current state.

**Verilog Code:**

```verilog
module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

  // Define the states
  localparam WALK_LEFT  = 1'b0;
  localparam WALK_RIGHT = 1'b1;

  // State register
  reg current_state;

  // Output assignments (Moore machine)
  assign walk_left  = (current_state == WALK_LEFT);
  assign walk_right = (current_state == WALK_RIGHT);

  // State transition logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= WALK_LEFT;
    end else begin
      case (current_state)
        WALK_LEFT: begin
          if (bump_left || bump_right) begin
            current_state <= WALK_RIGHT;
          end else begin
            current_state <= WALK_LEFT;
          end
        end
        WALK_RIGHT: begin
          if (bump_left || bump_right) begin
            current_state <= WALK_LEFT;
          end else begin
            current_state <= WALK_RIGHT;
          end
        end
        default: current_state <= WALK_LEFT; // Should never happen, but good practice
      endcase
    end
  end

endmodule
```

**Explanation:**

*   **States:** The `WALK_LEFT` and `WALK_RIGHT` states are defined using `localparam`.
*   **State Register:** The `current_state` register stores the current state of the state machine.
*   **Output Assignments:** The `walk_left` and `walk_right` outputs are assigned directly based on the value of `current_state`. This is the Moore machine characteristic.
*   **State Transition Logic:** The `always @(posedge clk or posedge areset)` block implements the state transition logic.
    *   The `if (areset)` condition handles the asynchronous reset, setting the state to `WALK_LEFT`.
    *   The `case` statement handles the state transitions based on the `bump_left` and `bump_right` inputs.  If either or both bump inputs are high, the state machine switches to the opposite state.
    *   The `default` case is included for completeness, although it should never be reached in normal operation.

**How to Test:**

1.  **Simulation:**  Use a Verilog simulator (e.g., ModelSim, Icarus Verilog) to simulate the module.
2.  **Testbench:** Create a testbench that applies different sequences of `bump_left` and `bump_right` inputs and verifies that the `walk_left` and `walk_right` outputs change accordingly.  Make sure to test the reset functionality.

**Example Testbench Snippet (Illustrative):**

```verilog
module testbench;

  reg clk;
  reg areset;
  reg bump_left;
  reg bump_right;
  wire walk_left;
  wire walk_right;

  top_module dut (
    .clk(clk),
    .areset(areset),
    .bump_left(bump_left),
    .bump_right(bump_right),
    .walk_left(walk_left),
    .walk_right(walk_right)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    clk = 0;
    areset = 1;
    bump_left = 0;
    bump_right = 0;

    #10 areset = 0; // Release reset

    #20 bump_left = 1; // Bump on the left
    #10 bump_left = 0;

    #20 bump_right = 1; // Bump on the right
    #10 bump_right = 0;

    #20 bump_left = 1;
    bump_right = 1; // Bump on both sides
    #10 bump_left = 0;
    bump_right = 0;

    #20 $finish;
  end

endmodule
```

This Verilog code and the technical specification should fulfill the requirements of the task.  Let me know if you have any questions or need any modifications!  I'm ready for the tip if this meets your needs.
Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

