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

    // Synchronous state transition
    always @(posedge clk) begin
        if (reset) 
            y <= S0; // Reset to state 000
        else 
            y <= y_next;
    end

    // Combinational next state logic
    always @(*) begin
        case (y)
            S0: y_next = x ? S1 : S0;
            S1: y_next = x ? S4 : S1;
            S2: y_next = x ? S1 : S2;
            S3: y_next = x ? S2 : S1;
            S4: y_next = x ? S4 : S3;
            default: y_next = S0;
        endcase
    end

    // Combinational output logic (Moore)
    always @(*) begin
        case (y)
            S3, S4: z = 1'b1;
            default: z = 1'b0;
        endcase
    end

endmodule