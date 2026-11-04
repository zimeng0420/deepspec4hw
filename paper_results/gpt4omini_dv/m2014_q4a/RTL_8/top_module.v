module top_module (
    input d,
    input ena,
    output logic q
);
    always @(*) begin
        if (ena) 
            q = d;
        // When ena is not high, q retains its previous value
    end
endmodule