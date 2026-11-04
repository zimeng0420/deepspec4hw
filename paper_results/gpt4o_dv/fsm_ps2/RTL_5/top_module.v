module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE = 2'b00,    // waiting for first byte
        BYTE1 = 2'b01,   // first byte received
        BYTE2 = 2'b10,   // second byte received
        BYTE3 = 2'b11    // third byte received
    } state_type;
    
    state_type state, next_state;
    reg [1:0] count;  // counter for the number of bytes received in a message

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
        end
        else begin
            state <= next_state;
        end
    end
    
    // Next state logic
    always @(*) begin
        done = 0;
        next_state = state; // Default to hold state
        case (state)
            IDLE: begin
                if (in[3] == 1) begin
                    next_state = BYTE1;
                end
            end
            BYTE1: begin
                next_state = BYTE2;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                done = 1;
                if (in[3] == 1) begin
                    next_state = BYTE1; // Acknowledge the next potential first byte
                end else begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule