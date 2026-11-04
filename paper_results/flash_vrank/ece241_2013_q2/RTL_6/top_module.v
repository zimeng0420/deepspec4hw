module top_module (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

  // SOP implementation
  assign out_sop = (~a & ~b & ~c & ~d) | (~a & ~b & ~c & d) | (~a & ~b & c & ~d) | (~a & ~b & c & d) | (~a & b & ~c & ~d) | (~a & b & ~c & d) | (~a & b & c & ~d) | (~a & b & c & d) | (a & ~b & ~c & ~d) | (a & ~b & ~c & d) | (a & ~b & c & ~d) | (a & ~b & c & d) | (a & b & ~c & ~d) | (a & b & ~c & d) | (a & b & c & ~d) | (a & b & c & d) ?
                   ((~a & ~b & ~c & d) | (~a & b & c & d) | (a & b & b & b)) : 0;
  assign out_sop = (~a & ~b & c & ~d) | (~a & ~b & c & d);


  assign out_sop = (~a & ~b & c & d) | (a & b & c & d);


  assign out_sop = (~a & ~b & c & d) | (a & b & c & d);
//  assign out_sop = ((~a) & (~b) & (c) & (d)) | ((a) & (b) & (c) & (d));
    assign out_sop = (~a & ~b & c & d) | (a & b & c & d);


// POS implementation
 assign out_pos = (~a & ~b & ~c & ~d) | (~a & ~b & ~c & d) | (~a & ~b & c & ~d) | (~a & ~b & c & d) | (~a & b & ~c & ~d) | (~a & b & ~c & d) | (~a & b & c & ~d) | (~a & b & c & d) | (a & ~b & ~c & ~d) | (a & ~b & ~c & d) | (a & ~b & c & ~d) | (a & ~b & c & d) | (a & b & ~c & ~d) | (a & b & ~c & d) | (a & b & c & ~d) | (a & b & c & d) ?
                     ((~a & ~b & ~c & ~d) & (~a & ~b & ~c & d) & (~a & ~b & c & ~d) & (~a & ~b & c & d) & (~a & b & ~c & ~d) & (~a & b & ~c & d) & (~a & b & c & ~d) & (~a & b & c & d) & (a & ~b & ~c & ~d) & (a & ~b & ~c & d) & (a & ~b & c & ~d) & (a & ~b & c & d) & (a & b & ~c & ~d) & (a & b & ~c & d) & (a & b & c & ~d) & (a & b & c & d)) : 1;

    assign out_pos = (~(a & b & c & d));

    assign out_pos = (~(a & b & c & d));

   assign out_pos = (~(a&~b&~c&~d));

//assign out_pos = ~(a) ;
//assign out_pos = ~(a);
    assign out_pos = ~(a);


assign out_pos = (~a | ~b | ~c | d) & (a | b | c | d);

assign out_pos = (~a | ~b | ~c | ~d) & (~a | ~b | ~c | d) & (~a | ~b | c | ~d) & (~a | ~b | c | d) & (~a | b | ~c | ~d) & (~a | b | ~c | d) & (~a | b | c | ~d) & (~a | b | c | d) & (a | ~b | ~c | ~d) & (a | ~b | ~c | d) & (a | ~b | c | ~d) & (a | ~b | c | d) & (a | b | ~c | ~d) & (a | b | ~c | d) & (a | b | c | ~d) & (a | b | c | d) ;

//assign out_pos = (~a | ~b | ~c | ~d) & (~a | ~b | ~c | d) & (~a | ~b | c | ~d) & (~a | ~b | c | d) & (~a | b | ~c | ~d) & (~a | b | ~c | d) & (~a | b | c | ~d) & (~a | b | c | d) & (a | ~b | ~c | ~d) & (a | ~b | ~c | d) & (a | ~b | c | ~d) & (a | ~b | c | d) & (a | b | ~c | ~d) & (a | b | ~c | d) & (a | b | c | ~d) & (a | b | c | d) ;
 assign out_pos = ((a | b | c | ~d) ) ;
  // Minimization using Karnaugh maps yields:
  // SOP: out_sop = (!a & b & c & d) | (a & b & c & d);
  assign out_sop = ((~a) & (~b) & (c) & (d)) | ((a) & (b) & (c) & (d));

  // POS: out_pos = (~a | ~b | ~c | d) & (a | b | c | d);
  assign out_pos = ((~a) & (~b) & (c) & (d)) | ((a) & (b) & (c) & (d));

endmodule