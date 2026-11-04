module top_module (
    input clk,
    input x,
    input [2:0] y,
    output reg Y0,
    output reg z
);

    // Define internal registers for next state logic
    reg [2:0] Y_next;
    
    always @(*) begin
        // Default values
        Y_next = y;
        z = 0;
        
        // State transition logic
        case(y)
            3'b000: Y_next = x ? 3'b001 : 3'b000;
            3'b001: Y_next = x ? 3'b100 : 3'b001;
            3'b010: Y_next = x ? 3'b001 : 3'b010;
            3'b011: begin
                Y_next = x ? 3'b010 : 3'b001;
                z = 1;
            end
            3'b100: begin
                Y_next = x ? 3'b100 : 3'b011;
                z = 1;
            end
            default: Y_next = 3'b000; // Default state for safety
        endcase
    end
    
    always @(posedge clk) begin
        // Output next state Y0 as the least significant bit
        Y0 <= Y_next[0];
    end

endmodule