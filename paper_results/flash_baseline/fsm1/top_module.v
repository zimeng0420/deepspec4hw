module top_module (
    input clk,
    input in,
    input areset,
    output out
);

    reg state;
    parameter A = 0, B = 1;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            case (state)
                A: begin
                    if (in == 0) begin
                        state <= B;
                    end else begin
                        state <= A;
                    end
                end
                B: begin
                    if (in == 0) begin
                        state <= A;
                    end else begin
                        state <= B;
                    end
                end
                default: state <= B; // Should not happen, but good practice
            endcase
        end
    end

    assign out = state; // Output is the current state

endmodule