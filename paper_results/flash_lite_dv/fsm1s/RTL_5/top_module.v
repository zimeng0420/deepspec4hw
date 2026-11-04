module top_module(
    input clk,
    input in,
    input reset,
    output out
);

    // State Encoding
    parameter A = 1'b0;
    parameter B = 1'b1;

    // State Register
    reg state;

    // Output Register (to hold the output)
    reg out_reg;
    
    // Next State Logic
    always @(posedge clk) begin
        if (reset) begin
            state <= B; // Reset to state B
        end else begin
            case (state)
                A: begin
                    if (in) begin
                        state <= A;
                    end else begin
                        state <= B;
                    end
                end
                B: begin
                    if (in) begin
                        state <= B;
                    end else begin
                        state <= A;
                    end
                end
                default: state <= B; // Handle unexpected states
            endcase
        end
    end

    // Output Logic
    always @(*) begin
        case (state)
            A: out_reg = 1'b0;
            B: out_reg = 1'b1;
            default: out_reg = 1'b1; // Default output in case of unexpected state
        endcase
    end

    assign out = out_reg;

endmodule