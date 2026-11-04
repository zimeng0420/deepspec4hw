module top_module(
    input  [7:0] code,
    output [3:0] out,
    output valid
);

    wire match0, match1, match2, match3, match4, match5, match6, match7, match8, match9;

    assign match0 = (code == 8'h45);
    assign match1 = (code == 8'h16);
    assign match2 = (code == 8'h1e);
    assign match3 = (code == 8'h26);
    assign match4 = (code == 8'h25);
    assign match5 = (code == 8'h2e);
    assign match6 = (code == 8'h36);
    assign match7 = (code == 8'h3d);
    assign match8 = (code == 8'h3e);
    assign match9 = (code == 8'h46);

    assign valid = match0 | match1 | match2 | match3 | match4 | match5 | match6 | match7 | match8 | match9;

    always @(*) begin
        case (1'b1) // Always execute the case statement
            match0: out = 4'b0000;
            match1: out = 4'b0001;
            match2: out = 4'b0010;
            match3: out = 4'b0011;
            match4: out = 4'b0100;
            match5: out = 4'b0101;
            match6: out = 4'b0110;
            match7: out = 4'b0111;
            match8: out = 4'b1000;
            match9: out = 4'b1001;
            default: out = 4'b0000;
        endcase
    end

endmodule