module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // State Encoding
    typedef enum logic [2:0] {
        IDLE      = 3'b000,
        START     = 3'b001,
        RECEIVE   = 3'b010,
        STOP      = 3'b011,
        ERROR     = 3'b100
    } state_t;

    state_t current_state, next_state;
    reg [2:0] bit_counter;       // Counter for 8 data bits
    reg [7:0] data_shift_reg;    // Shift register for 8 data bits
    reg prev_in;

    // Sequential logic for state transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            bit_counter <= 3'b000;
            data_shift_reg <= 8'b0;
            prev_in <= 1'b1;
        end
        else begin
            current_state <= next_state;
            prev_in <= in;
            if (current_state == RECEIVE) begin
                data_shift_reg <= {in, data_shift_reg[7:1]}; // Shift in LSB first
                bit_counter <= bit_counter + 1;
            end
            else if (current_state == STOP || current_state == ERROR) begin
                bit_counter <= 3'b000;
            end
        end
    end

    // Combinational logic for next state logic
    always @(*) begin
        done = 1'b0;
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (prev_in == 1 && in == 0) // Detect start bit
                    next_state = START;
            end
            START: begin
                next_state = RECEIVE;
            end
            RECEIVE: begin
                if (bit_counter == 3'b111) // After 8 data bits
                    next_state = STOP;
            end
            STOP: begin
                if (in == 1) begin
                    done = 1'b1;
                    next_state = IDLE; // Correct stop bit, go to IDLE
                end
                else begin
                    next_state = ERROR; // Incorrect stop bit, go to ERROR
                end
            end
            ERROR: begin
                if (in == 1) // Wait for line to return to idle
                    next_state = IDLE;
            end
        endcase
    end

endmodule