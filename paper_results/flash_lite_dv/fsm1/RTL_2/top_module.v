module top_module(
    input clk,
    input in,
    input areset,
    output out
);

    // State Definition
    parameter A = 0;
    parameter B = 1;

    // State Register
    reg state;

    // Output Logic (Combinational)
    assign out = state;

    // State Transition Logic (Sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B; // Asynchronous reset to state B
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