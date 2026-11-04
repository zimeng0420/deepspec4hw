module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    reg [2:0] state, next_state;
    reg [1:0] y_counter;
    reg [2:0] x_seq;

    localparam STATE_A = 3'b000,
               STATE_B = 3'b001,
               STATE_C = 3'b010,
               STATE_D = 3'b011,
               STATE_E = 3'b100,
               STATE_F = 3'b101;

    // State transition logic
    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
            f <= 0;
            g <= 0;
            x_seq <= 3'b000;
            y_counter <= 2'b00;
        end
        else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            STATE_A: begin
                f = 1;
                g = 0;
                next_state = STATE_B;
            end
            STATE_B: begin
                f = 0;
                g = 0;
                if (x)
                    x_seq <= {x_seq[1:0], x};
                if (x_seq == 3'b101)
                    next_state = STATE_C;
                else
                    next_state = STATE_B;
            end
            STATE_C: begin
                g = 1;
                y_counter <= 0;
                next_state = STATE_D;
            end
            STATE_D: begin
                g = 1;
                y_counter <= y_counter + 1;
                if (y) begin
                    next_state = STATE_E;
                end else if (y_counter == 2) begin
                    next_state = STATE_F;
                end else begin
                    next_state = STATE_D;
                end
            end
            STATE_E: begin
                g = 1;
                next_state = STATE_E;
            end
            STATE_F: begin
                g = 0;
                next_state = STATE_F;
            end
            default: begin
                f = 0;
                g = 0;
                next_state = STATE_A;
            end
        endcase
    end

endmodule