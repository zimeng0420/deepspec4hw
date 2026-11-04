module top_module(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State definitions
    parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G = 6, H = 7;

    // Internal signals
    reg [2:0] state;
    reg [1:0] x_history; // Store previous two values of x
    reg [1:0] y_counter;  // Counter for y input after g asserted

    // Sequential logic (always block for state and output updates)
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= A;
            f <= 0;
            g <= 0;
            x_history <= 2'b00;
            y_counter <= 2'b00;
        end else begin
            x_history <= {x_history[0], x}; // Update x history

            case (state)
                A: begin
                    f <= 0;
                    g <= 0;
                    if (state == A) begin
                        f <= 0;
                    end
                    if (f == 0) begin
                        state <= B; // Transition to B after reset deassertion for f=1
                    end
                end
                B: begin  // Set f to 1 for one cycle
                    f <= 1;
                    state <= C; // Go to state C
                    g <= 0;
                end
                C: begin
                    f <= 0;
                    g <= 0;
                    if (x_history == 2'b10 && x == 1) begin
                        state <= D; // x sequence detected, go to state D
                    end
                end
                D: begin // set g=1 after x sequence, start monitoring y
                    f <= 0;
                    g <= 1;
                    y_counter <= 0;
                    state <= E;
                end
                E: begin // Monitor y for two cycles
                    f <= 0;
                    if (y == 1) begin
                        state <= G; // y = 1, keep g = 1
                        y_counter <= 0;
                    end
                    else if (y_counter < 2) begin
                        y_counter <= y_counter + 1;
                        state <= E; // stay in E and count
                    end
                     else begin
                         state <= F; // y is not 1 in two cycles, g=0
                         y_counter <= 0;
                    end
                end
                F: begin  // g = 0 permanently
                    f <= 0;
                    g <= 0;
                end
                G: begin // g = 1 permanently
                    f <= 0;
                    g <= 1;
                end
                H: begin
                    f <= 0;
                    g <= 0;
                end
                default: begin
                    state <= A;
                    f <= 0;
                    g <= 0;
                    x_history <= 2'b00;
                    y_counter <= 2'b00;
                end
            endcase
        end
    end

endmodule