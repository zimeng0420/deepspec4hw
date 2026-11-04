module top_module (
    input clock,
    input a, 
    output reg p,
    output reg q
);

    reg [1:0] state; // To hold the current state of p and q

    always @(posedge clock) begin
        case(state)
            2'b00: begin // Initial state
                p <= 0;
                q <= 0;
                if (a) state <= 2'b01; // Transition to state 01 if a = 1
            end
            
            2'b01: begin
                p <= 0;
                q <= 0;
                if (a) state <= 2'b10; // Transition to state 10 if a = 1
            end
            
            2'b10: begin
                p <= 1;
                q <= 0;
                if (a) state <= 2'b11; // Transition to state 11 if a = 1
                else state <= 2'b00; // Transition back to state 00 if a = 0
            end
            
            2'b11: begin
                p <= 1;
                q <= 1;
                if (!a) state <= 2'b00; // Transition back to state 00 if a = 0
            end
            
            default: state <= 2'b00; // Default to the initial state
        endcase
    end

endmodule