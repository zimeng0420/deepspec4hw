module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    typedef enum logic [2:0] {
        IDLE         = 3'b000,
        START_BIT    = 3'b001,
        RECEIVE_DATA = 3'b010,
        STOP_BIT     = 3'b011,
        ERROR        = 3'b100
    } state_t;
    
    state_t state, next_state;
    reg [2:0] bit_counter;
    reg [7:0] shift_register;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            bit_counter <= 0;
            shift_register <= 8'b0;
        end else begin
            state <= next_state;
            if (state == RECEIVE_DATA) begin
                shift_register <= {in, shift_register[7:1]};
            end
        end
    end

    always @(*) begin
        done = 0; // Default value
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 0) // Detect start bit
                    next_state = START_BIT;
            end
            START_BIT: begin
                next_state = RECEIVE_DATA;
                bit_counter = 0;
            end
            RECEIVE_DATA: begin
                bit_counter = bit_counter + 1;
                if (bit_counter == 7)
                    next_state = STOP_BIT;
            end
            STOP_BIT: begin
                if (in == 1) begin // Verify stop bit
                    done = 1;
                    next_state = IDLE;
                end else
                    next_state = ERROR;
            end
            ERROR: begin
                if (in == 1)
                    next_state = IDLE; // Wait for line to return to idle
            end
        endcase
    end

endmodule