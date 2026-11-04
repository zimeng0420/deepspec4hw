module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);
    typedef enum reg [2:0] {IDLE, START_BIT, DATA_BITS, STOP_BIT} state_t;
    state_t current_state, next_state;
    reg [2:0] data_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 0;
            data_count <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        next_state = current_state;
        done = 0;
        case (current_state)
            IDLE: begin
                if (in == 0) begin // Start bit detected
                    next_state = START_BIT;
                end
            end
            
            START_BIT: begin
                next_state = DATA_BITS;
                data_count = 0;
            end
            
            DATA_BITS: begin
                if (data_count < 7) begin
                    data_count = data_count + 1;
                end else begin
                    next_state = STOP_BIT;
                end
            end
            
            STOP_BIT: begin
                if (in == 1) begin // Stop bit detected
                    done = 1; // Indicate that byte is received
                    next_state = IDLE;
                end else begin
                    next_state = STOP_BIT; // Wait for correct stop bit
                end
            end
        endcase
    end
endmodule