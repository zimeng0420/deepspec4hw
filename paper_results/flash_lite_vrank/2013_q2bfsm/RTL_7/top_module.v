module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output f,
	output g
);

    parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G = 6, H = 7, I = 8;

    reg [2:0] state, next_state;
    reg [1:0] x_history;
    reg y_observed;

    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        f = 0;
        g = 0;
        y_observed = 0;

        case (state)
            A: begin
                if (!resetn) begin
                    next_state = A;
                end else {
                    f = 1;
                    next_state = B;
                }
            end
            B: begin
                f = 0;
                x_history = {x_history[0], x};
                if (x_history == 2'b10)
                    next_state = C;
                else
                    next_state = B;
            end
            C: begin
                x_history = {x_history[0], x};
                if (x_history == 2'b01)
                    next_state = D;
                else
                    next_state = B;
            end

            D: begin
                g = 1;
                next_state = E;

            end
            E: begin
                g = 1;
                if (y) begin
                    next_state = G;
                end
                else
                begin
                  next_state = F;
                end

            end
            F: begin
                g = 0;
                if (y)
                   next_state = G;
                else
                  next_state = F;
            end
            G: begin
                g = 1;
            end

        endcase
    end
endmodule