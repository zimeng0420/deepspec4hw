module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    typedef enum logic [1:0] {
        S_WAIT = 2'b00,   // Waiting for the first '1'
        S_COMP = 2'b01    // Complement mode after first '1'
    } state_t;
    
    state_t state, next_state;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_WAIT;
        end else begin
            state <= next_state;
        end
    end
    
    always @(*) begin
        case (state)
            S_WAIT: begin
                if (x == 1'b1)
                    next_state = S_COMP;
                else
                    next_state = S_WAIT;
                z = x; // Output is same as input before first '1'
            end
            S_COMP: begin
                next_state = S_COMP;
                z = ~x; // Output is complement after first '1'
            end
            default: begin
                next_state = S_WAIT;
                z = 1'b0;
            end
        endcase
    end

endmodule