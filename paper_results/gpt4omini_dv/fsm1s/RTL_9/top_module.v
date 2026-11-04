module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);
    // State encoding
    typedef enum reg [1:0] {
        A = 1'b0,
        B = 1'b1
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            A: begin
                if (in == 0) next_state = B;
                else next_state = A;
            end
            B: begin
                if (in == 0) next_state = A;
                else next_state = B;
            end
            default: next_state = B; // safe state
        endcase
    end

    // State update and output logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= B; // reset to state B
        end else begin
            current_state <= next_state;
        end
    end

    // Output logic
    always @(current_state) begin
        out = (current_state == B) ? 1 : 0;
    end
endmodule