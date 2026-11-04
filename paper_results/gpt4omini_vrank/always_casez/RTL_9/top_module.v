module top_module (
    input [7:0] in,
    output reg [2:0] pos
);
    always @(*) begin
        pos = 3'b000; // default to zero
        case (in)
            8'b00000000: pos = 3'b000; // no bits high
            8'b00000001: pos = 3'b000; // bit 0
            8'b00000010: pos = 3'b001; // bit 1
            8'b00000100: pos = 3'b010; // bit 2
            8'b00001000: pos = 3'b011; // bit 3
            8'b00010000: pos = 3'b100; // bit 4
            8'b00100000: pos = 3'b101; // bit 5
            8'b01000000: pos = 3'b110; // bit 6
            8'b10000000: pos = 3'b111; // bit 7
            default: begin
                if (in[0]) pos = 3'b000;
                else if (in[1]) pos = 3'b001;
                else if (in[2]) pos = 3'b010;
                else if (in[3]) pos = 3'b011;
                else if (in[4]) pos = 3'b100;
                else if (in[5]) pos = 3'b101;
                else if (in[6]) pos = 3'b110;
                else if (in[7]) pos = 3'b111;
            end
        endcase
    end
endmodule