module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // State encoding
    typedef enum reg [2:0] {
        IDLE,
        START,
        DATA,
        STOP,
        ERROR
    } state_t;
    
    state_t current_state, next_state;
    reg [3:0] bit_counter;  // 4 bits to count from 0 to 9 (1 start + 8 data + 1 stop)
    reg [7:0] byte_data;    // Shift register to store the received byte

    // State transition logic (synchronous)
    always @(posedge clk) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next state logic and output logic (combinational)
    always @(*) begin
        // Default assignments
        next_state = current_state;
        done = 0;

        case (current_state)
            IDLE: begin
                if (in == 0)  // Detect start bit
                    next_state = START;
            end

            START: begin
                if (in == 0)  // Confirm start bit
                    next_state = DATA;
                bit_counter = 0;  // Reset bit counter
            end

            DATA: begin
                if (bit_counter < 8) begin
                    byte_data = {in, byte_data[7:1]};  // Shift in data, LSB first
                    bit_counter = bit_counter + 1;
                end else begin
                    next_state = STOP;
                end
            end

            STOP: begin
                if (in == 1) begin  // Verify stop bit
                    done = 1;  // Successfully received a byte
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;
                end
            end

            ERROR: begin
                if (in == 1)  // Wait for line to return to idle state (stop bit found)
                    next_state = IDLE;
            end

        endcase
    end

endmodule