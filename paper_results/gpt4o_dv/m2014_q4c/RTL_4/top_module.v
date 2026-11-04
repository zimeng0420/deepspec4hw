module top_module (
    input clk,
    input d,
    input r,
    output logic q
);

    // D flip-flop with active high synchronous reset
    always_ff @(posedge clk) begin
        if (r) 
            q <= 0; // Reset condition
        else 
            q <= d; // Data propagation
    end

endmodule