module top_module (
    input clk,
    input x,
    input [2:0] y,
    output reg Y0,
    output reg z
);

    always @(*) begin
        case (y)
            3'b000: begin
                if (x == 0) 
                    Y0 = 1'b0; // Next state Y[0] when x=0 is 000
                else 
                    Y0 = 1'b1; // Next state Y[0] when x=1 is 001
                z = 0;
            end
            3'b001: begin
                if (x == 0) 
                    Y0 = 1'b1; // Next state Y[0] when x=0 is 001
                else 
                    Y0 = 1'b0; // Next state Y[0] when x=1 is 100
                z = 0;
            end
            3'b010: begin
                if (x == 0) 
                    Y0 = 1'b0; // Next state Y[0] when x=0 is 010
                else 
                    Y0 = 1'b1; // Next state Y[0] when x=1 is 001
                z = 0;
            end
            3'b011: begin
                if (x == 0) 
                    Y0 = 1'b1; // Next state Y[0] when x=0 is 001
                else 
                    Y0 = 1'b0; // Next state Y[0] when x=1 is 010
                z = 1;
            end
            3'b100: begin
                if (x == 0) 
                    Y0 = 1'b1; // Next state Y[0] when x=0 is 011
                else 
                    Y0 = 1'b0; // Next state Y[0] when x=1 is 100
                z = 1;
            end
            default: begin
                Y0 = 1'b0;
                z = 0;
            end
        endcase
    end

endmodule