module top_module(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State definition
    parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G = 6, H = 7;
    reg [2:0] state;

    // Internal signals for x sequence detection
    reg [1:0] x_history;

    // Internal signals for y monitoring
    reg [1:0] y_counter;
    reg y_valid;

    // Reset logic
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= A;
            f <= 0;
            g <= 0;
            x_history <= 2'b00;
            y_counter <= 2'b00;
            y_valid <= 0;
        end else begin
            // State transition logic
            case (state)
                A: begin
                    f <= 0;
                    g <= 0;
                    if (x_history == 2'b01 && x == 1) begin
                        state <= G; // x sequence detected
                    end
                    if (x == 1) begin
                         x_history <= {x_history[0], x};
                    end else begin
                          x_history <= {x_history[0], x};
                    end

                end
                G: begin // After x sequence
                    f <= 0;
                    g <= 1;
                    y_counter <= 2'b00;
                    y_valid <= 0;
                    state <= H;
                end
                H: begin // Monitoring y
                    f <= 0;
                    if (y == 1) begin
                      y_counter <= 2'b00;
                      y_valid <= 1;
                    end else begin
                      y_counter <= y_counter + 1;
                      if (y_counter == 2'b10) begin // After 2 cycles of not seeing y=1
                         g <= 0;
                      end
                      y_valid <= 0;

                    end
                end
            endcase
        end
    end

    // f output logic (set f to 1 for one cycle after reset is deasserted)
    always @(posedge clk) begin
        if (!resetn) begin
            f <= 0;
        end
         else if (state == A && !resetn) begin
              f <= 1;
         end
          else if (f == 1) begin
                f <= 0;
          end
          else begin
               f <= 0;
          end
    end
endmodule