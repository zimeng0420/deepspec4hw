module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE    = 3'd0,
        START   = 3'd1,
        DATA    = 3'd2,
        STOP    = 3'd3,
        ERROR   = 3'd4
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_count; // 3 bits to count up to 8 data bits

    // Synchronous state transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        done = 1'b0; // Default done signal to 0
        case (state)
            IDLE: begin
                if (in == 1'b0) begin // Detect start bit
                    next_state = START;
                end
            end
            START: begin
                next_state = DATA;
                bit_count = 3'd0;
            end
            DATA: begin
                if (bit_count == 3'd7) begin // Check if last data bit received
                    next_state = STOP;
                end else begin
                    bit_count = bit_count + 3'd1;
                end
            end
            STOP: begin
                if (in == 1'b1) begin // Check stop bit
                    done = 1'b1;
                    next_state = IDLE; // Byte successfully received
                end else begin
                    next_state = ERROR; // Error in stop bit
                end
            end
            ERROR: begin
                if (in == 1'b1) begin // Wait for idle line
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule