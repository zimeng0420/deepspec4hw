module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // State encoding
    typedef enum reg [3:0] {
        IDLE            = 4'd0,  // Idle state
        START_BIT       = 4'd1,  // Waiting for start bit
        DATA_BIT_0      = 4'd2,  // Receiving data bit 0
        DATA_BIT_1      = 4'd3,  // Receiving data bit 1
        DATA_BIT_2      = 4'd4,  // Receiving data bit 2
        DATA_BIT_3      = 4'd5,  // Receiving data bit 3
        DATA_BIT_4      = 4'd6,  // Receiving data bit 4
        DATA_BIT_5      = 4'd7,  // Receiving data bit 5
        DATA_BIT_6      = 4'd8,  // Receiving data bit 6
        DATA_BIT_7      = 4'd9,  // Receiving data bit 7
        STOP_BIT        = 4'd10, // Waiting for stop bit
        DONE            = 4'd11, // Successful byte reception
        ERROR           = 4'd12  // Error state
    } state_t;
    
    state_t current_state, next_state;
    
    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end
    
    // Next state logic
    always @(*) begin
        done = 0;
        case (current_state)
            IDLE: begin
                if (in == 0)
                    next_state = START_BIT;
                else
                    next_state = IDLE;
            end
            START_BIT: begin
                next_state = DATA_BIT_0;
            end
            DATA_BIT_0: begin
                next_state = DATA_BIT_1;
            end
            DATA_BIT_1: begin
                next_state = DATA_BIT_2;
            end
            DATA_BIT_2: begin
                next_state = DATA_BIT_3;
            end
            DATA_BIT_3: begin
                next_state = DATA_BIT_4;
            end
            DATA_BIT_4: begin
                next_state = DATA_BIT_5;
            end
            DATA_BIT_5: begin
                next_state = DATA_BIT_6;
            end
            DATA_BIT_6: begin
                next_state = DATA_BIT_7;
            end
            DATA_BIT_7: begin
                next_state = STOP_BIT;
            end
            STOP_BIT: begin
                if (in == 1) begin
                    next_state = DONE;
                    done = 1;
                end else begin
                    next_state = ERROR;
                end
            end
            ERROR: begin
                if (in == 1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            DONE: begin
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule