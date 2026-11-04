module top_module (
    input d,
    input ena,
    output logic q
);

    always @(*) begin
        if (ena) 
            q = d;
        // Retain previous value of q when ena is low
    end

endmodule