module top_module (
    input clk,
    input areset,
    input x,
    output z
);

    reg [1:0] state; // One-hot encoding for states A and B
    parameter A = 2'b01, B = 2'b10; // State definitions

    // Asynchronous reset and state transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A; // Reset to state A
        end else begin
            case (state)
                A: begin
                    if (x) state <= B; // Transition to B on x=1
                    else state <= A;   // Remain in A on x=0
                end
                B: begin
                    state <= B; // Remain in B regardless of x
                end
            endcase
        end
    end

    // Output logic based on current state and input x
    assign z = (state == A && x) ? 1 : 
               (state == A && ~x) ? 0 : 
               (state == B && x) ? 0 : 
               (state == B && ~x) ? 1 : 0;

endmodule