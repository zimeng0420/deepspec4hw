module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    reg [1:0] current_state, next_state;
    
    // State encoding
    localparam LOW     = 2'b00;
    localparam BETWEEN1_2 = 2'b01;
    localparam BETWEEN2_3 = 2'b10;
    localparam HIGH    = 2'b11;
    
    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= LOW;
        else
            current_state <= next_state;
    end
    
    // Next state logic
    always @(*) begin
        case (current_state)
            LOW: begin
                if (s[3])
                    next_state = HIGH;
                else if (s[2])
                    next_state = BETWEEN2_3;
                else if (s[1])
                    next_state = BETWEEN1_2;
                else
                    next_state = LOW;
            end
            BETWEEN1_2: begin
                if (s[3])
                    next_state = HIGH;
                else if (!s[1])
                    next_state = LOW;
                else
                    next_state = BETWEEN1_2;
            end
            BETWEEN2_3: begin
                if (s[3])
                    next_state = HIGH;
                else if (!s[2])
                    next_state = BETWEEN1_2;
                else
                    next_state = BETWEEN2_3;
            end
            HIGH: begin
                if (!s[3] && s[2])
                    next_state = BETWEEN2_3;
                else if (!s[2] && s[1])
                    next_state = BETWEEN1_2;
                else if (!s[1])
                    next_state = LOW;
                else
                    next_state = HIGH;
            end
            default: next_state = LOW;
        endcase
    end
    
    // Output logic
    always @(*) begin
        // Default outputs
        fr1 = 0;
        fr2 = 0;
        fr3 = 0;
        dfr = 0;
        
        case (next_state)
            LOW: begin
                fr1 = 1;
                fr2 = 1;
                fr3 = 1;
            end
            BETWEEN1_2: begin
                fr1 = 1;
                fr2 = 1;
                dfr = (current_state == LOW); // Supplemental flow valve opened if level is rising
            end
            BETWEEN2_3: begin
                fr1 = 1;
                dfr = (current_state == HIGH); // Supplemental flow valve opened if level is rising
            end
            HIGH: begin
                // No flow needed
            end
        endcase
    end
    
endmodule