module top_module(
    input a,
    input b,
    input c,
    input d,
    output reg out
);

    always @(*) begin
        // Simplified Boolean expression derived from the Karnaugh map
        // out = (a & ~b & ~c) | (a & ~b & d) | (a & ~b & c) | (a & b) | (b & c & d) | (b & ~c & ~d) | (b & c & ~d) | (b & ~c & d) | (a & ~b & c) | (a & ~b & d)
        // out = a & ~b & (c | d | ~c) | b;
        // out = a & ~b | b & (c | ~c) | b & (d | ~d)
        out = (a & ~b & ~c) | (a & b) | (a & c & d) | (a & c & ~d) | (a & ~c & d)| (a & ~c & ~d)| (b & c) | (b & d) | (b & ~c & ~d) | (b & ~c & d) | (a & ~b & c) | (a & ~b & d) ;
        out = (a & ~b) | (b & (c | ~c | d | ~d )) | (a & ~b & (c | d)) ;
        out = (a & ~b) | b;

    end
endmodule