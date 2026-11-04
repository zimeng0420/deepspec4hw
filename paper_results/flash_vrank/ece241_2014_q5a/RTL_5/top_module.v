module top_module (
    input clk,
    input areset,
    input x,
    output z
);

    reg z;
    reg state;

    // Define states
    parameter A = 1'b0; // Initial state, also pass through until first '1'
    parameter B = 1'b1; // Invert after first '1'

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            z <= 0;
        end else begin
            case (state)
                A: begin
                    if (x == 1'b1) begin
                        state <= B;
                        z <= 1'b1;
                    end else begin
                        state <= A;
                        z <= 1'b0;
                    end
                end
                B: begin
                    state <= B;
                    z <= ~x;
                end
                default: begin
                    state <= A;
                    z <= 0;
                end
            endcase
        end
    end

endmodule