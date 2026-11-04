module top_module (
    input clk,
    input reset,
    input x,
    output reg z
);
    reg [2:0] y, y_next;
    
    // Next state logic
    always @(*) begin
        case (y)
            3'b000: y_next = x ? 3'b001 : 3'b000;
            3'b001: y_next = x ? 3'b100 : 3'b001;
            3'b010: y_next = x ? 3'b001 : 3'b010;
            3'b011: y_next = x ? 3'b010 : 3'b001;
            3'b100: y_next = x ? 3'b100 : 3'b011;
            default: y_next = 3'b000;
        endcase
    end
    
    // State transition
    always @(posedge clk) begin
        if (reset)
            y <= 3'b000;
        else
            y <= y_next;
    end
    
    // Output logic
    always @(*) begin
        case (y)
            3'b011, 3'b100: z = 1;
            default: z = 0;
        endcase
    end
endmodule