module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);
    typedef enum reg [2:0] {
        STATE_A,
        STATE_B,
        STATE_X1,
        STATE_X0,
        STATE_X1_READY,
        STATE_G1,
        STATE_WAIT_Y1,
        STATE_WAIT_Y0
    } state_t;

    state_t state, next_state;
    reg [1:0] x_count;
    reg y_signal_received;

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= STATE_A;
            f <= 0;
            g <= 0;
            x_count <= 0;
            y_signal_received <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(state or x or y) begin
        next_state = state;
        case (state)
            STATE_A: begin
                f = 0;
                g = 0;
                x_count = 0;
                y_signal_received = 0;
                next_state = STATE_B;
            end
            STATE_B: begin
                f = 1;
                next_state = STATE_X1;
            end
            STATE_X1: begin
                f = 0;
                if (x) begin
                    x_count = 1;
                    next_state = STATE_X1_READY;
                end else begin
                    next_state = STATE_X0;
                end
            end
            STATE_X0: begin
                f = 0;
                if (!x) begin
                    x_count = 0;
                    next_state = STATE_X1;
                end
                else if (x) begin
                    x_count = 0;
                    next_state = STATE_X1_READY;
                end
            end
            STATE_X1_READY: begin
                if (x) begin
                    next_state = STATE_G1;
                end else begin
                    x_count = 0;
                    next_state = STATE_X0;
                end
            end
            STATE_G1: begin
                g = 1;
                y_signal_received = 0;
                if (y) begin
                    y_signal_received = 1;
                    next_state = STATE_WAIT_Y1;
                end else begin
                    next_state = STATE_WAIT_Y0;
                end
            end
            STATE_WAIT_Y1: begin
                g = 1;
                if (y) begin
                    y_signal_received = 1;
                end else begin
                    next_state = STATE_WAIT_Y0;
                end
            end
            STATE_WAIT_Y0: begin
                g = 0;
                if (!y_signal_received) begin
                    next_state = STATE_WAIT_Y1;
                end
            end
        endcase
    end
endmodule