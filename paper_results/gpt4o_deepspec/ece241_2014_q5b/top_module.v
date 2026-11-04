module top_module (
	input clk,
	input areset,
	input x,
	output reg z
);

    // State encoding using one-hot
    parameter A = 2'b01, 
              B = 2'b10;

    reg [1:0] state, next_state;

    // Asynchronous reset and state transition logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A; // Reset to state A
        else
            state <= next_state; // Transition to next state
    end

    // Combinational logic for next state and output
    always @(*) begin
        case (state)
            A: begin
                if (x) begin
                    next_state = B; // Transition from A to B on x=1
                    z = 1;          // Output z=1
                end
                else begin
                    next_state = A; // Remain in A on x=0
                    z = 0;          // Output z=0
                end
            end
            B: begin
                next_state = B;     // Remain in B
                if (x)
                    z = 0;          // Output z=0
                else
                    z = 1;          // Output z=1
            end
            default: begin
                next_state = A;     // Default to A
                z = 0;              // Default output
            end
        endcase
    end

endmodule