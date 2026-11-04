module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

    reg [1:0] state, next_state;
    
    parameter LOW     = 2'b00;  // Below s[1]
    parameter MID     = 2'b01;  // Between s[2] and s[1]
    parameter HIGH    = 2'b10;  // Between s[3] and s[2]
    parameter ABOVE   = 2'b11;  // Above s[3]
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= LOW;
            fr3 <= 1;
            fr2 <= 1;
            fr1 <= 1;
            dfr <= 0;
        end else begin
            state <= next_state;
        end
    end
    
    always @(*) begin
        case (state)
            LOW: begin
                if (s[1] == 0) begin
                    fr3 = 1; 
                    fr2 = 1; 
                    fr1 = 1; 
                    dfr = 1; 
                    next_state = LOW;
                end else begin
                    next_state = MID;
                end
            end
            MID: begin
                fr3 = 0; 
                fr2 = 1; 
                fr1 = 1; 
                dfr = 0; 
                if (s[2] == 0) begin
                    next_state = HIGH;
                end else if (s[1] == 1) begin
                    next_state = LOW;
                end else begin
                    next_state = MID;
                end
            end
            HIGH: begin
                fr3 = 0; 
                fr2 = 1; 
                fr1 = 1; 
                dfr = (s[1] == 0) ? 1 : 0; 
                if (s[3] == 0) begin
                    next_state = ABOVE;
                end else begin
                    next_state = MID;
                end
            end
            ABOVE: begin
                fr3 = 0; 
                fr2 = 0; 
                fr1 = 0; 
                dfr = 0; 
                if (s[3] == 1) begin
                    next_state = HIGH;
                end else begin
                    next_state = ABOVE;
                end
            end
            default: begin
                next_state = LOW;
            end
        endcase
    end
endmodule