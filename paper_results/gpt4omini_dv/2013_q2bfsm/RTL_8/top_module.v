module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    reg [2:0] state, next_state;
    reg [1:0] count_y; // Count for y inputs
    reg sequence_done;

    localparam A = 3'b000,
               S1 = 3'b001,
               S0 = 3'b010,
               S2 = 3'b011;

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= A;
            f <= 0;
            g <= 0;
            count_y <= 0;
            sequence_done <= 0;
        end else begin
            state <= next_state;
            if (sequence_done) 
                count_y <= count_y + 1;
            else 
                count_y <= 0;

            if (state == A) begin
                f <= 1;
            end else begin
                f <= 0;
            end

            if (state == S2 && count_y < 2) begin
                g <= 1;
            end else if (count_y >= 2) begin
                g <= 0;
            end
        end
    end

    always @(*) begin
        case (state)
            A: begin
                if (!resetn) next_state = A;
                else next_state = (x) ? S1 : A;
            end
            S1: begin
                next_state = (x) ? S1 : S0;
            end
            S0: begin
                next_state = (x) ? S2 : A;
            end
            S2: begin
                if (y) begin
                    g <= 1;
                    next_state = S2; // Stay in S2
                end else if (count_y < 2) begin
                    next_state = S2; // Stay in S2
                end else begin
                    next_state = A; // Reset to A
                end
            end
            default: next_state = A;
        endcase
    end

endmodule