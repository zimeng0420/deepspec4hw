module top_module (
    input clk,
    input d,
    input ar,
    output logic q
);

    always @(posedge clk or negedge ar) begin
        if (!ar) 
            q <= 0;        // Asynchronous reset
        else 
            q <= d;        // Transfer data on positive edge of clk
    end

endmodule