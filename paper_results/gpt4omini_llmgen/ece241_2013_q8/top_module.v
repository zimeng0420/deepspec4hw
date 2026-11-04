module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);
    // State encoding
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;
    reg [1:0] state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            // Asynchronous reset
            z <= 0;
            state <= S0;
        end else begin
            case(state)
                S0: begin
                    if (x) begin
                        state <= S1;
                    end
                end
                
                S1: begin
                    if (x) begin
                        state <= S1; // Stay in S1
                    end else begin
                        state <= S2;
                    end
                end
                
                S2: begin
                    if (x) begin
                        z <= 1; // Output 1 on detecting "101"
                        state <= S1;
                    end else begin
                        state <= S0;
                    end
                end
            endcase
        end
    end

    // Reset output
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            z <= 0;
        end else if (state == S2 && x) begin
            z <= 1; // Assert z when "101" is detected
        end else begin
            z <= 0; // Reset output when not in detecting state
        end
    end
endmodule