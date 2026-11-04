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
                if (x == 0) Y0 = 0;
                else Y0 = 0;
            end
            3'b001: begin
                if (x == 0) Y0 = 0;
                else Y0 = 0;
            end
            3'b010: begin
                if (x == 0) Y0 = 0;
                else Y0 = 0;
            end
            3'b011: begin
                if (x == 0) Y0 = 0;
                else Y0 = 0;
            end
            3'b100: begin
                if (x == 0) Y0 = 1;
                else Y0 = 0;
            end
            default: Y0 = 0;
        endcase
    end

    always @(*) begin
        case (y)
            3'b000: z = 0;
            3'b001: z = 0;
            3'b010: z = 0;
            3'b011: z = 1;
            3'b100: z = 1;
            default: z = 0;
        endcase
    end

endmodule