module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);
    typedef enum reg [1:0] {A, S1, S2, S3} state_t;
    state_t current_state, next_state;

    // State update on clock edge
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= A;
            f <= 0;
            g <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            A: begin
                f = 1;
                g = 0;
                next_state = S1;
            end
            
            S1: begin
                f = 0;
                if (x == 1) next_state = S2; 
                else next_state = S1;
            end
            
            S2: begin
                f = 0;
                if (x == 0) next_state = S3; 
                else next_state = S1; // Reset state if x is not 0
            end
            
            S3: begin
                f = 0;
                next_state = S1; // Move to S1 to check for final 1
            end
            
            default: begin
                f = 0;
                next_state = A;
            end
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (current_state == S3) begin
            g <= 1;
        end else if (g == 1) begin
            // Monitor y for up to two cycles
            if (y == 1) begin
                g <= 1;
            end else begin
                g <= 0;
            end
        end
    end
endmodule