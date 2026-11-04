module top_module(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State Definition
    parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G = 6, H = 7;
    reg [2:0] state;
    reg [1:0] x_history;  // Store previous two values of x
    reg [1:0] y_counter;  // Counter for y input
    reg f_set;           // Flag to set f for one cycle

    // State Transition Logic
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= A;
            f <= 0;
            g <= 0;
            x_history <= 2'b00;
            y_counter <= 2'b00;
            f_set <= 0;
        end else begin
            case (state)
                A: begin
                    f <= 0;
                    g <= 0;
                    f_set <= 0;
                    if (f_set == 0) begin
                        f_set <= 1;
                        state <= B;
                    end
                    
                end
                B: begin // Set f to 1 for one cycle
                    f <= 1;
                    g <= 0;
                    f_set <= 0;
                    x_history <= {x_history[0], x};
                    state <= C;

                end
                C: begin
                    f <= 0;
                    g <= 0;
                    x_history <= {x_history[0], x};
                    if (x_history == 2'b10 && x == 1) begin
                        state <= D;
                    end else begin
                        state <= C;
                    end
                end
                D: begin
                    g <= 1;
                    y_counter <= 2'b00;
                    if (y == 1) begin
                        state <= G;
                    end
                    else begin
                        state <= E;
                    end
                end

                E: begin
                    g <= 1;
                    y_counter <= y_counter + 1;
                    if (y_counter == 2'b10 && y == 0) begin
                        state <= H;
                    end else if (y == 1)
                        state <= G;
                    else
                        state <= E;
                end

                G: begin
                    g <= 1;
                    state <= G;
                end
                H: begin
                    g <= 0;
                    state <= H;
                end
                default: begin
                    state <= A;
                    f <= 0;
                    g <= 0;
                    x_history <= 2'b00;
                    y_counter <= 2'b00;
                    f_set <= 0;
                end
            endcase
        end
    end
endmodule