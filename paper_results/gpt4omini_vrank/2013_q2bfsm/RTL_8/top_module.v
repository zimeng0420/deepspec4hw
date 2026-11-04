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
        STATE_B = 2'b01,
        STATE_C = 2'b10,
        STATE_D = 2'b11
    } state_t;

    state_t current_state, next_state;
    reg [1:0] x_count;
    reg y_flag;

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= STATE_A;
            f <= 0;
            g <= 0;
            x_count <= 0;
            y_flag <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        next_state = current_state;
        case (current_state)
            STATE_A: begin
                f = 0;
                g = 0;
                x_count = 0;
                y_flag = 0;
                if (!resetn) begin
                    next_state = STATE_B;
                end
            end
            STATE_B: begin
                f = 1;
                g = 0;
                next_state = STATE_C;
            end
            STATE_C: begin
                f = 0;
                if (x == 1) begin
                    x_count = 1;
                end else if (x == 0 && x_count == 1) begin
                    x_count = 2;
                end else if (x == 1 && x_count == 2) begin
                    g = 1;
                    next_state = STATE_D;
                end else begin
                    x_count = 0;
                end
            end
            STATE_D: begin
                if (y_flag < 2) begin
                    if (y == 1) begin
                        g = 1;
                        y_flag = 2; // Stay in STATE_D
                    end else begin
                        y_flag = y_flag + 1;
                    end
                end else begin
                    g = 0; // Reset g if y was never 1 within 2 cycles
                end
            end
        endcase
    end
endmodule