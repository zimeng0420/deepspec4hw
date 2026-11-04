module top_module (
    input clk,
    input x,
    input [2:0] y,
    output reg Y0,
    output reg z
);

    always @(posedge clk) begin
        // Default assignments
        z = 0;
        
        // Determine output z based on current state
        case (y)
            3'b011: z = 1;
            3'b100: z = 1;
            default: z = 0;
        endcase

        // Calculate the next state bit Y[0]
        case (y)
            3'b000: Y0 = x ? 1'b1 : 1'b0;
            3'b001: Y0 = x ? 1'b0 : 1'b1;
            3'b010: Y0 = x ? 1'b0 : 1'b0;
            3'b011: Y0 = x ? 1'b0 : 1'b1;
            3'b100: Y0 = x ? 1'b0 : 1'b1;
            default: Y0 = 1'b0;
        endcase
    end

endmodule