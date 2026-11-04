module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);
    
    // State encoding
    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;
    
    // State variable
    state_t current_state, next_state;

    // State flip-flops
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            A: begin
                if (r[1]) 
                    next_state = B;
                else if (r[2]) 
                    next_state = C;
                else if (r[3]) 
                    next_state = D;
                else 
                    next_state = A;
            end
            B: begin
                if (r[1]) 
                    next_state = B;
                else 
                    next_state = A;
            end
            C: begin
                if (r[2]) 
                    next_state = C;
                else 
                    next_state = A;
            end
            D: begin
                next_state = A; // Default transition
            end
            default: next_state = A; // Safety
        endcase
    end

    // Output logic
    always @(*) begin
        g = 3'b000; // Default all grants to 0
        case (current_state)
            A: begin
                g[1] = r[1]; // Grant to device 1
                g[2] = r[2] & ~r[1]; // Grant to device 2
                g[3] = r[3] & ~r[1] & ~r[2]; // Grant to device 3
            end
            B: begin
                g[1] = 1'b1; // Grant to device 1
            end
            C: begin
                g[2] = 1'b1; // Grant to device 2
            end
            D: begin
                g[3] = 1'b1; // Grant to device 3
            end
        endcase
    end

endmodule