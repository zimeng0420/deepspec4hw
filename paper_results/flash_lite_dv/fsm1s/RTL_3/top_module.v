module top_module(
    input clk,
    input in,
    input reset,
    output reg out
);

    // State definition
    parameter A = 1'b0;
    parameter B = 1'b1;

    // State register
    reg state;
    reg next_state;

    // State transition logic
    always @(*) begin
        case (1'b1) // Always execute
            reset:      next_state = B;
            default: begin
                case (state)
                    A:  next_state = (in) ? A : B;
                    B:  next_state = (in) ? B : A;
                    default: next_state = B; // Default to B for safety
                endcase
            end
        endcase
    end


    // State register update
    always @(posedge clk) begin
        state <= next_state;
    end


    // Output logic
    always @(*) begin
        out = (state == B) ? 1'b1 : 1'b0;
    end

endmodule