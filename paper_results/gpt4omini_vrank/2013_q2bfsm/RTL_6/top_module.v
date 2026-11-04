module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    typedef enum logic [1:0] {
        STATE_A,
        STATE_F_ONE,
        STATE_MONITOR_X,
        STATE_MONITOR_Y_G_ONE,
        STATE_Y_DELAY,
        STATE_G_ZERO
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= STATE_A;
            f <= 0;
            g <= 0;
        end else begin
            state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        if (state == STATE_F_ONE) begin
            f <= 1;
        end else begin
            f <= 0;
        end
    end

    always_ff @(posedge clk) begin
        if (state == STATE_MONITOR_X) begin
            if (x == 1) begin
                next_state <= STATE_Y_DELAY;
            end else begin
                next_state <= STATE_MONITOR_X;
            end
        end else if (state == STATE_Y_DELAY) begin
            if (next_state == STATE_MONITOR_Y_G_ONE) begin
                g <= 1;
            end
            if (y == 1) begin
                next_state <= STATE_MONITOR_Y_G_ONE;
            end else begin
                next_state <= STATE_G_ZERO; // g = 0 after 2 clock cycles
            end
        end else if (state == STATE_MONITOR_Y_G_ONE) begin
            if (y == 0) begin
                next_state <= STATE_Y_DELAY;
            end
        end else if (state == STATE_G_ZERO) begin
            g <= 0;
        end else begin
            case (state)
                STATE_A: next_state <= STATE_F_ONE;
                STATE_F_ONE: next_state <= STATE_MONITOR_X;
                default: next_state <= STATE_A;
            endcase
        end
    end

endmodule