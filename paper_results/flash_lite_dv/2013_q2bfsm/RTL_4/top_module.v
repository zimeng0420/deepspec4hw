module top_module(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // Define states
    parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101, G = 3'b110;

    // State register
    reg [2:0] state;

    // Internal registers
    reg [1:0] x_history; // Store previous x values
    reg y_valid_counter; // Counter for y input validation
    reg f_delayed;

    // State transition logic
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= A;
            f <= 0;
            g <= 0;
            x_history <= 2'b00;
            y_valid_counter <= 0;
            f_delayed <= 0;
        end else begin
            case (state)
                A: begin
                    f <= 0;
                    g <= 0;
                    f_delayed <= 0;
                    if (f_delayed)
                      f <= 1;
                    else if (!f_delayed)
                      f <= 0;

                    if (!f_delayed)
                      f_delayed <= 1;
                    else
                    begin
                        x_history <= {x_history[0], x};
                        if (x_history == 2'b10) begin
                            state <= B;
                        end
                    end
                end
                B: begin
                    f <= 0;
                    g <= 0;
                    x_history <= {x_history[0], x};
                    if (x_history == 2'b01)
                      state <= C;
                    else
                      state <= B;
                end
                C: begin
                    f <= 0;
                    g <= 0;
                    x_history <= {x_history[0], x};
                    if (x_history == 2'b10) begin
                        state <= D;
                    end
                    else begin
                        state <= A;
                    end
                end
                D: begin
                    f <= 0;
                    g <= 1;
                    y_valid_counter <= 2'b00;
                    if (y) begin
                      state <= F;
                    end
                    else
                      state <= E;
                    end
                E: begin
                    f <= 0;
                    g <= 0;
                    if(y_valid_counter == 2'b10)
                        state <= A;
                    else
                        y_valid_counter <= y_valid_counter + 1'b1;
                    end
                F: begin
                    f <= 0;
                    g <= 1;
                    end
            endcase
        end
    end
endmodule