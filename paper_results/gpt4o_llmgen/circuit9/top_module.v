module top_module (
    input clk,
    input a, 
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a == 1) begin
        q <= 3'b100;  // Constant '4' when a is asserted
    end 
    else begin
        case (q)
            3'b100: q <= 3'b101; // Increment sequence starts when a goes to 0
            3'b101: q <= 3'b110; 
            3'b110: q <= 3'b000;
            3'b000: q <= 3'b001;
            3'b001: q <= 3'b100; // Loop back to 4 upon reaching 1
            default: q <= 3'b100; // Default to '4' considering undefined initial q
        endcase
    end
end

endmodule