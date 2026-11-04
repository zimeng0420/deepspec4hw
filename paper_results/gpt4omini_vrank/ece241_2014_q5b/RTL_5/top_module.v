module top_module (
    input clk,
    input areset,
    input x,
    output z
);
    // State declaration
    reg [1:0] state;
    parameter A = 2'b01, B = 2'b10;

    // Output logic
    assign z = (state == A && x == 1) || (state == B && x == 0) ? 1 : 0;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A; // Reset to state A
        end else begin
            case (state)
                A: begin
                    if (x) state <= B; // Transition to B on x=1
                end
                B: begin
                    state <= B; // Stay in B on both x=0 and x=1
                end
            endcase
        end
    end
endmodule