module top_module (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-Products (SOP) form
    assign out_sop = (~a & ~b & b & ~d) | (~a & b & b & b) | (b & b & b & b);
	

    // Product-of-Sums (POS) form
    assign out_pos = (~(a & ~b & ~c & ~d)) & (~(a & ~b & ~c & b)) & (~(a & ~b & b & ~d)) & (~(a & ~b & b & b)) & (~(a & b & ~c & ~d)) & (~(a & b & ~c & b)) & (~(a & b & b & ~d)) & (~(b & ~c & b & b)) & (~(b & b & ~c & ~d)) & (~(b & b & b & ~b));
endmodule