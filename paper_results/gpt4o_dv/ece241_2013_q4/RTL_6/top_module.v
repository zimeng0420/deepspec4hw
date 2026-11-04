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
    typedef enum logic [2:0] {
        LOW = 3'b000,     // Below s[1]
        BETWEEN_S1_S2 = 3'b001, // Between s[2] and s[1]
        BETWEEN_S2_S3 = 3'b011, // Between s[3] and s[2]
        ABOVE_S3 = 3'b111  // Above s[3]
    } state_t;
    
    reg [2:0] current_state, next_state;

    // Combinational logic to determine the next state and outputs
    always_comb begin
        // Default outputs
        fr3 = 1'b0;
        fr2 = 1'b0;
        fr1 = 1'b0;
        dfr = 1'b0;
        
        // Determine next state based on sensor inputs
        case(s)
            3'b111: next_state = ABOVE_S3;
            3'b011: next_state = BETWEEN_S2_S3;
            3'b001: next_state = BETWEEN_S1_S2;
            default: next_state = LOW;
        endcase
        
        // Water level transition logic
        if (current_state < next_state)
            dfr = 1'b1;  // Supplemental flow when water level is rising
        
        // Determine outputs based on current state
        case(current_state)
            LOW: begin
                fr3 = 1'b1;
                fr2 = 1'b1;
                fr1 = 1'b1;
            end
            BETWEEN_S1_S2: begin
                fr2 = 1'b1;
                fr1 = 1'b1;
            end
            BETWEEN_S2_S3: begin
                fr1 = 1'b1;
            end
            ABOVE_S3: begin
                // All outputs remain 0
            end
        endcase
    end

    // Sequential logic for state transition
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= LOW; // Reset to LOW state, all outputs asserted
            fr3 <= 1'b1;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            dfr <= 1'b1;
        end
        else begin
            current_state <= next_state;
        end
    end

endmodule