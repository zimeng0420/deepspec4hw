module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

reg [3:1] prev_sensors;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        fr3 <= 1;
        fr2 <= 1;
        fr1 <= 1;
        dfr <= 0;
        prev_sensors <= 3'b111; // Assuming all sensors inactive initially
    end else begin
        case (1'b1)
            s[3]: begin // Above s[3]
                fr1 <= 0;
                fr2 <= 0;
                fr3 <= 0;
                dfr <= 0;
            end
            s[2]: begin // Between s[3] and s[2]
                fr1 <= 1;
                fr2 <= 0;
                fr3 <= 0;
                dfr <= (prev_sensors < 3'b010) ? 1 : 0; // Check if level has risen
            end
            s[1]: begin // Between s[2] and s[1]
                fr1 <= 1;
                fr2 <= 1;
                fr3 <= 0;
                dfr <= (prev_sensors < 3'b001) ? 1 : 0; // Check if level has risen
            end
            default: begin // Below s[1]
                fr1 <= 1;
                fr2 <= 1;
                fr3 <= 1;
                dfr <= 1;
            end
        endcase
        prev_sensors <= s; // Store current sensor states for the next clock cycle
    end
end

endmodule