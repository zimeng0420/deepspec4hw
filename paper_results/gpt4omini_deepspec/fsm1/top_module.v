module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    typedef enum reg [1:0] {
        A = 1'b0,
        B = 1'b1
    } state_t;

    state_t current_state, next_state;

    // Asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) 
            current_state <= B;
        else 
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            A: begin
                if (in) 
                    next_state = A;
                else 
                    next_state = B;
            end
            B: begin
                if (in) 
                    next_state = B;
                else 
                    next_state = A;
            end
            default: next_state = B; // Default state
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            A: out = 1'b0;
            B: out = 1'b1;
        endcase
    end

endmodule