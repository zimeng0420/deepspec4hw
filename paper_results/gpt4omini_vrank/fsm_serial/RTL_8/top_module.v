module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        START = 2'b01,
        DATA = 2'b10,
        STOP = 2'b11
    } state_t;

    state_t current_state, next_state;
    logic [3:0] bit_count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            bit_count <= 0;
            done <= 0;
        end else begin
            current_state <= next_state;
            if (next_state == DATA) begin
                bit_count <= bit_count + 1;
            end else if (next_state == IDLE && current_state == STOP) begin
                done <= 1;
            end else begin
                done <= 0;
            end
        end
    end

    always_comb begin
        case (current_state)
            IDLE: begin
                if (in == 0) begin
                    next_state = START;
                end else begin
                    next_state = IDLE;
                end
            end
            START: begin
                next_state = DATA;
            end
            DATA: begin
                if (bit_count == 8) begin
                    next_state = STOP;
                end else begin
                    next_state = DATA;
                end
            end
            STOP: begin
                if (in == 1) begin
                    next_state = IDLE;
                end else begin
                    next_state = STOP;
                end
            end
            default: next_state = IDLE;
        endcase
    end

endmodule