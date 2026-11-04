module top_module (
	input clk,
	input in,
	input reset,
	output out
);

    // Define state variables
    parameter A = 2'b00; // State A
    parameter B = 2'b01; // State B
    reg [1:0] state; // Current state (2 bits are enough to represent 2 states)

    // Output assignment (Moore machine)
    always @(*) begin
        case (state)
            A: out = 1'b0;
            B: out = 1'b1;
            default: out = 1'b0; // Default to A for safety
        endcase
    end

    // State transition logic (synchronous)
    always @(posedge clk) begin
        if (reset) begin
            state <= B; // Reset to state B
        end else begin
            case (state)
                B: begin
                    if (in)
                        state <= B;
                    else
                        state <= A;
                end
                A: begin
                    if (in)
                        state <= A;
                    else
                        state <= B;
                end
                default: state <= B; // Default to B for safety
            endcase
        end
    end

endmodule