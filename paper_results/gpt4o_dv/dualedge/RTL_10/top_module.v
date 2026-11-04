module top_module(
    input clk,
    input d,
    output reg q);

    reg q1, q2;
    
    always @(posedge clk) begin
        q1 <= d; // Capture the value on the rising edge
    end

    always @(negedge clk) begin
        q2 <= d; // Capture the value on the falling edge
    end

    always @(*) begin
        if (clk)
            q = q1; // On positive half cycle use value from positive edge
        else
            q = q2; // On negative half cycle use value from negative edge
    end

endmodule