module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    // State Encoding
    typedef enum logic [1:0] {
        LOW = 2'b00,
        MEDIUM = 2'b01,
        HIGH = 2'b10,
        FULL = 2'b11
    } state_t;

    state_t current_state, next_state;
    state_t previous_state; // To remember the previous state

    // State Transition Logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= LOW;
        end else begin
            current_state <= next_state;
            previous_state <= current_state;
        end
    end

    // Next State Logic
    always_comb begin
        case (current_state)
            LOW: begin
                if (s == 3'b001)
                    next_state = MEDIUM;
                else
                    next_state = LOW;
            end
            MEDIUM: begin
                if (s == 3'b011)
                    next_state = HIGH;
                else if (s == 3'b000)
                    next_state = LOW;
                else
                    next_state = MEDIUM;
            end
            HIGH: begin
                if (s == 3'b111)
                    next_state = FULL;
                else if (s == 3'b001)
                    next_state = MEDIUM;
                else
                    next_state = HIGH;
            end
            FULL: begin
                if (s == 3'b011)
                    next_state = HIGH;
                else
                    next_state = FULL;
            end
            default: next_state = LOW;
        endcase
    end

    // Output Logic
    always_comb begin
        // Default outputs
        fr3 = 0;
        fr2 = 0;
        fr1 = 0;
        dfr = 0;

        case (current_state)
            LOW: begin
                fr3 = 1;
                fr2 = 1;
                fr1 = 1;
                dfr = 1;
            end
            MEDIUM: begin
                fr2 = 1;
                fr1 = 1;
                if (previous_state == LOW)
                    dfr = 1;
            end
            HIGH: begin
                fr1 = 1;
                if (previous_state == MEDIUM)
                    dfr = 1;
            end
            FULL: begin
                // Keep all outputs off
            end
        endcase
    end
endmodule