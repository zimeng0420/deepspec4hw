module top_module (
    input a, 
    input b,
    input c,
    input d,
    output out
);
    assign out = (c & ~d & ~b & ~a) | (c & ~d & b & ~a) | (c & d & b) | (c & d & ~b) | (d & ~b & a) | (~c & ~d & a);
endmodule