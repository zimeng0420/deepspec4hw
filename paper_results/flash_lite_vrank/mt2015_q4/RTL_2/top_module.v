module top_module(
	input x,
	input y,
	output z);

    wire a_out1, a_out2, b_out1, b_out2, or_out, and_out;

    // Module A instantiation
    module A (input x, input y, output z);
        assign z = (x ^ y) & x;
    endmodule

    A a1 (x, y, a_out1);
    A a2 (x, y, a_out2);

    // Module B instantiation
    reg [89:0] time;
    reg b_out1_reg, b_out2_reg;

    always @(x or y) begin
        time = 0;
        if (x == 0 && y == 0) time = 15;
        if (x == 1 && y == 0) time = 30;
        if (x == 0 && y == 1) time = 60;
        if (x == 1 && y == 1) time = 70;
    end

    always @(x or y or time) begin
        case (1'b1)
            (x == 0 && y == 0 && time <= 15): b_out1_reg = 1'b1;
            (x == 1 && y == 0 && time <= 30): b_out1_reg = 1'b0;
            (x == 0 && y == 1 && time <= 60): b_out1_reg = 1'b0;
            (x == 1 && y == 1 && time <= 70): b_out1_reg = 1'b1;
            default: b_out1_reg = 1'b0;
        endcase
    end
	
    always @(x or y or time) begin
        case (1'b1)
            (x == 0 && y == 0 && time <= 15): b_out2_reg = 1'b1;
            (x == 1 && y == 0 && time <= 30): b_out2_reg = 1'b0;
            (x == 0 && y == 1 && time <= 60): b_out2_reg = 1'b0;
            (x == 1 && y == 1 && time <= 70): b_out2_reg = 1'b1;
            default: b_out2_reg = 1'b0;
        endcase
    end

    assign b_out1 = b_out1_reg;
    assign b_out2 = b_out2_reg;

    // Logic gates
    assign or_out = a_out1 | b_out1;
    assign and_out = a_out2 & b_out2;
    assign z = or_out ^ and_out;

endmodule