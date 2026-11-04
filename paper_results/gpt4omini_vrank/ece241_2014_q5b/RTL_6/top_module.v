module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg [1:0] state;

    localparam A = 2'b01, // State A
               B = 2'b10; // State B

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A; // Reset to State A
            z <= 0;     // Output z is reset to 0
        end else begin
            case (state)
                A: begin
                    if (x) begin
                        state <= B; // Transition to State B
                        z <= 1;     // Output z = 1
                    end else begin
                        state <= A; // Stay in State A
                        z <= 0;     // Output z = 0
                    end
                end
                
                B: begin
                    if (x) begin
                        state <= B; // Stay in State B
                        z <= 0;     // Output z = 0
                    end else begin
                        state <= B; // Stay in State B
                        z <= 1;     // Output z = 1
                    end
                end
                
                default: begin
                    state <= A; // Default case to ensure defined state
                    z <= 0;     // Default output z
                end
            endcase
        end
    end

endmodule