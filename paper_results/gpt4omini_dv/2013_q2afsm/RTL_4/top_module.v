module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);

    // State encoding
    parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        case(state)
            A: begin
                if (r[1]) next_state = B;
                else if (r[2]) next_state = C;
                else if (r[3]) next_state = D;
                else next_state = A; // Remain in state A
            end
            
            B: begin
                if (r[1]) next_state = B; // Stay in B if r[1] is high
                else next_state = A; // Return to A if r[1] goes low
            end
            
            C: begin
                if (r[2]) next_state = C; // Stay in C if r[2] is high
                else next_state = A; // Return to A if r[2] goes low
            end
            
            D: begin
                next_state = A; // Return to A from D
            end
            
            default: next_state = A; // Default to state A
        endcase
    end

    // Sequential logic for state update
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            state <= A; // Active-low reset to state A
        else
            state <= next_state;
    end

    // Output logic
    always @(*) begin
        case(state)
            B: g = 3'b100; // Grant for device 1
            C: g = 3'b010; // Grant for device 2
            D: g = 3'b001; // Grant for device 3
            default: g = 3'b000; // No grants in state A or undefined
        endcase
    end

endmodule