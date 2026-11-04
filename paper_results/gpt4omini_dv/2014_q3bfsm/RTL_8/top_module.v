module top_module (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] y; // Current state

    always @(posedge clk) begin
        if (reset) begin
            y <= 3'b000; // Reset state to 000
        end else begin
            case (y)
                3'b000: y <= (x) ? 3'b001 : 3'b000;
                3'b001: y <= (x) ? 3'b100 : 3'b001;
                3'b010: y <= (x) ? 3'b001 : 3'b010;
                3'b011: y <= (x) ? 3'b010 : 3'b001;
                3'b100: y <= (x) ? 3'b100 : 3'b011;
                default: y <= 3'b000; // Default to reset state
            endcase
        end
    end

    always @(*) begin
        case (y)
            3'b011: z = 1; // Output z = 1 for state 011
            3'b100: z = 1; // Output z = 1 for state 100
            default: z = 0; // Output z = 0 for all other states
        endcase
    end

endmodule