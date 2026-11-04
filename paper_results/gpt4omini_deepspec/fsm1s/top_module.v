module top_module (
    input clk,
    input in,
    input reset,
    output out
);
    reg state;
    parameter A = 1'b0, B = 1'b1;

    always @(posedge clk) begin
        if (reset) begin
            state <= B; // Reset state is B
        end else begin
            case (state)
                A: begin
                    if (in)
                        state <= A; // Stay in A
                    else
                        state <= B; // Transition to B
                end
                B: begin
                    if (in)
                        state <= B; // Stay in B
                    else
                        state <= A; // Transition to A
                end
            endcase
        end
    end

    assign out = (state == B) ? 1'b1 : 1'b0; // Output is 1 when in state B, otherwise 0
endmodule