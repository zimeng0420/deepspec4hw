module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);
    // State encoding
    typedef enum reg [2:0] {
        IDLE,
        START_BIT,
        DATA_BITS,
        STOP_BIT
    } state_t;
    
    state_t state, next_state;
    reg [3:0] bit_count;  // Counter for data bits

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Output and next state logic
    always @(*) begin
        next_state = state;
        out_byte = 8'b0;
        done = 0;

        case (state)
            IDLE: begin
                if (in == 0) 
                    next_state = START_BIT;  // Detect start bit
            end
            
            START_BIT: begin
                next_state = DATA_BITS; // Move to data bits after start bit
            end
            
            DATA_BITS: begin
                if (bit_count < 8) begin
                    out_byte[bit_count] = in; // Capture the data bit
                    bit_count = bit_count + 1;
                end else begin
                    next_state = STOP_BIT; // Go to stop bit after all data bits
                end
            end
            
            STOP_BIT: begin
                if (in == 1) begin
                    done = 1; // Assert done if stop bit is received
                    next_state = IDLE; // Go back to idle after done
                    bit_count = 0; // Reset bit count
                end else begin
                    next_state = STOP_BIT; // Wait for the correct stop bit
                end
            end
            
            default: next_state = IDLE;
        endcase
    end
endmodule