module top_module (
    input clock,
    input a, 
    output reg p,
    output reg q
);

    // State registers
    reg state, next_state;

    // State encoding
    localparam S0 = 1'b0, S1 = 1'b1;

    // State transition
    always @(posedge clock) begin
        state <= next_state;
    end

    // Next state logic and output logic
    always @(*) begin
        case (state)
            S0: begin
                if (a) begin
                    next_state = S1;
                    p = 1'b1;
                    q = 1'b0;
                end else begin
                    next_state = S0;
                    p = 1'b0;
                    q = 1'b0;
                end
            end
            S1: begin
                next_state = S0;
                p = 1'b0;
                q = 1'b1;
            end
        endcase
    end

endmodule