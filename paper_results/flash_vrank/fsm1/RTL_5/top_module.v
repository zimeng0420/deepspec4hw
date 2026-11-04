module top_module (
    input clk,
    input in,
    input areset,
    output out
);

    reg state;
    parameter A = 0, B = 1;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= B; // Asynchronously reset to state B
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
                default: state <= B; //Should not happen, but good to have
            endcase
        end
    end

    assign out = state; // Output the current state (A=0, B=1)

endmodule