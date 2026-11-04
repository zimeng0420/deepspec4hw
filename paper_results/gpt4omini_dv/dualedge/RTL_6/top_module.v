module top_module(
    input clk,
    input d,
    output reg q
);
    reg d_rise, d_fall;

    always @(posedge clk) begin
        d_rise <= d; // Capture d on rising edge
    end

    always @(negedge clk) begin
        d_fall <= d; // Capture d on falling edge
    end

    always @(*) begin
        q = (clk) ? d_rise : d_fall; // Select between captured values based on clk
    end
endmodule