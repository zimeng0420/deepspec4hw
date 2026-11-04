module top_module (
    input d,        // Data input
    input ena,      // Enable input
    output logic q  // Output logic
);

    // Always block triggered on changes to 'ena' or 'd'
    always @* begin 
        if (ena) begin
            q = d;   // When enabled, output follows input 'd'
        end else begin
            q = q;   // When not enabled, output holds its previous value
        end
    end 

endmodule