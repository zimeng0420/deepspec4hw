module top_module (
    input clock,
    input a, 
    output reg p,
    output reg q
);

    reg state, next_state;

    // State encoding
    localparam S0 = 1'b0;
    localparam S1 = 1'b1;

    // State transition
    always @(posedge clock) begin
        state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: begin
                if (a) begin
                    next_state = S1;
                end else begin
                    next_state = S0;
                end
            end
            S1: begin
                next_state = S1;
            end
            default: begin
                next_state = S0;
            end
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            S0: begin
                p = 0;
                q = 0;
            end
            S1: begin
                p = a;
                q = 1;
            end
            default: begin
                p = 0;
                q = 0;
            end
        endcase
    end

endmodule