module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);
    reg [1:0] state, next_state;

    localparam S0 = 2'b00;  // Waiting for first '1'
    localparam S1 = 2'b01;  // Inverting bits

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
            z <= 1; // Reset output to a known state
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            S0: begin
                if (x == 1) begin
                    z = 0; // First '1' encountered, output remains 0
                    next_state = S1; // Transition to state S1
                end else begin
                    z = 1; // Output z is 1 for "0"
                    next_state = S0; // Remain in state S0
                end
            end
            S1: begin
                z = ~x; // Output is the inverted value of x
                next_state = S1; // Remain in state S1
            end
            default: begin
                z = 1; // Default output
                next_state = S0; // Default state
            end
        endcase
    end
endmodule