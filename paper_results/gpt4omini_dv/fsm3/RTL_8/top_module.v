module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    // State encoding
    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t current_state, next_state;

    // Asynchronous reset and state transition on clock edge
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= A; // Reset to state A
        end else begin
            current_state <= next_state; // Move to next state
        end
    end

    // Combinational logic for state transition and output
    always @(*) begin
        case (current_state)
            A: begin
                if (in) begin
                    next_state = B; // A -> B on in = 1
                end else begin
                    next_state = A; // A -> A on in = 0
                end
                out = 0;
            end
            
            B: begin
                if (in) begin
                    next_state = B; // B -> B on in = 1
                end else begin
                    next_state = C; // B -> C on in = 0
                end
                out = 0;
            end
            
            C: begin
                if (in) begin
                    next_state = D; // C -> D on in = 1
                end else begin
                    next_state = A; // C -> A on in = 0
                end
                out = 0;
            end
            
            D: begin
                if (in) begin
                    next_state = B; // D -> B on in = 1
                end else begin
                    next_state = C; // D -> C on in = 0
                end
                out = 1; // Output is 1 only in state D
            end
            
            default: begin
                next_state = A; // Default to state A
                out = 0; // Default output
            end
        endcase
    end

endmodule