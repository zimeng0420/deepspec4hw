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
    reg [2:0] state;

    // Internal Signals
    reg [1:0] x_history; // Store previous two values of x
    reg y_valid_count;   // Counter for y input validity
    reg f_set;           // Flag to set f for one cycle

    // Sequential Logic (State Update and Output Generation)
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= A;
            f <= 0;
            g <= 0;
            x_history <= 2'b00;
            y_valid_count <= 0;
            f_set <= 0;
        end else begin
            x_history <= {x_history[0], x};

            case (state)
                A: begin
                    f <= 0;
                    g <= 0;
                    f_set <= 0;
                    if (f_set == 0) begin
                        f_set <= 1;
                    end
                    if (f_set == 1) begin
                      state <= B;
                    end else begin
                      state <= A;
                    end
                end

                B: begin
                  f <= 1;
                  g <= 0;
                  if (x_history == 2'b10) begin
                        state <= C;
                  end else begin
                        state <= B;
                  end
                end

                C: begin
                  f <= 0;
                  g <= 0;
                  if (x == 1) begin
                        state <= D;
                  end else begin
                        state <= B;
                  end
                end


                D: begin
                    f <= 0;
                    g <= 1;
                    y_valid_count <= 0; //reset counter for y input validation
                    state <= E;
                end

                E: begin
                    f <= 0;
                    if (y) begin
                        g <= 1;
                    end else if (y_valid_count == 1) begin
                        g <= 0;
                    end
                    if (y) begin
                        state <= E;
                        y_valid_count <= y_valid_count;
                    end else if (y_valid_count < 1) begin
                        y_valid_count <= y_valid_count + 1;
                        state <= E;
                    end else begin
                      state <= G;
                    end
                end

                G: begin
                    f <= 0;
                    g <= 0;
                    state <= G;
                end

                default: begin
                    state <= A;
                    f <= 0;
                    g <= 0;
                    x_history <= 2'b00;
                    y_valid_count <= 0;
                    f_set <= 0;
                end
            endcase
        end
    end
endmodule