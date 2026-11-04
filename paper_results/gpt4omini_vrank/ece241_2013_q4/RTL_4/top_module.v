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
        LOW    = 2'b00,  // Below s[1]
        MID    = 2'b01,  // Between s[2] and s[1]
        HIGH   = 2'b10,  // Between s[3] and s[2]
        ABOVE  = 2'b11   // Above s[3]
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= LOW;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            LOW: begin
                fr1 = 1;
                fr2 = 1;
                fr3 = 1;
                dfr = 0;
                if (s[1]) 
                    next_state = MID;
                else 
                    next_state = LOW;
            end
            MID: begin
                fr1 = 1;
                fr2 = 1;
                fr3 = 0;
                dfr = 0;
                if (s[2]) 
                    next_state = HIGH;
                else if (!s[1]) 
                    next_state = LOW;
                else 
                    next_state = MID;
            end
            HIGH: begin
                fr1 = 1;
                fr2 = 0;
                fr3 = 0;
                dfr = 0;
                if (s[3]) 
                    next_state = ABOVE;
                else if (!s[1]) 
                    next_state = LOW;
                else 
                    next_state = MID;
            end
            ABOVE: begin
                fr1 = 0;
                fr2 = 0;
                fr3 = 0;
                dfr = 0;
                if (!s[3]) 
                    next_state = HIGH;
            end
            default: next_state = LOW;
        endcase
    end

    always @(posedge clk) begin
        if (current_state == HIGH && next_state == MID) 
            dfr <= 1;
        else
            dfr <= 0;
    end

endmodule