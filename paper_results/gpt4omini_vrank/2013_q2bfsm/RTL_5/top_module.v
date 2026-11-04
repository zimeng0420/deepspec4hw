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
        STATE_B,
        STATE_C,
        STATE_D
    } state_t;

    state_t current_state, next_state;
    logic [2:0] x_sequence; // For checking 1, 0, 1 sequence
    logic [1:0] y_count;

    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= STATE_A;
            f <= 0;
            g <= 0;
            x_sequence <= 3'b000;
            y_count <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        if (current_state == STATE_B) begin
            f <= 1;
        end else begin
            f <= 0;
        end
    end

    always_ff @(posedge clk) begin
        if (current_state == STATE_C) begin
            x_sequence <= {x_sequence[1:0], x}; // Shift in current x value
            if (x_sequence == 3'b101) begin
                next_state <= STATE_D;
            end
        end
    end

    always_ff @(posedge clk) begin
        if (current_state == STATE_D) begin
            g <= 1;
            if (y_count < 2) begin
                if (y) begin
                    y_count <= 2; // Keep g = 1 permanently
                end else begin
                    y_count <= y_count + 1;
                end
            end else begin
                if (!y) begin
                    g <= 0; // G becomes 0 if y doesn't assert
                end
            end
        end
    end

    always_ff @(posedge clk) begin
        case (current_state)
            STATE_A: begin
                if (!resetn) begin
                    next_state <= STATE_A;
                end else begin
                    next_state <= STATE_B; // After reset
                end
            end

            STATE_B: begin
                next_state <= STATE_C; // Move to monitoring state after f is set
            end

            STATE_C: begin
                next_state <= current_state; // Remain in monitoring state
            end

            STATE_D: begin
                // Remain in this state as long as g is set
                next_state <= current_state;
            end
        endcase
    end
endmodule