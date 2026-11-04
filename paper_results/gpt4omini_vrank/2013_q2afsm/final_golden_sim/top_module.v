module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);

    // State encoding
    parameter A = 3'b000, 
              B = 3'b001, 
              C = 3'b010, 
              D = 3'b011;
    
    // State variable
    reg [2:0] state, next_state;

    // State transition
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= A; // Reset to state A
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: begin
                if (r[1]) next_state = B;
                else if (r[2]) next_state = C;
                else next_state = D;
            end
            B: begin
                if (r[1]) next_state = B; // Stay in B
                else next_state = A; // Go back to A
            end
            C: begin
                if (r[2]) next_state = C; // Stay in C
                else next_state = A; // Go back to A
            end
            D: begin
                next_state = A; // Go back to A
            end
            default: next_state = A; // Default case
        endcase
    end

    // Output logic
    always @(*) begin
        g = 3'b000; // Default all grants to 0
        case (state)
            B: g[1] = 1; // Grant to device 1
            C: g[2] = 1; // Grant to device 2
            default: g = 3'b000; // No grants in other states
        endcase
    end

endmodule