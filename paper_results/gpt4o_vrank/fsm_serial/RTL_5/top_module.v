module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // State encoding
    typedef enum reg [2:0] {
        IDLE = 3'b000,
        START = 3'b001,
        DATA = 3'b010,
        STOP = 3'b011,
        ERROR = 3'b100
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_count; // Counter for data bits

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b000;
            done <= 1'b0;
        end else begin
            state <= next_state;

            if (state == DATA) begin
                bit_count <= bit_count + 1;
            end else if (state != DATA) begin
                bit_count <= 3'b000;
            end

            if (state == STOP) begin
                done <= 1'b1; // Byte successfully received
            end else begin
                done <= 1'b0;
            end
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0) // Look for start bit
                    next_state = START;
                else
                    next_state = IDLE;
            end

            START: begin
                next_state = DATA;
            end

            DATA: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end

            STOP: begin
                if (in == 1'b1) // Verify stop bit
                    next_state = IDLE;
                else
                    next_state = ERROR; // Stay in ERROR until the line is 1
            end

            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule