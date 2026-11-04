module top_module (
    input [3:0] in,
    output reg [1:0] pos
);
    always @(*) begin
        case (in)
            4'b0000: pos = 2'b00; // None active
            4'b0001: pos = 2'b00; // in[0] active
            4'b0010: pos = 2'b01; // in[1] active
            4'b0100: pos = 2'b10; // in[2] active
            4'b1000: pos = 2'b11; // in[3] active
            default: begin
                if (in[3]) pos = 2'b11;
                else if (in[2]) pos = 2'b10;
                else if (in[1]) pos = 2'b01;
                else if (in[0]) pos = 2'b00;
            end
        endcase
    end
endmodule