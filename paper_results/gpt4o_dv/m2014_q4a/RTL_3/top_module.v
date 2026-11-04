module top_module (
    input d,
    input ena,
    output logic q
);

    always @(*) begin
        if (ena)
            q = d;  // When enable is high, output follows input
        // Else retain the previous value (implicitly done as there is no assignment to q)
    end

endmodule