module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE = 3'b000,
        START = 3'b001,
        DATA = 3'b010,
        STOP = 3'b011,
        CHECK_STOP = 3'b100
    } state_t;

    state_t current_state, next_state;
    reg [3:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 0;
            bit_count <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == DATA) begin
                bit_count <= bit_count + 1;
            end else if (next_state == IDLE) begin
                bit_count <= 0;
            end
        end
    end

    always @* begin
        next_state = current_state;
        done = 0;
        
        case (current_state)
            IDLE: begin
                if (in == 0) begin // Start bit detected
                    next_state = START;
                end
            end

            START: begin
                next_state = DATA; // Move to DATA state after start bit
            end

            DATA: begin
                if (bit_count == 8) begin // 8 bits received
                    next_state = CHECK_STOP;
                end
            end

            CHECK_STOP: begin
                if (in == 1) begin // Stop bit detected
                    done = 1; // Byte completed
                    next_state = IDLE; // Go back to IDLE to wait for next byte
                end else begin
                    next_state = CHECK_STOP; // Wait for stop bit if not received
                end
            end

            default: next_state = IDLE; // Fallback
        endcase
    end

endmodule