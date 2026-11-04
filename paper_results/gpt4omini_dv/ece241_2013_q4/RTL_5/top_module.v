module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

reg [3:1] prev_s; // to store the previous sensor state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        fr3 <= 1;
        fr2 <= 1;
        fr1 <= 1;
        dfr <= 0;
        prev_s <= 3'b000; // Initial state (no sensors activated)
    end else begin
        // Update previous sensor state
        prev_s <= s;

        // Combinational Logic
        if (s[3]) begin
            fr1 <= 0; 
            fr2 <= 0; 
            fr3 <= 0; 
            dfr <= 0; // No flow above highest sensor
        end else if (!s[1]) begin
            fr1 <= 1; 
            fr2 <= 1; 
            fr3 <= 1; // Max flow below lowest sensor
            dfr <= 1; // Supplemental valve open
        end else if (s[2] && !s[1]) begin
            fr1 <= 1; 
            fr2 <= 1; 
            fr3 <= 0; // Fr1 and Fr2 activated between s[2] and s[1]
            dfr <= (prev_s < s) ? 1 : 0; // Increase flow if rising
        end else if (s[1]) begin
            fr1 <= 1; 
            fr2 <= 0; 
            fr3 <= 0; // Fr1 activated between s[3] and s[2]
            dfr <= (prev_s < s) ? 1 : 0; // Increase flow if rising
        end else begin
            fr1 <= 0; 
            fr2 <= 0; 
            fr3 <= 0; 
            dfr <= 0; // Default case
        end
    end
end

endmodule