module top_module (
    input clk,
    input x,
    input [2:0] y,
    output reg Y0,
    output reg z
);

    always @(posedge clk) begin
        case (y)
            3'b000: begin
                Y0 <= (x) ? 1'b1 : 1'b0;  // Next state is 001 if x=1, else stays 000.
                z <= 1'b0;
            end
            3'b001: begin
                Y0 <= (x) ? 3'b100 : 3'b001;  // Next state is 100 if x=1, else stays 001.
                z <= 1'b0;
            end
            3'b010: begin
                Y0 <= (x) ? 3'b001 : 3'b010;  // Next state is 001 if x=1, else stays 010.
                z <= 1'b0;
            end
            3'b011: begin
                Y0 <= (x) ? 3'b010 : 3'b001;  // Next state is 010 if x=1, else goes to 001.
                z <= 1'b1;
            end
            3'b100: begin
                Y0 <= (x) ? 3'b100 : 3'b011;  // Next state is 011 if x=0 else stays at 100.
                z <= 1'b1;
            end
            default: begin
                Y0 <= 3'b000;  // Default to state 000
                z <= 1'b0;
            end
        endcase
    end

endmodule