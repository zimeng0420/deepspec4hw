module top_module (
	input clk,
	input aresetn,
	input x,
	output reg z
);

    parameter S0 = 0; // Initial state, expecting 1
    parameter S1 = 1; // After receiving 1, expecting 0
    parameter S2 = 2; // After receiving 10, expecting 1

    reg [1:0] state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            case (state)
                S0: begin
                    if (x)
                        state <= S1;
                    else
                        state <= S0;
                    z <= 1'b0;
                end
                S1: begin
                    if (x)
                        state <= S2;
                    else
                        state <= S0;
                    z <= 1'b0;
                end
                S2: begin
                    if (x)
                        state <= S1;
                    else
                        state <= S0;
                    z <= 1'b1;
                end
            endcase
        end
    end
endmodule