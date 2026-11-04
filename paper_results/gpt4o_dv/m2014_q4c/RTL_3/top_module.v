module top_module (
    input clk,
    input d,
    input r,
    output logic q
);

    always_ff @(posedge clk) begin
        if (r) 
            q <= 1'b0;  // Synchronous reset sets q to 0
        else 
            q <= d;     // q follows d if no reset
    end

endmodule