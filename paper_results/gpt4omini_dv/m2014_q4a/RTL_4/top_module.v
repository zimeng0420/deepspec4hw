module top_module (
    input d,
    input ena,
    output logic q
);
    always @* begin
        if (ena) 
            q = d;
        // else, retain the previous value of q
    end
endmodule