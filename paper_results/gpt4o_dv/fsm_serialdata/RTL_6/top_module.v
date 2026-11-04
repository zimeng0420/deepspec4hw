module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Define the states of the FSM
    typedef enum logic [2:0] {
        IDLE,       // Waiting for the start bit
        START,      // Start bit detected
        DATA,       // Receiving data bits
        STOP,       // Verifying stop bit
        ERROR       // Error in stop bit, waiting for valid stop
    } state_t;

    // State register and next-state logic
    state_t state, next_state;
    reg [2:0] bit_counter;        // Counter for data bits
    reg [7:0] shift_register;     // Temporary register for received data

    // Sequential block for state transition and register updates
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 3'b000;
            shift_register <= 8'b0;
            out_byte <= 8'b0;
            done <= 0;
        end else begin
            state <= next_state;
            if (state == DATA) begin
                shift_register <= {in, shift_register[7:1]};
                bit_counter <= bit_counter + 3'b001;
            end
            if (state == STOP && in == 1'b1) begin
                out_byte <= shift_register;
                done <= 1;
            end else begin
                done <= 0;
            end
        end
    end

    // Combinational logic for next-state logic
    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0) // Start bit detected
                    next_state = START;
            end
            START: begin
                next_state = DATA;
            end
            DATA: begin
                if (bit_counter == 3'b111) // All 8 bits received
                    next_state = STOP;
            end
            STOP: begin
                if (in == 1'b1)  // Check stop bit
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            ERROR: begin
                if (in == 1'b1) // Wait for valid stop bit
                    next_state = IDLE;
            end
        endcase
    end

endmodule