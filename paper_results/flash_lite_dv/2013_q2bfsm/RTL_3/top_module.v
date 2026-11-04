module top_module(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State Definitions
    parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G = 6, H = 7; // Added more states for clarity

    // Internal Signals
    reg [2:0] state;
    reg [1:0] x_history; // Stores previous x values (x[n-1], x[n-2])
    reg [1:0] y_counter; // Counts clock cycles after g=1 to check for y=1
    reg f_delayed; // Delayed f signal for one clock cycle

    // State Transition Logic and Output Logic
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= A;
            f <= 0;
            g <= 0;
            x_history <= 2'b00;
            y_counter <= 2'b00;
            f_delayed <= 0;
        end else begin
            f <= f_delayed; //Assign f to be delayed
            f_delayed <= 0;
            case (state)
                A: begin
                    f_delayed <= 1; // Set f to 1 for one cycle
                    g <= 0;
                    x_history <= 2'b00; // Reset x history
                    y_counter <= 2'b00;
                    if (f_delayed) begin
                       state <= B;
                    end
                end
                B: begin
                    // State after f asserted, waiting for x sequence to start
                    f_delayed <= 0;
                    g <= 0;
                    x_history <= {x_history[0], x};
                    y_counter <= 2'b00;

                    if (x_history == 2'b10 && x == 1) begin
                        state <= C;  // x sequence detected (1, 0, 1)
                    end else begin
                        state <= B;
                    end
                end
                C: begin
                    // x sequence detected, set g=1 on the next clock cycle
                    f_delayed <= 0;
                    g <= 1;
                    x_history <= 2'b00;
                    y_counter <= 2'b00; // Reset y counter
                    state <= D;
                end
                D: begin
                    // g = 1, wait for y to be 1 within 2 cycles
                    f_delayed <= 0;
                    if (y == 1) begin
                        g <= 1; // g remains 1
                        y_counter <= 2'b00;
                        state <= D; // Stay in D, continue monitoring y
                    end else if (y_counter < 2'b10) begin
                         g <= 1;
                         y_counter <= y_counter + 1'b1;
                         state <= D;
                    end else begin
                        g <= 0; // y was not 1 within 2 cycles, set g to 0
                        y_counter <= 2'b00;
                        state <= A; // Go back to A after g deassert
                    end
                end
                default: begin
                    state <= A;
                    f <= 0;
                    g <= 0;
                    x_history <= 2'b00;
                    y_counter <= 2'b00;
                    f_delayed <= 0;
                end
            endcase
        end
    end

endmodule