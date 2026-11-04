module top_module (
	input clk,
	input aresetn,
	input x,
	output reg z
);

    parameter S0 = 2'd0;
    parameter S1 = 2'd1;
    parameter S2 = 2'd2;

    reg [1:0] state, next_state;

    // State transition logic
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state and output logic
    always @(*) begin
        next_state = state;
        z = 1'b0; // Default output

        case (state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (x)
                    next_state = S1; // Overlapping: stay in S1 if x=1
                else
                    next_state = S2;
            end
            S2: begin
                if (x) {
                    next_state = S1; // Overlapping: "101" detected, next input is '1', go to S1 (expecting '0')
                    z = 1'b1;
                }
                else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

endmodule