module top_module (
    input clk,
    input in,
    input reset,
    output done
);
    typedef enum logic [2:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;

    state_t current_state, next_state;
    logic [3:0] bit_count;  // Count of received bits

    assign done = (current_state == STOP) && (bit_count == 8);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            bit_count <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        if (current_state == DATA) begin
            if (bit_count < 8) 
                bit_count <= bit_count + 1;
            else 
                bit_count <= 0; // Reset count after receiving 8 bits
        end
    end

    always_comb begin
        next_state = current_state; // Default to hold current state

        case (current_state)
            IDLE: begin
                if (in == 0) // Detect start bit
                    next_state = START;
            end

            START: begin
                next_state = DATA; // Move to data state after start bit
            end

            DATA: begin
                if (bit_count == 7) // After receiving 8 data bits
                    next_state = STOP;
            end

            STOP: begin
                if (in == 1) // Check for stop bit
                    next_state = IDLE; // Successfully received byte
                else if (in == 0) 
                    next_state = START; // Restart if no stop bit
            end
        endcase
    end
endmodule