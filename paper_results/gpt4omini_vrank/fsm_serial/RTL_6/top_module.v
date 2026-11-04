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
        STOP,
        CHECK_STOP
    } state_t;

    state_t state, next_state;
    logic [7:0] data_reg;
    logic [3:0] bit_count;

    assign done = (state == CHECK_STOP && in == 1);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_reg <= 0;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 0) begin
                    next_state = START;
                end
            end
            START: begin
                next_state = DATA;
            end
            DATA: begin
                if (bit_count < 8) begin
                    data_reg[bit_count] = in; // collect data bits
                    bit_count = bit_count + 1;
                end else begin
                    next_state = CHECK_STOP;
                end
            end
            CHECK_STOP: begin
                if (in == 1) begin
                    next_state = IDLE;
                    bit_count = 0; // reset count after a complete byte
                end else begin
                    next_state = STOP; // wait for correct stop bit
                end
            end
            STOP: begin
                if (in == 1) begin
                    next_state = IDLE;
                    bit_count = 0; // move to idle since stop bit is detected
                end else begin
                    next_state = STOP; // continue waiting
                end
            end
            default: next_state = IDLE; // default for safety
        endcase
    end

endmodule