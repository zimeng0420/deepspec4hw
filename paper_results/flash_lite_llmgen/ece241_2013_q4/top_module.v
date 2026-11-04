module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    // Define states for the state machine
    parameter IDLE = 3'b000;       // Below s[1] (All valves open)
    parameter BETWEEN_S2_S1 = 3'b001; // Between s[2] and s[1] (fr1, fr2)
    parameter BETWEEN_S3_S2 = 3'b010; // Between s[3] and s[2] (fr1)
    parameter ABOVE_S3 = 3'b011;      // Above s[3] (None)
    parameter RESET_STATE = 3'b100;   // Reset state (initialization)

    // Internal signals
    reg [2:0] current_state, next_state;
    reg [2:0] previous_level; // Store the previous water level state

    // State machine logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= RESET_STATE; // Go to reset state on reset
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        // Default next state is the current state
        next_state = current_state;

        case (current_state)
            RESET_STATE: begin
                // Initialize to the "below s[1]" state
                next_state = IDLE;
            end
            IDLE: begin
                // Check if water level has risen
                if (s[1] && s[2]) begin
                    next_state = BETWEEN_S2_S1;
                end
            end
            BETWEEN_S2_S1: begin
                // Check if water level has risen or fallen
                if (s[3]) begin
                    next_state = BETWEEN_S3_S2;
                end else if (!s[1]) begin
                    next_state = IDLE;
                end
            end
            BETWEEN_S3_S2: begin
                // Check if water level has fallen
                if (!s[2]) begin
                    next_state = BETWEEN_S2_S1;
                end else if (!s[3]) begin
                    next_state = BETWEEN_S2_S1;
                end
            end
            ABOVE_S3: begin
                // Check if water level has fallen
                if (!s[3]) begin
                    next_state = BETWEEN_S3_S2;
                end
            end
            default:
                next_state = IDLE; // Default to IDLE state
        endcase
    end

    // Output logic
    always @(*) begin
        // Default output values
        fr3 = 1'b0;
        fr2 = 1'b0;
        fr1 = 1'b0;
        dfr = 1'b0;

        case (current_state)
            RESET_STATE: begin
                // Reset state: all valves open
                fr3 = 1'b1;
                fr2 = 1'b1;
                fr1 = 1'b1;
                dfr = 1'b0; // No supplemental flow during reset
            end
            IDLE: begin
                // Below s[1]: fr1, fr2, fr3
                fr3 = 1'b1;
                fr2 = 1'b1;
                fr1 = 1'b1;
                dfr = 1'b0;
            end
            BETWEEN_S2_S1: begin
                // Between s[2] and s[1]: fr1, fr2
                fr2 = 1'b1;
                fr1 = 1'b1;
                dfr = (previous_level < current_state) ? 1'b1 : 1'b0; // Supplemental flow if level increased
            end
            BETWEEN_S3_S2: begin
                // Between s[3] and s[2]: fr1
                fr1 = 1'b1;
                dfr = (previous_level < current_state) ? 1'b1 : 1'b0; // Supplemental flow if level increased
            end
            ABOVE_S3: begin
                // Above s[3]: None
                fr3 = 1'b0;
                fr2 = 1'b0;
                fr1 = 1'b0;
                dfr = 1'b0;
            end
            default: begin
                // Default to IDLE state outputs
                fr3 = 1'b1;
                fr2 = 1'b1;
                fr1 = 1'b1;
                dfr = 1'b0;
            end
        endcase
    end

    // Update previous level at the end of the clock cycle
    always @(posedge clk) begin
        if (!reset) begin
            previous_level <= current_state;
        end
    end

endmodule