module top_module(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // Define states
    parameter A = 3'b000;
    parameter B = 3'b001;
    parameter C = 3'b010;
    parameter D = 3'b011;
    parameter E = 3'b100;
    parameter F = 3'b101;
    parameter G = 3'b110;
    parameter H = 3'b111;

    // State register
    reg [2:0] current_state;
    reg [2:0] next_state;

    // Internal signals for x sequence detection
    reg x_prev1;
    reg x_prev2;

    // Counter for y check
    reg [1:0] y_counter;

    // F output flag
    reg f_set;

    // State transition logic
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= A;
            f_set <= 0;
            g <= 0;
            y_counter <= 2'b00;
        end else begin
            current_state <= next_state;
            if (f_set) begin
                f_set <= 0;
            end
        end
    end

    // Combinational logic for next state and outputs
    always @(*) begin
        // Default assignments
        next_state = current_state;
        f = 0;
        
        // Reset condition:
        if(!resetn){
            f = 0;
            g = 0;
        }
        else begin

            case (current_state)
                A: begin
                    f = 0;
                    g = 0;
                    if(f_set == 0) begin
                        f_set = 1;
                        next_state = B;
                    end else
                        next_state = A;
                end
                B: begin
                    f = 1;
                    g = 0;
                    if(x == 1) begin
                        next_state = C;
                    end else
                        next_state = B;
                end
                C: begin
                    f = 0;
                    g = 0;
                   if(x == 0) begin
                        next_state = D;
                    end else
                        next_state = C;

                end
                D: begin
                     f = 0;
                     g = 0;
                    if(x == 1) begin
                        next_state = E;
                    end else
                        next_state = D;
                end
                E: begin
                     f = 0;
                     g = 1;
                     y_counter = 2'b00;
                     next_state = F;
                end
                F: begin
                     f = 0;
                     if (y == 1) begin
                        g = 1;
                         next_state = F;
                     end else begin
                         if (y_counter == 2'b11) begin
                            g = 0;
                             next_state = A;
                         end
                         else begin
                            g = 1;
                            next_state = F;
                         end
                     end
                end
               
            endcase
        end

    end

endmodule