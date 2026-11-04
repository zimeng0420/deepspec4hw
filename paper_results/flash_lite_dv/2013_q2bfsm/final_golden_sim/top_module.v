module top_module(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State Definition
    parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G = 6;

    // State Register
    reg [2:0] state;

    // Internal Signals
    reg [1:0] x_history; // Store previous two values of x
    reg y_detected;
    reg [1:0] y_counter;

    // FSM Logic
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= A;
            f <= 0;
            g <= 0;
            x_history <= 2'b00;
            y_detected <= 0;
            y_counter <= 0;
        end else begin
            case (state)
                A: begin
                    f <= 0;
                    g <= 0;
                    x_history <= 2'b00;
                    if (f == 0)
                      f <= 1; // Set f to 1 for one cycle after reset de-asserted
                    state <= B; // Move to state B after the first cycle
                end
                B: begin
                    f <= 0;
                    x_history <= {x_history[0], x};
                    if (x_history == 2'b10)
                      state <= C;
                    else
                      state <= B;
                end
                C: begin
                    f <= 0;
                    x_history <= {x_history[0], x};
                    if (x_history == 2'b01) begin
                       state <= D;
                    end else
                      state <= B;
                end
                D: begin
                    f <= 0;
                    g <= 1;
                    y_counter <= 0;
                    y_detected <= 0;
                    state <= E;

                end
                E: begin
                    f <= 0;
                    if (y) begin
                       y_detected <= 1;
                    end
                    if (y_detected) begin
                       state <= G;
                    end
                    else if(y_counter < 2) begin
                        y_counter <= y_counter + 1;
                        state <= E;
                    end else begin
                        state <= F;
                    end
                end
               F: begin
                    f <= 0;
                    g <= 0;
                    state <= A; // Go back to A for reset
                end
                G: begin
                    f <= 0;
                    g <= 1;
                    state <= G; // Stay in G until reset
                end

                default: begin
                    state <= A;
                    f <= 0;
                    g <= 0;
                    x_history <= 2'b00;
                    y_detected <= 0;
                    y_counter <= 0;
                end
            endcase
        end
    end

endmodule