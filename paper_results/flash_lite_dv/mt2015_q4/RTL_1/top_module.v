module top_module(
    input x,
    input y,
    output z
);

    wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;

    // Module A
    module A(input x, input y, output out);
        assign out = (x ^ y) & x;
    endmodule

    // Module B
    module B(input x, input y, output out);
        always @(*) begin
            case({x, y})
                2'b00: out = 1'b1;
                2'b01: out = 1'b0;
                2'b10: out = 1'b0;
                2'b11: out = 1'b1;
                default: out = 1'b0; // Optional: handle other cases
            endcase
        end
    endmodule


    A a1 (x, y, a1_out);
    A a2 (x, y, a2_out);
    B b1 (x, y, b1_out);
    B b2 (x, y, b2_out);

    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;
    assign z = or_out ^ and_out;

endmodule