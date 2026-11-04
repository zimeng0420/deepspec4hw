module top_module(
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] y;

    // State definitions (optional, for readability)
    localparam S0 = 3'b000;
    localparam S1 = 3'b001;
    localparam S2 = 3'b010;
    localparam S3 = 3'b011;
    localparam S4 = 3'b100;

    // Next state logic
    always @(*) begin
        case (y)
            S0: y = (x) ? S1 : S0;
            S1: y = (x) ? S4 : S1;
            S2: y = (x) ? S1 : S2;
            S3: y = (x) ? S2 : S1;
            S4: y = (x) ? S4 : S3;
            default: y = S0; // Default to reset state
        endcase
    end

    // Output logic (Moore machine)
    always @(*) begin
        case (y)
            S0: z = 1'b0;
            S1: z = 1'b0;
            S2: z = 1'b0;
            S3: z = 1'b1;
            S4: z = 1'b1;
            default: z = 1'b0; // Default output
        endcase
    end

    // State register update and reset
    always @(posedge clk) begin
        if (reset) begin
            y <= S0;
        end else begin
            y <= y; // update
        end
    end

endmodule