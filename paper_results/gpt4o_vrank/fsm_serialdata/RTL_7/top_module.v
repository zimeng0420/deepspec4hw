module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE = 3'b000,
        START = 3'b001,
        RECEIVE = 3'b010,
        STOP = 3'b011,
        ERROR = 3'b100
    } state_t;
    
    state_t current_state, next_state;
    reg [2:0] bit_counter; // Counter for 8 data bits
    reg [7:0] shift_reg; // To accumulate the bits

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            bit_counter <= 3'b000;
            shift_reg <= 8'b0;
            done <= 1'b0;
            out_byte <= 8'b0;
        end else begin
            current_state <= next_state;
            if (next_state == RECEIVE) begin
                shift_reg <= {in, shift_reg[7:1]}; // Shift in the received data
            end
            if (next_state == STOP && current_state == RECEIVE) begin
                out_byte <= shift_reg; // Latch the received byte
            end
        end
    end

    always @(*) begin
        done = 1'b0; // Default value
        next_state = current_state; // Default to stay in the current state
        case (current_state)
            IDLE: begin
                if (in == 1'b0) next_state = START; // Detected start bit
            end
            START: begin
                next_state = RECEIVE;
                bit_counter = 3'b000;
            end
            RECEIVE: begin
                if (bit_counter == 3'b111) begin // After 8 bits
                    next_state = (in == 1'b1) ? STOP : ERROR; // Check stop bit
                end else begin
                    bit_counter = bit_counter + 1'b1;
                end
            end
            STOP: begin
                done = 1'b1; // Byte correctly received
                next_state = (in == 1'b1) ? IDLE : ERROR; // Wait for idle state
            end
            ERROR: begin
                if (in == 1'b1) next_state = IDLE; // Wait for the line to be idle
            end
        endcase
    end

endmodule