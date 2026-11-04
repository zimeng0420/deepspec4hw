module top_module(
    input clk,
    input in,
    input areset,
    output out
);

    // State definition
    parameter A = 0;
    parameter B = 1;

    // State register
    reg state;

    // Output logic
    assign out = state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;  // Asynchronous reset to state B
        end else begin
            case (state)
                A: begin
                    if (in)
                        state <= A;
                    else
                        state <= B;
                end
                B: begin
                    if (in)
                        state <= B;
                    else
                        state <= A;
                end
            endcase
        end
    end

endmodule