module top_module(
    input  [7:0] code,
    output [3:0] out,
    output       valid
);

    wire valid_0;
    wire valid_1;
    wire valid_2;
    wire valid_3;
    wire valid_4;
    wire valid_5;
    wire valid_6;
    wire valid_7;
    wire valid_8;
    wire valid_9;
    
    assign valid_0 = (code == 8'h45);
    assign valid_1 = (code == 8'h16);
    assign valid_2 = (code == 8'h1e);
    assign valid_3 = (code == 8'h26);
    assign valid_4 = (code == 8'h25);
    assign valid_5 = (code == 8'h2e);
    assign valid_6 = (code == 8'h36);
    assign valid_7 = (code == 8'h3d);
    assign valid_8 = (code == 8'h3e);
    assign valid_9 = (code == 8'h46);

    assign valid = valid_0 | valid_1 | valid_2 | valid_3 | valid_4 | valid_5 | valid_6 | valid_7 | valid_8 | valid_9;

    always @(*) begin
        case (1'b1)
            valid_0: out = 4'b0000;
            valid_1: out = 4'b0001;
            valid_2: out = 4'b0010;
            valid_3: out = 4'b0011;
            valid_4: out = 4'b0100;
            valid_5: out = 4'b0101;
            valid_6: out = 4'b0110;
            valid_7: out = 4'b0111;
            valid_8: out = 4'b1000;
            valid_9: out = 4'b1001;
            default: out = 4'b0000;
        endcase
    end
    
endmodule