module top_module (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding
    typedef enum reg [2:0] {
        A = 3'b000,
        B = 3'b001,
        C = 3'b010,
        D = 3'b011,
        E = 3'b100,
        F = 3'b101
    } state_t;
    
    state_t state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) 
            state <= A; // Reset state
        else 
            state <= next_state;
    end

    always @(*) begin
        case (state)
            A: begin
                z = 0;
                if (w == 0) 
                    next_state = B;
                else 
                    next_state = A;
            end
            
            B: begin
                z = 0;
                if (w == 0) 
                    next_state = C;
                else 
                    next_state = D;
            end
            
            C: begin
                z = 0;
                if (w == 0) 
                    next_state = E;
                else 
                    next_state = D;
            end
            
            D: begin
                z = 0;
                if (w == 0) 
                    next_state = F;
                else 
                    next_state = A;
            end
            
            E: begin
                z = 1;
                if (w == 0) 
                    next_state = E;
                else 
                    next_state = D;
            end
            
            F: begin
                z = 1;
                if (w == 0) 
                    next_state = C;
                else 
                    next_state = D;
            end
            
            default: begin
                z = 0;
                next_state = A;
            end
        endcase
    end
endmodule