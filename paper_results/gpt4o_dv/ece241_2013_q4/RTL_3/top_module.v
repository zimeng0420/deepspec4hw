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
    typedef enum logic [1:0] {
        LOW = 2'b00,
        BETWEEN_S1_S2 = 2'b01,
        BETWEEN_S2_S3 = 2'b10,
        ABOVE_S3 = 2'b11
    } state_t;

    state_t current_state, next_state;
    state_t previous_state;

    // Combinational logic to determine next state and outputs
    always_comb begin
        // Default outputs
        fr3 = 0;
        fr2 = 0;
        fr1 = 0;
        dfr = 0;
        
        // Determine next state based on sensor inputs
        case (s)
            3'b000: next_state = LOW;
            3'b001: next_state = BETWEEN_S1_S2;
            3'b011: next_state = BETWEEN_S2_S3;
            3'b111: next_state = ABOVE_S3;
            default: next_state = LOW; // Incorrect state
        endcase
        
        // Determine outputs based on next state and previous state
        case (next_state)
            LOW: begin
                fr3 = 1;
                fr2 = 1;
                fr1 = 1;
            end
            
            BETWEEN_S1_S2: begin
                fr2 = 1;
                fr1 = 1;
            end
            
            BETWEEN_S2_S3: begin
                fr1 = 1;
            end
            
            ABOVE_S3: begin
                // No outputs asserted
            end
        endcase

        // Determine supplemental flow rate (dfr)
        if (next_state > previous_state) begin
            dfr = 1;
        end
    end

    // Sequential logic for state transitions
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= LOW;
            previous_state <= LOW;
            fr3 <= 1;
            fr2 <= 1;
            fr1 <= 1;
            dfr <= 1;
        end else begin
            previous_state <= current_state;
            current_state <= next_state;
        end
    end

endmodule