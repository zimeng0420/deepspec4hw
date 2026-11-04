module top_module (
    input clk,
    input in,
    input areset,
    output out
);

    reg state;

    // Define the states
    parameter A = 0;
    parameter B = 1;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;  // Asynchronously reset to state B
        end else begin
            case (state)
                A: begin
                    if (in) begin
                        state <= A;
                    end else begin
                        state <= B;
                    end
                end
                B: begin
                    if (in) begin
                        state <= B;
                    end else begin
                        state <= A;
                    end
                end
                default: state <= B; // Default state in case of corruption
            endcase
        end
    end

    assign out = state; // Output the current state

endmodule