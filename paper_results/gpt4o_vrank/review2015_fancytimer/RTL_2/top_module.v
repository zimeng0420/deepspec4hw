module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    // State Encoding
    typedef enum reg [2:0] {
        IDLE,
        DETECT_PATTERN,
        SHIFT_DELAY,
        COUNTING,
        WAIT_FOR_ACK
    } state_t;
    
    state_t current_state, next_state;
    
    reg [3:0] delay;
    reg [3:0] bit_count;
    reg [13:0] cycle_count;
    
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        next_state = current_state;
        counting = 0;
        done = 0;
        
        case (current_state)
            IDLE: begin
                bit_count = 0;
                cycle_count = 0;
                if (data == 1 && bit_count == 0) bit_count = bit_count + 1;
                else if (data == 1 && bit_count == 1) next_state = DETECT_PATTERN;
            end
            
            DETECT_PATTERN: begin
                if (data == 1 && bit_count == 2) bit_count = bit_count + 1;
                else if (data == 0 && bit_count == 3) bit_count = bit_count + 1;
                else if (data == 1 && bit_count == 4) next_state = SHIFT_DELAY;
                else bit_count = 0;
            end
            
            SHIFT_DELAY: begin
                if (bit_count < 4) begin
                    delay = {delay[2:0], data};
                    bit_count = bit_count + 1;
                end else begin
                    next_state = COUNTING;
                    cycle_count = (delay + 1) * 1000;
                end
            end
            
            COUNTING: begin
                counting = 1;
                count = cycle_count[13:10]; // Remaining time (approximated)
                if (cycle_count == 0) begin
                    next_state = WAIT_FOR_ACK;
                    done = 1;
                    count = 4'bxxxx; // Don't-care when done
                end else begin
                    cycle_count = cycle_count - 1;
                end
            end
            
            WAIT_FOR_ACK: begin
                done = 1;
                if (ack) next_state = IDLE;
            end
        endcase
    end

endmodule