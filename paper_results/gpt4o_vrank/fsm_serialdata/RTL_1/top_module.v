module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum logic [2:0] {
        IDLE = 3'b000,
        START = 3'b001,
        DATA = 3'b010,
        STOP = 3'b011,
        DONE = 3'b100,
        ERROR = 3'b101
    } state_t;

    state_t state, next_state;
    reg [3:0] bit_count; // To count the 8 data bits

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 4'd0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            if (state == DATA) begin
                out_byte[bit_count] <= in;
                bit_count <= bit_count + 1'b1;
            end else if (state == IDLE) begin
                bit_count <= 4'b0;
            end
            done <= (state == DONE) ? 1'b1 : 1'b0;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0) // Start bit detected
                    next_state = START;
            end
            START: begin
                if (in == 1'b0) // Still in start bit
                    next_state = DATA;
                else
                    next_state = ERROR; // False start, return to IDLE
            end
            DATA: begin
                if (bit_count == 4'd7) // All 8 data bits received
                    next_state = STOP;
            end
            STOP: begin
                if (in == 1'b1) // Correct stop bit
                    next_state = DONE;
                else
                    next_state = ERROR;
            end
            DONE: begin
                next_state = IDLE;
            end
            ERROR: begin
                if (in == 1'b1) // Wait until line goes to idle
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule