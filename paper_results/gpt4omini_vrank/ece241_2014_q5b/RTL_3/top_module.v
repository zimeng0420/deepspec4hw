module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding
    parameter A = 2'b01, B = 2'b10;
    reg [1:0] state, next_state;

    // Asynchronous reset
    always @(areset) begin
        if (areset) begin
            state <= A;
            z <= 0;
        end
    end

    // State register
    always @(posedge clk) begin
        if (!areset) begin
            state <= next_state;
        end
    end

    // Next-state logic
    always @(*) begin
        case (state)
            A: begin
                if (x) begin
                    next_state = B;
                    z = 1;
                end else begin
                    next_state = A;
                    z = 0;
                end
            end
            B: begin
                next_state = B;
                z = x ? 0 : 1;
            end
            default: begin
                next_state = A; // Default case for safety
                z = 0;
            end
        endcase
    end

endmodule