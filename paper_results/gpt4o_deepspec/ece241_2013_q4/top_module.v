module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    // State declaration
    reg [2:0] prev_s; // Register to store the previous state of sensors

    // Sequential logic for state update
    always @(posedge clk) begin
        if (reset) begin
            // Reset to initial state where no sensors asserted and all flow rates are max
            fr3 <= 1;
            fr2 <= 1;
            fr1 <= 1;
            dfr <= 1;
            prev_s <= 3'b000; // No sensors asserted
        end else begin
            // Synchronous state updates and output logic

            // Default flow rates
            fr3 <= 0;
            fr2 <= 0;
            fr1 <= 0;
            dfr <= 0;

            case (s)
                3'b111: begin // Above s[3]: All sensors asserted
                    // No flow rates are enabled
                    fr3 <= 0;
                    fr2 <= 0;
                    fr1 <= 0;
                    dfr <= 0;
                end
                3'b011: begin // Between s[3] and s[2]
                    fr1 <= 1; // Nominal flow rate 1 enabled
                    dfr <= (prev_s < s); // Supplemental flow rate enabled if level is rising
                end
                3'b001: begin // Between s[2] and s[1]
                    fr1 <= 1; // Nominal flow rate 1
                    fr2 <= 1; // Nominal flow rate 2
                    dfr <= (prev_s < s); // Supplemental flow rate enabled if level is rising
                end
                3'b000: begin // Below s[1]: No sensors asserted
                    fr1 <= 1; // All flow rates are fully opened
                    fr2 <= 1;
                    fr3 <= 1;
                    dfr <= (prev_s < s); // Supplemental flow rate enabled if level is rising
                end
            endcase

            // Update the previous state of the sensors
            prev_s <= s;
        end
    end

endmodule