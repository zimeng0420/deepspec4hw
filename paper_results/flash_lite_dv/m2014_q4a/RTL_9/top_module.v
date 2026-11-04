module top_module (
    input d,
    input ena,
    output logic q
);

  always @(*) begin
    if (ena) begin
      q = d;
    end
    // else q remains its previous value (implicitly)
  end

endmodule