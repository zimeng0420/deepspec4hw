module top_module (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] y, y_next;

    // State encoding
    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100;

    // State transition logic
    always @(*) begin
        case (y)
            S0: y_next = (x == 0) ? S0 : S1;
            S1: y_next = (x == 0) ? S1 : S4;
            S2: y_next = (x == 0) ? S2 : S1;
            S3: y_next = (x == 0) ? S1 : S2;
            S4: y_next = (x == 0) ? S3 : S4;
            default: y_next = S0;  // Default case to handle unexpected states
        endcase
    end

    // Output logic
    always @(*) begin
        case (y)
            S3: z = 1;
            S4: z = 1;
            default: z = 0;
        endcase
    end

    // State register logic
    always @(posedge clk) begin
        if (reset)
            y <= S0;  // Synchronous reset to state 000
        else
            y <= y_next;
    end

endmodule