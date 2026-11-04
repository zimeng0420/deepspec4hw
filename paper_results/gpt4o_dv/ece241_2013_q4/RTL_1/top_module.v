module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    reg [1:0] current_level, previous_level;

    always @(posedge clk) begin
        if (reset) begin
            // Reset state: water level low for a long time
            current_level <= 2'b00; // Below s[1] level
            fr3 <= 1;
            fr2 <= 1;
            fr1 <= 1;
            dfr <= 1;
        end else begin
            // Save previous level
            previous_level <= current_level;
            
            // Determine current water level
            case (s)
                3'b111: current_level <= 2'b11; // Above s[3]
                3'b011: current_level <= 2'b10; // Between s[3] and s[2]
                3'b001: current_level <= 2'b01; // Between s[2] and s[1]
                default: current_level <= 2'b00; // Below s[1]
            endcase
            
            // Determine the flow outputs based on water level
            case (current_level)
                2'b11: begin // Above s[3]
                    fr3 <= 0;
                    fr2 <= 0;
                    fr1 <= 0;
                    dfr <= 0;
                end
                2'b10: begin // Between s[3] and s[2]
                    fr3 <= 0;
                    fr2 <= 0;
                    fr1 <= 1;
                    dfr <= (current_level > previous_level);
                end
                2'b01: begin // Between s[2] and s[1]
                    fr3 <= 0;
                    fr2 <= 1;
                    fr1 <= 1;
                    dfr <= (current_level > previous_level);
                end
                2'b00: begin // Below s[1]
                    fr3 <= 1;
                    fr2 <= 1;
                    fr1 <= 1;
                    dfr <= (current_level > previous_level);
                end
            endcase
        end
    end

endmodule