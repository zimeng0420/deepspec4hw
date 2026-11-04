module top_module(
    input  [7:0] code,
    output [3:0] out,
    output valid
);

    // Internal signals
    wire match_0, match_1, match_2, match_3, match_4, match_5, match_6, match_7, match_8, match_9;

    // Comparators
    assign match_0 = (code == 8'h45);
    assign match_1 = (code == 8'h16);
    assign match_2 = (code == 8'h1e);
    assign match_3 = (code == 8'h26);
    assign match_4 = (code == 8'h25);
    assign match_5 = (code == 8'h2e);
    assign match_6 = (code == 8'h36);
    assign match_7 = (code == 8'h3d);
    assign match_8 = (code == 8'h3e);
    assign match_9 = (code == 8'h46);

    // Validity signal
    assign valid = match_0 | match_1 | match_2 | match_3 | match_4 | match_5 | match_6 | match_7 | match_8 | match_9;

    // Key value assignment using a case statement
    always @(*) begin
        case (1'b1) // Using 1'b1 to create a combinational logic block.
            match_0: out = 4'b0000;
            match_1: out = 4'b0001;
            match_2: out = 4'b0010;
            match_3: out = 4'b0011;
            match_4: out = 4'b0100;
            match_5: out = 4'b0101;
            match_6: out = 4'b0110;
            match_7: out = 4'b0111;
            match_8: out = 4'b1000;
            match_9: out = 4'b1001;
            default:  out = 4'b0000;
        endcase
    end

endmodule