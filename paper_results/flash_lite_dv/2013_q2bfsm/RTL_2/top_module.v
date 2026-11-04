module top_module(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State Definition
    parameter A = 3'b000;
    parameter B = 3'b001;
    parameter C = 3'b010;
    parameter D = 3'b011;
    parameter E = 3'b100;
    parameter F = 3'b101;
    parameter G = 3'b110;

    reg [2:0] state;
    reg [1:0] x_history;  // Store previous x values
    reg [1:0] y_counter;  // Counter for y monitoring
    reg f_set;           // Flag to set f for one cycle

    // Sequential Logic
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
                    x_history <= 2'b00;
                    y_counter <= 2'b00;
                    f_set <= 0;
                    if(f_set == 0) begin
                         f_set <= 1;
                    end
                    state <= (f_set == 1) ? B : A;
                end
                B: begin
                    f <= 1;
                    g <= 0;
                    x_history <= {x_history[0], x};
                    f_set <= 0;
                    state <= C;
                end
                C: begin
                   f <= 0;
                   x_history <= {x_history[0], x};
                    if (x_history == 2'b10) begin
                        state <= D;
                    end
                    else begin
                         state <= C;
                    end
                    g <=0;

                end
                D: begin
                   f <= 0;
                   x_history <= {x_history[0], x};
                   if(x_history == 2'b01) begin
                        state <= E;
                   end
                   else begin
                    state <= C;
                   end
                   g <=0;

                end

                E: begin
                    f <= 0;
                    g <= 1;
                    y_counter <= 2'b00;
                    if (y == 1) begin
                       state <= G;
                    end
                    else begin
                        state <= F;
                    end

                end
                F: begin
                    f <= 0;
                    g <= 1;
                    if(y == 1) begin
                        state <= G;
                        y_counter <= 2'b00;
                    end
                    else if(y_counter < 2'b11) begin
                        y_counter <= y_counter + 1;
                        state <= F;
                    end
                    else begin
                        state <= A;
                    end

                end
                G: begin
                  f <=0;
                    g <= 1;
                    y_counter <= 2'b00;
                    state <= G;

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