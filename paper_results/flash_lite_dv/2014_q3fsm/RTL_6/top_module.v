module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State Definition
    parameter A = 0;
    parameter B = 1;

    // State Register
    reg [1:0] state;

    // Internal Signals
    reg [1:0] w_count; // Counter for w=1 in state B
    reg [2:0] w_history; // Shift register to store the last 3 w values
    reg [1:0] cycle_count; // Counter to track the three cycles in state B

    // State Transition Logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
            w_count <= 0;
            w_history <= 0;
            cycle_count <= 0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        cycle_count <= 0;
                    end
                    z <= 0; // Ensure z is 0 in state A
                end
                B: begin
                    // Shift w into history
                    w_history <= {w_history[1:0], w};

                    // Count the number of times w=1 in the last 3 cycles
                    if (cycle_count < 2) begin
                         if (w == 1)
                            w_count <= w_count + 1;
                    end
                    else begin
                         if (w == 1)
                            w_count <= w_count + 1;
                    end


                    if (cycle_count == 2) begin
                      if (w_count == 2)
                        z <= 1;
                      else
                        z <= 0;
                         w_count <= 0;
                    end
                    else
                        z <= 0;

                    if (cycle_count == 2) begin
                        cycle_count <= 0;
                    end
                    else
                        cycle_count <= cycle_count + 1;
                end
            endcase
        end
    end
endmodule