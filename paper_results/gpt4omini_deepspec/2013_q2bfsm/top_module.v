module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    typedef enum reg [1:0] {
        STATE_A = 2'b00,
        STATE_1 = 2'b01,
        STATE_0 = 2'b10,
        STATE_DONE = 2'b11
    } state_t;

    state_t current_state, next_state;
    reg [1:0] y_count;
    reg detect_seq;

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= STATE_A;
            f <= 0;
            g <= 0;
            y_count <= 0;
            detect_seq <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == STATE_A) begin
                f <= 1;
            end else begin
                f <= 0;
            end
        end
    end

    always @(*) begin
        case (current_state)
            STATE_A: begin
                if (f == 1) begin
                    next_state = STATE_1;
                    detect_seq = 0;
                end else begin
                    next_state = STATE_A;
                end
            end

            STATE_1: begin
                if (x) begin
                    next_state = STATE_0;
                end else begin
                    next_state = STATE_A;
                end
            end

            STATE_0: begin
                if (!x) begin
                    next_state = STATE_DONE;
                end else begin
                    next_state = STATE_A;
                end
            end

            STATE_DONE: begin
                detect_seq = 1;
                if (y) begin
                    g <= 1;
                end else begin
                    if (y_count < 2) begin
                        y_count = y_count + 1;
                        next_state = STATE_DONE;
                    end else begin
                        g <= 0;
                        next_state = STATE_A;
                    end
                end
            end

            default: begin
                next_state = STATE_A;
            end
        endcase
    end

endmodule