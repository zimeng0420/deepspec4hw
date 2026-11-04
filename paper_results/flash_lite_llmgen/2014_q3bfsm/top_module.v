module top_module (
    input clk,
    input reset,
    input x,
    output reg z
);

    // Define the state encoding using parameters for readability and maintainability.
    parameter S000 = 3'b000;
    parameter S001 = 3'b001;
    parameter S010 = 3'b010;
    parameter S011 = 3'b011;
    parameter S100 = 3'b100;

    // Declare the present state and next state registers.
    reg [2:0] present_state, next_state;

    // 1. State Transition Logic (Combinational Logic)
    always @(*) begin
        // Default next state is the current state.  This is important for handling
        // cases where the input 'x' might not change the state.
        next_state = present_state;
        z = 0; // Default output

        case (present_state)
            S000: begin
                next_state = (x == 1) ? S001 : S000; // If x=1, go to S001, else stay in S000
                z = 0;
            end
            S001: begin
                next_state = (x == 1) ? S100 : S001; // If x=1, go to S100, else stay in S001
                z = 0;
            end
            S010: begin
                next_state = (x == 1) ? S001 : S010; // If x=1, go to S001, else stay in S010
                z = 0;
            end
            S011: begin
                next_state = (x == 1) ? S010 : S001; // If x=1, go to S010, else go to S001
                z = 1;
            end
            S100: begin
                next_state = (x == 1) ? S100 : S011; // If x=1, stay in S100, else go to S011
                z = 1;
            end
            default: begin // Handle any unexpected states (important for robustness)
                next_state = S000; // Go to a known state
                z = 0;
            end
        endcase
    end

    // 2. State Register (Sequential Logic)
    always @(posedge clk) begin
        if (reset) begin
            present_state <= S000; // Synchronous reset to state S000
        end else begin
            present_state <= next_state; // Update state on clock edge
        end
    end

endmodule