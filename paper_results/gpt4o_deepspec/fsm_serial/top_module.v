module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE        = 3'd0,
        START_BIT   = 3'd1,
        DATA_BITS   = 3'd2,
        STOP_BIT    = 3'd3,
        ERROR_STATE = 3'd4
    } state_t;

    state_t current_state, next_state;
    reg [2:0] bit_count;  // Counter for 8 data bits
    reg [7:0] shift_reg;  // Shift register to store 8 data bits

    // Sequential logic: State transition
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == DATA_BITS) begin
                bit_count <= bit_count + 1;
                shift_reg <= {in, shift_reg[7:1]}; // Shift in LSB first
            end else if (current_state != DATA_BITS) begin
                bit_count <= 0;
            end
        end
    end

    // Combinational logic: Next state logic and done signal
    always @(*) begin
        // Default assignments
        next_state = current_state;
        done = 0;

        case (current_state)
            IDLE: begin
                if (in == 0)  // Detect start bit
                    next_state = START_BIT;
            end

            START_BIT: begin
                next_state = DATA_BITS;  // Move to data reception state
            end

            DATA_BITS: begin
                if (bit_count == 7) begin // After 8 bits (0-7)
                    next_state = STOP_BIT;
                end
            end

            STOP_BIT: begin
                if (in == 1) begin // Verify stop bit
                    next_state = IDLE;
                    done = 1;        // Byte successfully received
                end else begin
                    next_state = ERROR_STATE; // Error detected
                end
            end

            ERROR_STATE: begin
                if (in == 1) // Wait for valid stop bit before starting over
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end
endmodule