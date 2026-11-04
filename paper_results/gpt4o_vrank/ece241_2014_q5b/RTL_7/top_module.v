module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // Define state encoding using one-hot
    reg [1:0] state, next_state;
    localparam A = 2'b01, B = 2'b10;

    // Asynchronous reset logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;  // Upon reset, go to state A
        else
            state <= next_state;
    end

    // State transition and output logic
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
                if (x) begin
                    next_state = B;
                    z = 0;
                end else begin
                    next_state = B;
                    z = 1;
                end
            end
            default: begin
                next_state = A; // Default to state A
                z = 0;
            end
        endcase
    end

endmodule