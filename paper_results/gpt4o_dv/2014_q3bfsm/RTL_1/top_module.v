module top_module (
    input clk,
    input reset,
    input x,
    output reg z
);
    reg [2:0] y, y_next;

    // Define state constants for readability
    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100;
    
    // Next state logic
    always @(*) begin
        case (y)
            S0: y_next = (x == 1'b0) ? S0 : S1;
            S1: y_next = (x == 1'b0) ? S1 : S4;
            S2: y_next = (x == 1'b0) ? S2 : S1;
            S3: y_next = (x == 1'b0) ? S1 : S2;
            S4: y_next = (x == 1'b0) ? S3 : S4;
            default: y_next = S0;
        endcase
    end

    // State register logic with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            y <= S0;
        end else begin
            y <= y_next;
        end
    end

    // Output logic
    always @(*) begin
        case (y)
            S3: z = 1'b1;
            S4: z = 1'b1;
            default: z = 1'b0;
        endcase
    end

endmodule