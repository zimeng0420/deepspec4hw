module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;
    
    state_t current_state, next_state;
    reg [7:0] data;
    integer bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 0;
            bit_count <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        done = 0; // Default done value
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (in == 0) // Start bit detected
                    next_state = START;
            end
            
            START: begin
                next_state = DATA; // Move to DATA state
                bit_count = 0; // Reset bit counter
            end
            
            DATA: begin
                if (bit_count < 8) begin
                    data[bit_count] = in; // Receive data bit
                    bit_count = bit_count + 1;
                end else begin
                    next_state = STOP; // Move to STOP state after 8 bits
                end
            end
            
            STOP: begin
                if (in == 1) begin // Stop bit verified
                    done = 1; // Indicate a byte has been received
                    next_state = IDLE; // Move back to IDLE
                end 
                // If in is not 1, remain in STOP state waiting for valid stop bit
            end
        endcase
    end
endmodule