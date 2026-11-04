module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    reg [3:1] previous_s;

    always @(posedge clk) begin
        if (reset) begin
            fr3 <= 1'b1;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            dfr <= 1'b1;
            previous_s <= 3'b000; // assuming all sensors not asserted
        end else begin
            // Update outputs based on sensor states
            if (s[3]) begin
                fr3 <= 1'b0;
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                dfr <= 1'b0;
            end else if (s[1] == 1'b0) begin
                fr3 <= 1'b1;
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                dfr <= 1'b1; // maximum flow rates
            end else if (s[2]) begin
                fr3 <= 1'b0;
                fr2 <= 1'b1;
                fr1 <= 1'b1; // fr2 and fr1 open
                dfr <= (previous_s < s) ? 1'b1 : 1'b0; // check for rising level
            end else if (s[1]) begin
                fr3 <= 1'b0;
                fr2 <= 1'b0;
                fr1 <= 1'b1; // fr1 open
                dfr <= (previous_s < s) ? 1'b1 : 1'b0; // check for rising level
            end else begin
                fr3 <= 1'b1;
                fr2 <= 1'b1;
                fr1 <= 1'b1; // all closed
                dfr <= 1'b0; 
            end

            previous_s <= s; // update previous sensor state
        end
    end

endmodule