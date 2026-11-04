module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE = 3'b000,
        START_BIT = 3'b001,
        DATA_BITS = 3'b010,
        STOP_BIT = 3'b011,
        SUCCESS = 3'b100,
        ERROR = 3'b101
    } state_t;

    reg [2:0] state, next_state;
    reg [2:0] bit_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 3'b000;
        end 
        else begin
            state <= next_state;
            if (state == DATA_BITS && state != next_state) begin
                bit_counter <= bit_counter + 3'b001;
            end
            else if (state != DATA_BITS) begin
                bit_counter <= 3'b000;
            end
        end
    end

    always @(*) begin
        next_state = state;
        done = 0;
        case (state)
            IDLE: begin
                if (in == 0) next_state = START_BIT; // Detect start bit
            end
            START_BIT: begin
                next_state = DATA_BITS;
            end
            DATA_BITS: begin
                if (bit_counter == 3'b111) begin // After 8 bits
                    next_state = STOP_BIT;
                end
            end
            STOP_BIT: begin
                if (in == 1) begin
                    next_state = SUCCESS; // Correct stop bit
                end else begin
                    next_state = ERROR; // Incorrect stop bit
                end
            end
            SUCCESS: begin
                done = 1;
                next_state = IDLE; // Wait for the next byte
            end
            ERROR: begin
                if (in == 1) next_state = IDLE; // Wait for line to return to idle
            end
        endcase
    end

endmodule