module top_module (
    input  [7:0] in,
    output reg [2:0] pos
);

  always @(*) begin
    casez (in)
      8'bxxxxxxxx, 8'bxxxxxxx0: pos = 3'b000;
      8'bxxxxxx01: pos = 3'b001;
      8'bxxxxx01z: pos = 3'b010;
      8'bxxxx01zz: pos = 3'b011;
      8'bxxx01zzz: pos = 3'b100;
      8'bxx01zzzz: pos = 3'b101;
      8'bx01zzzzz: pos = 3'b110;
      8'b01zzzzzz: pos = 3'b111;
      default: pos = 3'b000;
    endcase
  end

endmodule