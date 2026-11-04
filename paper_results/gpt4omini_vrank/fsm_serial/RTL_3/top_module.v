module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE,     // Waiting for start bit
        START,    // Start bit detected
        RECV,     // Receiving data bits
        STOP,     // Stop bit verification
    } state_t;

    state_t state, next_state;
    reg [3:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            bit_count <= 4'b0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state; // Default to hold current state
        done = 1'b0;        // Default done signal

        case (state)
            IDLE: begin
                if (in == 1'b0) // Start bit detected
                    next_state = START;
            end
            
            START: begin
                bit_count = 4'b0; // Reset bit count
                next_state = RECV;
            end
            
            RECV: begin
                if (bit_count < 4'd8) begin
                    bit_count = bit_count + 1'b1; // Count data bits
                end else begin
                    next_state = STOP; // If 8 bits received, go to stop
                end
            end
            
            STOP: begin
                if (in == 1'b1) begin
                    done = 1'b1; // Stop bit is correct
                    next_state = IDLE; // Ready for next byte
                end else if (in == 1'b0) begin
                    // Keep waiting for a valid stop bit
                    next_state = STOP; 
                end
            end
            
            default: next_state = IDLE; // Safety case
        endcase
    end

endmodule