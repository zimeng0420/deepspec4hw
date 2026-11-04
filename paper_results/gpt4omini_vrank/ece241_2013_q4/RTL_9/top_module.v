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
    typedef enum reg [1:0] {
        LOW = 2'b00,   // Below s[1]
        MID1 = 2'b01,  // Between s[2] and s[1]
        MID2 = 2'b10,  // Between s[3] and s[2]
        HIGH = 2'b11   // Above s[3]
    } state_t;

    state_t current_state, next_state;

    // Combinational logic for next state and outputs
    always @(*) begin
        // Default output values
        fr3 = 0;
        fr2 = 0;
        fr1 = 0;
        dfr = 0;
        
        case (current_state)
            LOW: begin
                fr3 = 1;
                fr2 = 1;
                fr1 = 1;
            end
            MID1: begin
                fr2 = 1;
                fr1 = 1;
            end
            MID2: begin
                fr1 = 1;
            end
            HIGH: begin
                // No flow as per specification
            end
        endcase
        
        // Logic for dfr
        if (s[1]) begin
            dfr = (current_state == LOW || (current_state == MID1 && !s[2])) ? 0 : 1;
        end
    end

    // Sequential logic for current state update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= LOW; // Reset to LOW state
        end else begin
            case (s)
                3'b001: next_state <= LOW;   // s[1] asserted
                3'b011: next_state <= MID1;  // s[1], s[2] asserted
                3'b111: next_state <= MID2;  // s[1], s[2], s[3] asserted
                default: next_state <= HIGH;  // Above s[3] or no sensors
            endcase
            current_state <= next_state;
        end
    end
endmodule