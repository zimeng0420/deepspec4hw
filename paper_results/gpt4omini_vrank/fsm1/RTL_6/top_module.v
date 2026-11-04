module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    // State encoding
    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01
    } state_t;

    state_t state, next_state;

    // Output logic (Moore machine)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B; // Asynchronously reset to state B
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: begin
                if (in == 0) 
                    next_state = B;
                else 
                    next_state = A;
                out = 0; // Output for state A
            end
            B: begin
                if (in == 0) 
                    next_state = A;
                else 
                    next_state = B;
                out = 1; // Output for state B
            end
            default: begin
                next_state = B; // Default state
                out = 1; // Default output
            end
        endcase
    end
endmodule