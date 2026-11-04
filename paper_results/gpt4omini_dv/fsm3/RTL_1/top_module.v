module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    typedef enum reg [1:0] {A, B, C, D} state_t;
    state_t current_state, next_state;

    // Asynchronous reset and state transition on rising edge of clock
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic for next state and output
    always @(*) begin
        case (current_state)
            A: begin
                if (in) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
                out = 0;
            end
            B: begin
                if (in) begin
                    next_state = B;
                end else begin
                    next_state = C;
                end
                out = 0;
            end
            C: begin
                if (in) begin
                    next_state = D;
                end else begin
                    next_state = A;
                end
                out = 0;
            end
            D: begin
                if (in) begin
                    next_state = B;
                end else begin
                    next_state = C;
                end
                out = 1;
            end
            default: begin
                next_state = A;
                out = 0;
            end
        endcase
    end

endmodule