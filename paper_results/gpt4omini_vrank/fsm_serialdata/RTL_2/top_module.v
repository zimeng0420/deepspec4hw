module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);
    typedef enum logic [2:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;

    state_t current_state, next_state;
    logic [2:0] bit_count;

    // State transition
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            bit_count <= 3'b0;
            done <= 1'b0;
            out_byte <= 8'b0;
        end else begin
            current_state <= next_state;
            if (current_state == DATA) begin
                out_byte[bit_count] <= in;
                bit_count <= bit_count + 1;
            end
        end
    end

    // Next state logic
    always_comb begin
        next_state = current_state;
        done = 1'b0;
        case (current_state)
            IDLE: begin
                if (in == 1'b0) begin // Start bit detected
                    next_state = START;
                end
            end
            START: begin
                // Wait for the first data bit (assumes stable signal after start)
                next_state = DATA;
                bit_count = 3'b0;
            end
            DATA: begin
                if (bit_count == 3'd7) begin
                    next_state = STOP; // Last data bit received
                end
            end
            STOP: begin
                if (in == 1'b1) begin // Stop bit check passed
                    done = 1'b1;
                    next_state = IDLE; // Back to idle for the next byte
                end else begin
                    next_state = IDLE; // Go back to idle waiting for a valid start
                end
            end
        endcase
    end
endmodule