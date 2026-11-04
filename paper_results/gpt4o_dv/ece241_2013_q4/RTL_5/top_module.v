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
    reg [1:0] current_state, next_state;
    parameter BELOW_S1 = 2'b00, BETWEEN_S1_S2 = 2'b01, BETWEEN_S2_S3 = 2'b10, ABOVE_S3 = 2'b11;
    reg [1:0] previous_state;

    // State machine: Sequential logic for state transitions
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW_S1; // Reset state
            previous_state <= BELOW_S1; // Also reset previous_state
        end else begin
            current_state <= next_state;
            previous_state <= current_state;
        end
    end

    // Next state logic and output logic
    always @(*) begin
        case (current_state)
            BELOW_S1: begin
                fr3 = 1;
                fr2 = 1;
                fr1 = 1;
                dfr = (previous_state != BELOW_S1);
                if (s[1]) next_state = BETWEEN_S1_S2;
                else next_state = BELOW_S1;
            end
            
            BETWEEN_S1_S2: begin
                fr3 = 0;
                fr2 = 1;
                fr1 = 1;
                dfr = (previous_state == BELOW_S1);
                if (s[2]) next_state = BETWEEN_S2_S3;
                else if (~s[1]) next_state = BELOW_S1;
                else next_state = BETWEEN_S1_S2;
            end
            
            BETWEEN_S2_S3: begin
                fr3 = 0;
                fr2 = 0;
                fr1 = 1;
                dfr = (previous_state == BELOW_S1 || previous_state == BETWEEN_S1_S2);
                if (s[3]) next_state = ABOVE_S3;
                else if (~s[2]) next_state = BETWEEN_S1_S2;
                else next_state = BETWEEN_S2_S3;
            end
            
            ABOVE_S3: begin
                fr3 = 0;
                fr2 = 0;
                fr1 = 0;
                dfr = 0;
                if (~s[3]) next_state = BETWEEN_S2_S3;
                else next_state = ABOVE_S3;
            end
        endcase
    end
    
endmodule