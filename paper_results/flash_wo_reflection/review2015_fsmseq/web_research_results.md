# Web Research Results

Total Results: 1

## Result 1

A synchronous reset in Verilog ensures that the reset action occurs in sync with the clock edge. This means the reset signal is only effective at the active edge of the clock.

Here's how to approach building a finite-state machine (FSM) for the sequence detector:

1.  **FSM Fundamentals**: An FSM consists of a state register, next-state logic, and output logic. The state register holds the current state, updating on clock edges. The next-state logic determines the subsequent state based on the current state and inputs. Output logic generates outputs based on the current state (Moore machine) or the current state and inputs (Mealy machine).

2.  **States**: Define states to represent the progress of sequence detection. For "1101", you might have states like:
    *   S0: Initial state, no part of the sequence found.
    *   S1: First "1" found.
    *   S2: "11" found.
    *   S3: "110" found.
    *   S4: "1101" found.

3.  **Synchronous Reset**: Implement the reset so that the FSM returns to the initial state (S0) on the next clock edge when the reset signal is active.

4.  **State Transitions**: Use a `case` statement within an `always` block triggered by the clock's positive edge (`posedge clk`) to define state transitions.

5.  **Output Logic**: When the FSM enters the final state (S4), set `start_shifting` to 1 and keep it at 1 until reset.

6.  **Implementation**:

    ```verilog
    module top_module(
        input clk,
        input reset,
        input data,
        output start_shifting);

    // Define states
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4;
    reg [2:0] state;

    // Output register
    reg start_shifting;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 0;
        end else begin
            case (state)
                S0: begin
                    if (data == 1) begin
                        state <= S1;
                    end
                end
                S1: begin
                    if (data == 1) begin
                        state <= S2;
                    end else begin
                        state <= S0;
                    end
                end
                S2: begin
                    if (data == 0) begin
                        state <= S3;
                    end else begin
                        state <= S1;
                    end
                end
                S3: begin
                    if (data == 1) begin
                        state <= S4;
                    end else begin
                        state <= S0;
                    end
                end
                S4: begin
                    state <= S4; // Stay in S4
                    start_shifting <= 1;
                end
                default: state <= S0;
            endcase
        end
    end

    assign start_shifting = (state == S4) ? 1 : start_shifting;

    endmodule
    ```

---

