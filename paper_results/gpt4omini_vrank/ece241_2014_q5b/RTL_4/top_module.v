module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State declaration
    parameter A = 2'b01, B = 2'b10;
    reg [1:0] state, next_state;

    // Asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) 
            state <= A;
        else 
            state <= next_state;
    end

    // Next state logic
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
                next_state = B; // remain in B
                z = x ? 0 : 1;
            end
            default: begin
                next_state = A;
                z = 0;
            end
        endcase
    end

endmodule