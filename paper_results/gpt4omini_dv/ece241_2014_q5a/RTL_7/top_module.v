module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg [1:0] state;
    parameter S0 = 2'b00, S1 = 2'b01;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            case (state)
                S0: begin
                    if (x == 1'b0) begin
                        z <= 1'b1;
                    end else begin
                        z <= 1'b1; // Maintain z when first '1' is encountered
                        state <= S1;
                    end
                end
                S1: begin
                    z <= ~x; // Output the inverted value of x
                end
            endcase
        end
    end

endmodule