module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    typedef enum reg [1:0] {
        LOW = 2'b00,
        BETWEEN_1_AND_2 = 2'b01,
        BETWEEN_2_AND_3 = 2'b10,
        HIGH = 2'b11
    } state_type;

    state_type current_state, next_state;
    reg previous_sensor_level;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= LOW;
            fr3 <= 1;
            fr2 <= 1;
            fr1 <= 1;
            dfr <= 0;
            previous_sensor_level <= 1'b0; // Indicate that we started from low level
        end else begin
            current_state <= next_state;
        end
    end

    always @* begin
        // Default outputs - no flow
        fr3 = 0;
        fr2 = 0;
        fr1 = 0;
        dfr = 0;
        next_state = current_state;

        case (current_state)
            LOW: begin
                if (s[1] && !s[2] && !s[3]) begin
                    // Sensors are below level s[1]
                    fr3 = 1; 
                    fr2 = 1; 
                    fr1 = 1;
                    next_state = LOW;
                end else if (s[1] && s[2] && !s[3]) begin
                    // Between s[1] and s[2]
                    fr1 = 1;
                    fr2 = 1;
                    next_state = BETWEEN_1_AND_2;
                end else if (s[1] && s[2] && s[3]) begin
                    // Between s[2] and s[3]
                    fr1 = 1;
                    next_state = BETWEEN_2_AND_3;
                end else if (s[3]) begin
                    // Above s[3]
                    next_state = HIGH;
                end
            end
            
            BETWEEN_1_AND_2: begin
                fr1 = 1;
                fr2 = 1;
                next_state = (s[1] && s[2]) ? BETWEEN_1_AND_2 : (s[3] ? HIGH : LOW);
            end 

            BETWEEN_2_AND_3: begin
                fr1 = 1;
                next_state = (s[3]) ? HIGH : (s[2] ? BETWEEN_2_AND_3 : BETWEEN_1_AND_2);
            end 

            HIGH: begin
                // All outputs should be 0
                next_state = HIGH; // Maintain HIGH state.
            end 
        endcase

        // Detect changes in sensor levels
        if (s[1] && !previous_sensor_level) begin
            dfr = 1; // Open Supplemental flow valve
        end else begin
            dfr = 0;
        end

        // Update previous sensor level
        previous_sensor_level = s[1];
    end 

endmodule