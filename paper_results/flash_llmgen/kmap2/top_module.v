module top_module (
    input a,
    input b,
    input c,
    input d,
    output out
);

  //  K-Map Simplification:
  //  out =  ~c~d~b + ~c~da + ~cdb + ~cda + cd~a + c~bd + c~ba

  assign out = (~c & ~d & ~b) | (~c & ~d & a) | (~c & d & b) | (~c & d & a) | (c & d & ~a) | (c & ~b & d) | (c & ~b & a);

endmodule