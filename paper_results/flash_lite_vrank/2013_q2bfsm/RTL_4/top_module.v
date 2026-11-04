module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output f,
	output g
);

    // State Definitions
    parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G = 6, H = 7;

    // State Register
    reg [2:0] state;

    // Internal Signals
    reg f_reg;
    reg g_reg;
    reg [2:0] x_history;
    reg y_seen;
    reg [1:0] y_count;

    // State Transition Logic
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= A;
            f_reg <= 0;
            g_reg <= 0;
            x_history <= 3'b000;
            y_seen <= 0;
            y_count <= 0;
        end else begin
            case (state)
                A: begin
                    f_reg <= 0;
                    g_reg <= 0;
                    if (f_reg == 0) begin
                      state <= B;
                    end
                end
                B: begin
                    f_reg <= 1;
                    g_reg <= 0;
                    state <= C;

                end
                C: begin
                    f_reg <= 0;
                    g_reg <= 0;
                    x_history <= {x_history[1:0], x};
                    if (x_history == 3'b101) begin
                        state <= D;
                    end
                end
                D: begin
                    f_reg <= 0;
                    g_reg <= 1;
                    state <= E;
                end
                E: begin
                    f_reg <= 0;
                    if (y) begin
                        g_reg <= 1;
                        state <= H;
                    end
                    else if (y_count == 2) begin
                        g_reg <= 0;
                        state <= G;

                    end
                    else begin
                      g_reg <= 1;
                      state <= F;
                    end
                end
                F: begin
                    f_reg <= 0;
                    if (y) begin
                        g_reg <= 1;
                        state <= H;
                    end
                    else if (y_count == 2) begin
                      g_reg <= 0;
                      state <= G;
                    end
                    else begin
                      g_reg <= 1;
                      state <= F;
                    end
                end
                G: begin
                    f_reg <= 0;
                    g_reg <= 0;
                    state <= G;
                end
                H: begin
                    f_reg <= 0;
                    g_reg <= 1;
                    state <= H;
                end
                default: begin
                    state <= A;
                    f_reg <= 0;
                    g_reg <= 0;
                    x_history <= 3'b000;
                    y_seen <= 0;
                    y_count <= 0;

                end
            endcase

            if (state == E || state == F)
            begin
                if (y)
                  y_count <= 0;
                else if (y_count < 2)
                  y_count <= y_count + 1;
            end
            else
            begin
                y_count <= 0;
            end
        end
    end

    // Output Assignments
    assign f = f_reg;
    assign g = g_reg;

endmodule