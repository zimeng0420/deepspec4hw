module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting);

    // State encoding
    typedef enum reg [2:0] {
        S_IDLE   = 3'b000,
        S_1      = 3'b001,
        S_11     = 3'b010,
        S_110    = 3'b011,
        S_1101   = 3'b100
    } state_t;

    state_t current_state, next_state;

    // Sequential logic: State transitions
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S_IDLE;
            start_shifting <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic: Next state and output logic
    always @(*) begin
        case (current_state)
            S_IDLE: begin
                if (data) 
                    next_state = S_1;
                else 
                    next_state = S_IDLE;
                start_shifting = 0;
            end

            S_1: begin
                if (data) 
                    next_state = S_11;
                else 
                    next_state = S_IDLE;
                start_shifting = 0;
            end

            S_11: begin
                if (data) 
                    next_state = S_11;
                else 
                    next_state = S_110;
                start_shifting = 0;
            end

            S_110: begin
                if (data) 
                    next_state = S_1101;
                else 
                    next_state = S_IDLE;
                start_shifting = 0;
            end

            S_1101: begin
                next_state = S_1101; // Stay in this state
                start_shifting = 1;  // Setting output high
            end
            
            default: begin
                next_state = S_IDLE;
                start_shifting = 0;
            end
        endcase
    end
endmodule