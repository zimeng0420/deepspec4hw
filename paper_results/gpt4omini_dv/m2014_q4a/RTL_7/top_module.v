module top_module (
    input d,
    input ena,
    output logic q
);

always @* begin
    if (ena) 
        q = d;
    // If ena is low, q retains its previous value (no assignment needed)
end

endmodule