module top_module(
    input clk,
    input reset,
    input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack
);

    typedef enum reg [2:0] {
        IDLE = 3'd0,
        DETECT_1 = 3'd1,
        DETECT_11 = 3'd2,
        DETECT_110 = 3'd3,
        DETECT_1101 = 3'd4,
        SHIFT = 3'd5,
        COUNT = 3'd6,
        WAIT_ACK = 3'd7
    } state_t;

    state_t state, next_state;
    reg [2:0] shift_count;

    // Sequential state update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;
            if (shift_ena)
                shift_count <= shift_count + 1;
            else
                shift_count <= 3'd0;
        end
    end

    // Combinational logic for state transition
    always @(*) begin
        next_state = state;
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case (state)
            IDLE: begin
                if (data) next_state = DETECT_1;
            end

            DETECT_1: begin
                next_state = data ? DETECT_11 : IDLE;
            end

            DETECT_11: begin
                next_state = data ? DETECT_11 : DETECT_110;
            end

            DETECT_110: begin
                next_state = data ? DETECT_1101 : IDLE;
            end
            
            DETECT_1101: begin
                if (data) begin
                    next_state = SHIFT;
                    shift_ena = 1'b1;
                end else begin
                    next_state = DETECT_1;
                end
            end

            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_count == 3'd3)
                    next_state = COUNT;
            end

            COUNT: begin
                counting = 1'b1;
                if (done_counting)
                    next_state = WAIT_ACK;
            end

            WAIT_ACK: begin
                done = 1'b1;
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end

endmodule