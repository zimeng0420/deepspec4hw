module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    reg [2:0] prev_sensors;

    always @(posedge clk) begin
        if (reset) begin
            fr3 <= 1;
            fr2 <= 1;
            fr1 <= 1;
            dfr <= 1;
            prev_sensors <= 3'b000;
        end else begin
            // Determine current water level and flow control
            case (s)
                3'b111: begin // Above s[3]
                    fr3 <= 0;
                    fr2 <= 0;
                    fr1 <= 0;
                    dfr <= 0;
                end
                3'b011: begin // Between s[3] and s[2]
                    fr3 <= 0;
                    fr2 <= 0;
                    fr1 <= 1;
                    dfr <= (prev_sensors < s);
                end
                3'b001: begin // Between s[2] and s[1]
                    fr3 <= 0;
                    fr2 <= 1;
                    fr1 <= 1;
                    dfr <= (prev_sensors < s);
                end
                3'b000: begin // Below s[1]
                    fr3 <= 1;
                    fr2 <= 1;
                    fr1 <= 1;
                    dfr <= (prev_sensors < s);
                end
                default: begin // any other undefined states
                    fr3 <= 0;
                    fr2 <= 0;
                    fr1 <= 0;
                    dfr <= 0;
                end
            endcase
            
            // Store current sensors state for next cycle comparison
            prev_sensors <= s;
        end
    end

endmodule