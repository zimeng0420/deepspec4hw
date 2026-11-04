module top_module(
    input  [7:0] code,
    output [3:0] out,
    output valid
);

    wire code_0_match = (code == 8'h45);
    wire code_1_match = (code == 8'h16);
    wire code_2_match = (code == 8'h1e);
    wire code_3_match = (code == 8'h26);
    wire code_4_match = (code == 8'h25);
    wire code_5_match = (code == 8'h2e);
    wire code_6_match = (code == 8'h36);
    wire code_7_match = (code == 8'h3d);
    wire code_8_match = (code == 8'h3e);
    wire code_9_match = (code == 8'h46);

    assign valid = code_0_match | code_1_match | code_2_match | code_3_match | code_4_match | code_5_match | code_6_match | code_7_match | code_8_match | code_9_match;

    always @(*) begin
        case (1'b1)
            code_0_match: out = 4'b0000;
            code_1_match: out = 4'b0001;
            code_2_match: out = 4'b0010;
            code_3_match: out = 4'b0011;
            code_4_match: out = 4'b0100;
            code_5_match: out = 4'b0101;
            code_6_match: out = 4'b0110;
            code_7_match: out = 4'b0111;
            code_8_match: out = 4'b1000;
            code_9_match: out = 4'b1001;
            default: out = 4'b0000;
        endcase
    end
endmodule