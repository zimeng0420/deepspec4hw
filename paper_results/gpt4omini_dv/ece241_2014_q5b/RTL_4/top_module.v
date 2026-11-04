module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg state_A, state_B;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end else begin
            case ({state_A, state_B})
                2'b10: begin // State A
                    if (x) begin
                        state_A <= 1'b0;
                        state_B <= 1'b1;
                    end
                end
                2'b01: begin // State B
                    if (x) begin
                        state_A <= 1'b0;
                        state_B <= 1'b1;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        z = (state_A & ~x) | (state_B & x);
    end

endmodule