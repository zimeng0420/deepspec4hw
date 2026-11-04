module top_module(
    input  [7:0] code,
    output [3:0] out,
    output       valid
);

    wire [9:0] match;

    assign match[0] = (code == 8'h45);
    assign match[1] = (code == 8'h16);
    assign match[2] = (code == 8'h1e);
    assign match[3] = (code == 8'h26);
    assign match[4] = (code == 8'h25);
    assign match[5] = (code == 8'h2e);
    assign match[6] = (code == 8'h36);
    assign match[7] = (code == 8'h3d);
    assign match[8] = (code == 8'h3e);
    assign match[9] = (code == 8'h46);

    assign valid = |match;

    always @(*) begin
        case (1'b1)
            match[0]: out = 4'b0000;
            match[1]: out = 4'b0001;
            match[2]: out = 4'b0010;
            match[3]: out = 4'b0011;
            match[4]: out = 4'b0100;
            match[5]: out = 4'b0101;
            match[6]: out = 4'b0110;
            match[7]: out = 4'b0111;
            match[8]: out = 4'b1000;
            match[9]: out = 4'b1001;
            default:  out = 4'b0000;
        endcase
    end

endmodule