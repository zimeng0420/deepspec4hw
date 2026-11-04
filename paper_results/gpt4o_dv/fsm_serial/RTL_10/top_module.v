module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // State encoding
    typedef enum reg [2:0] {
        IDLE = 3'b000,
        START_BIT = 3'b001,
        RECEIVE_BITS = 3'b010,
        STOP_BIT = 3'b011,
        ERROR = 3'b100
    } state_t;

    state_t state, next_state;
    reg [7:0] shift_reg;
    reg [3:0] bit_count; // To count 0 to 8

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            
            if (state == RECEIVE_BITS) begin
                shift_reg <= {in, shift_reg[7:1]};
                bit_count <= bit_count + 1;
            end
            
            if (state == STOP_BIT && in == 1) begin
                done <= 1;
            end else begin
                done <= 0;
            end
        end
    end

    always @(*) begin
        next_state = state; // Default to current state
        case (state)
            IDLE: begin
                if (in == 0) next_state = START_BIT;
            end

            START_BIT: begin
                next_state = RECEIVE_BITS;
            end

            RECEIVE_BITS: begin
                if (bit_count == 8)
                    next_state = STOP_BIT;
            end

            STOP_BIT: begin
                if (in == 1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end

            ERROR: begin
                if (in == 1)
                    next_state = IDLE;
            end
            
            default: begin
                next_state = IDLE; // Fallback to IDLE
            end
        endcase
    end

endmodule