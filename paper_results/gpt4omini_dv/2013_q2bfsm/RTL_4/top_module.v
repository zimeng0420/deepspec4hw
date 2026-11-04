module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);
    reg [2:0] state, next_state;
    reg [1:0] x_seq;
    
    localparam A = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, IDLE = 3'b100;

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= A;
            f <= 0;
            g <= 0;
        end else begin
            state <= next_state;
            f <= (state == A) ? 1 : 0; // f is 1 for one clock cycle after reset
        end
    end

    always @(posedge clk) begin
        if (state == S1) begin
            x_seq <= {x_seq[0], x}; // Shift in new x value
        end
    end

    always @(*) begin
        case (state)
            A: begin
                next_state = (resetn) ? S1 : A;
            end
            S1: begin
                if (x_seq == 2'b10) begin
                    next_state = S2;
                end else begin
                    next_state = S1;
                end
            end
            S2: begin
                if (x == 1) begin
                    g = 1; // Set g to 1 after 1, 0, 1
                    next_state = IDLE; 
                end else begin
                    next_state = S1; // remain in detection
                end
            end
            IDLE: begin
                if (y == 1) begin
                    g = 1; // Maintain g = 1 if y is detected
                    next_state = IDLE; 
                end else begin
                    next_state = A; // Otherwise go back to wait for reset
                end
            end
            default: next_state = A;
        endcase
    end
endmodule