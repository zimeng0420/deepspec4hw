module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // State encoding
    typedef enum reg [2:0] {
        IDLE        = 3'b000,
        START_BIT   = 3'b001,
        DATA_BITS   = 3'b010,
        STOP_BIT    = 3'b011,
        ERROR_STATE = 3'b100
    } state_t;

    reg [2:0] state, next_state;
    reg [2:0] bit_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 3'b000;
            done <= 0;
        end else begin
            state <= next_state;
            if (state == DATA_BITS) begin
                bit_counter <= bit_counter + 1;
            end else begin
                bit_counter <= 3'b000;
            end
        end
    end

    always @(*) begin
        done = 0;
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 0)           // Start bit detected
                    next_state = START_BIT;
            end

            START_BIT: begin
                next_state = DATA_BITS; // Move to data reception
            end

            DATA_BITS: begin
                if (bit_counter == 3'b111) // After receiving 8 data bits
                    next_state = STOP_BIT;
            end

            STOP_BIT: begin
                if (in == 1) begin     // Check for correct stop bit
                    done = 1;          // Mark the completion
                    next_state = IDLE; // Ready for next byte
                end else begin
                    next_state = ERROR_STATE; // Error: Stop bit not detected
                end
            end

            ERROR_STATE: begin
                if (in == 1)           // Wait for line to return to idle
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end
endmodule