module top_module (
    input [7:0] in,
    output reg [2:0] pos
);
    
    always @(*) begin
        pos = 3'd0; // Default case - no bits are high
        case (in)
            8'b00000001: pos = 3'd0;
            8'b00000010: pos = 3'd1;
            8'b00000100: pos = 3'd2;
            8'b00001000: pos = 3'd3;
            8'b00010000: pos = 3'd4;
            8'b00100000: pos = 3'd5;
            8'b01000000: pos = 3'd6;
            8'b10000000: pos = 3'd7;
            default: begin
                if (in[0]) pos = 3'd0;
                else if (in[1]) pos = 3'd1;
                else if (in[2]) pos = 3'd2;
                else if (in[3]) pos = 3'd3;
                else if (in[4]) pos = 3'd4;
                else if (in[5]) pos = 3'd5;
                else if (in[6]) pos = 3'd6;
                else if (in[7]) pos = 3'd7;
            end
        endcase
    end
    
endmodule