module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    // State encoding
    parameter ABOVE_S3 = 2'b00, BETWEEN_S3_S2 = 2'b01, BETWEEN_S2_S1 = 2'b10, BELOW_S1 = 2'b11;
    
    reg [1:0] state, next_state;
    reg prev_sensor_state; // to track previous sensor state for flow control

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= BELOW_S1; // Reset state to BELOW_S1
            fr1 <= 1;
            fr2 <= 1;
            fr3 <= 1;
            dfr <= 1;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            ABOVE_S3: next_state = (s[3]) ? ABOVE_S3 : (s[2]) ? BETWEEN_S3_S2 : (s[1]) ? BETWEEN_S2_S1 : BELOW_S1;
            BETWEEN_S3_S2: next_state = (s[2]) ? BETWEEN_S3_S2 : (s[1]) ? BETWEEN_S2_S1 : BELOW_S1;
            BETWEEN_S2_S1: next_state = (s[1]) ? BETWEEN_S2_S1 : BELOW_S1;
            BELOW_S1: next_state = BELOW_S1; // Stay in BELOW_S1 until sensors assert
            default: next_state = BELOW_S1;
        endcase
    end

    // Output logic
    always @(*) begin
        // Default outputs
        fr3 = 0;
        fr2 = 0;
        fr1 = 0;
        dfr = 0;

        case (state)
            ABOVE_S3: begin
                // no flow
                fr1 = 0;
                fr2 = 0;
                fr3 = 0;
            end
            BETWEEN_S3_S2: begin
                fr1 = 1; // nominal flow 1
            end
            BETWEEN_S2_S1: begin
                fr1 = 1; // nominal flow 1
                fr2 = 1; // nominal flow 2
            end
            BELOW_S1: begin
                fr1 = 1; // nominal flow 1
                fr2 = 1; // nominal flow 2
                fr3 = 1; // nominal flow 3
            end
        endcase

        // Control supplemental flow
        if (state == BETWEEN_S2_S1 && !prev_sensor_state && (s[1] != 0)) begin
            dfr = 1; // open supplemental flow valve if level went up
        end

        if (state == BELOW_S1) begin
            dfr = 1; // always open if below the lowest sensor
        end

        // Store previous sensor state
        prev_sensor_state = s[1] | s[2] | s[3];
    end

endmodule