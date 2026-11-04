module top_module (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] state, next_state;

    // State encoding
    localparam S_000 = 3'b000;
    localparam S_001 = 3'b001;
    localparam S_010 = 3'b010;
    localparam S_011 = 3'b011;
    localparam S_100 = 3'b100;

    // State transition logic
    always @(*) begin
        case (state)
            S_000: next_state = x ? S_001 : S_000;
            S_001: next_state = x ? S_100 : S_001;
            S_010: next_state = x ? S_001 : S_010;
            S_011: next_state = x ? S_010 : S_001;
            S_100: next_state = x ? S_100 : S_011;
            default: next_state = S_000; // Default case for safety
        endcase
    end

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S_000;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    always @(*) begin
        case (state)
            S_000: z = 0;
            S_001: z = 0;
            S_010: z = 0;
            S_011: z = 1;
            S_100: z = 1;
            default: z = 0; // Default case for safety
        endcase
    end

endmodule