module top_module (
    input d,
    input ena,
    output logic q
);

    always @(*) begin
        if (ena) 
            q = d;       // When ena is high, q follows d
        // Else it retains its previous value, no explicit assignment needed
    end

endmodule