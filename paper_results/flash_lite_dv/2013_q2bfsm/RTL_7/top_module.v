module top_module(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // Define states
    parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G = 6;

    // State register
    reg [2:0] state;

    // Internal signals for x sequence detection
    reg [1:0] x_history;
    reg x_seq_detected;
    reg [1:0] y_counter;

    // Default values
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= A;
            f <= 0;
            g <= 0;
            x_history <= 2'b00;
            x_seq_detected <= 0;
            y_counter <= 2'b00;
        end else begin
            // Update x history
            x_history <= {x_history[0], x};

            case (state)
                A: begin
                    f <= 0;
                    g <= 0;
                    if (x_history == 2'b10 && x) begin
                        x_seq_detected <= 1;
                    end else begin
                        x_seq_detected <= 0;
                    end
                    if (f == 1)
                        state <= B; // Shouldn't happen, included for completeness
                    else if (x_seq_detected)
                         state <= D;
                    else
                        state <= A;
                end

                B: begin
                    f <= 1;
                    g <= 0;
                    state <= C;
                end
                C: begin
                    f <= 0;
                    g <= 0;
                    if (x_history == 2'b10 && x)
                       state <= D;
                    else
                       state <= C;
                end
                D: begin // x sequence detected, g set to 1
                    f <= 0;
                    g <= 1;
                    y_counter <= 2'b00;
                    state <= E;
                end
                E: begin // monitor y for 2 cycles
                    f <= 0;
                    if (y) begin
                        g <= 1;
                        y_counter <= 2'b00;
                        state <= E;
                    end else if (y_counter == 2'b10) begin
                        g <= 0;
                        state <= A;
                    end else begin
                        g <= 1;
                        y_counter <= y_counter + 1;
                        state <= E;
                    end
                end

            endcase
        end
    end
endmodule