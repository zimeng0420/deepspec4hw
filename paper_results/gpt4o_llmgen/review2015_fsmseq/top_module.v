module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding
    typedef enum reg [2:0] {
        IDLE = 3'b000,
        S1 = 3'b001,
        S11 = 3'b010,
        S110 = 3'b011,
        DETECT = 3'b100
    } state_t;
    
    state_t current_state, next_state;
    
    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end
    
    // Next state logic and output logic
    always @(*) begin
        // Default assignments
        next_state = current_state;
        start_shifting = (current_state == DETECT);
        
        case (current_state)
            IDLE: begin
                if (data == 1) begin
                    next_state = S1;
                end
            end
            S1: begin
                if (data == 1) begin
                    next_state = S11;
                end else begin
                    next_state = IDLE;
                end
            end
            S11: begin
                if (data == 0) begin
                    next_state = S110;
                end
            end
            S110: begin
                if (data == 1) begin
                    next_state = DETECT;
                end else begin
                    next_state = IDLE;
                end
            end
            DETECT: begin
                // Remain in DETECT state unless reset occurs
            end
        endcase
    end
    
endmodule