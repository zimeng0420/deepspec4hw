module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    reg [3:1] previous_sensors;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fr3 <= 1;
            fr2 <= 1;
            fr1 <= 1;
            dfr <= 0;
            previous_sensors <= 3'b000;
        end else begin
            previous_sensors <= s;

            if (s[3]) begin
                fr3 <= 0;
                fr2 <= 0;
                fr1 <= 0;
            end else if (!s[1]) begin
                fr3 <= 1;
                fr2 <= 1;
                fr1 <= 1;
            end else if (s[2]) begin
                fr3 <= 0;
                fr2 <= 1;
                fr1 <= 1;
            end else if (s[1]) begin
                fr3 <= 0;
                fr2 <= 0;
                fr1 <= 1;
            end
            
            if (previous_sensors < s) begin
                dfr <= 1;
            end else begin
                dfr <= 0;
            end
        end
    end
endmodule