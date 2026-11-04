module top_module (
    input clock,
    input a, 
    output reg p,
    output reg q
);

    reg [1:0] state, next_state;

    // State encoding
    localparam S0 = 2'b00; // p=0, q=0
    localparam S1 = 2'b01; // p=1, q=0
    localparam S2 = 2'b10; // p=1, q=1

    // State transition
    always @ (posedge clock) begin
        state <= next_state;
    end

    // Next state logic
    always @ (*) begin
        case (state)
            S0: begin
                p = 0;
                q = 0;
                if (a) next_state = S1;
                else next_state = S0;
            end
            S1: begin
                p = 1;
                q = 0;
                if (a) next_state = S1;
                else next_state = S2;
            end
            S2: begin
                p = 1;
                q = 1;
                if (a) next_state = S1;
                else next_state = S2;
            end
            default: begin
                p = 0;
                q = 0;
                next_state = S0;
            end
        endcase
    end

endmodule