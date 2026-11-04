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
localparam State0 = 2'b00; // Below s[1]
localparam State1 = 2'b01; // Between s[2] and s[1]
localparam State2 = 2'b10; // Between s[3] and s[2]
localparam State3 = 2'b11; // Above s[3]

reg [1:0] current_state, next_state;

// State Transition Logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= State0; // Reset to low level state
        fr3 <= 1; fr2 <= 1; fr1 <= 1; dfr <= 1;
    end else begin
        current_state <= next_state;
    end
end

// Next State Logic
always @(*) begin
    case (current_state)
        State0: begin // below s[1]
            fr3 = 1; 
            fr2 = 1; 
            fr1 = 1; 
            dfr = 1; // Activate all
            if (s[1] && !s[2] && !s[3]) 
                next_state = State1; // Transition to State1
            else 
                next_state = State0;
        end
        State1: begin // between s[2] and s[1]
            fr3 = 0; 
            fr2 = 0; 
            fr1 = 1; 
            dfr = 0; // Activate fr1 only
            if (s[1] && s[2] && !s[3]) 
                next_state = State2; // Transition to State2
            else 
                next_state = (s[1] && !s[2]) ? State0 : State1; // Stay or go to State0
        end
        State2: begin // between s[3] and s[2]
            fr3 = 0; 
            fr2 = 0; 
            fr1 = 1; 
            dfr = 0; // Activate fr1 only
            if (s[3] && s[2] && !s[1]) 
                next_state = State3; // Transition to State3
            else 
                next_state = (s[2] && s[1]) ? State1 : State2; // Stay or go to State1
        end
        State3: begin // above s[3]
            fr3 = 0; 
            fr2 = 0; 
            fr1 = 0; 
            dfr = 0; // No flow
            next_state = (s[3] && s[2] && s[1]) ? State3 : State2; // Check for transition 
        end
        default: begin
            fr3 = 1; fr2 = 1; fr1 = 1; dfr = 1; // Defaults on reset
            next_state = State0;
        end
    endcase
end

endmodule