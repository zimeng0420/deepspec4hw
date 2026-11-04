module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    // State Encoding
    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t current_state, next_state;

    // State Transition Logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // Next State Logic
    always_comb begin
        case (current_state)
            A: next_state = (in == 1) ? B : A;
            B: next_state = (in == 1) ? B : C;
            C: next_state = (in == 1) ? D : A;
            D: next_state = (in == 1) ? B : C;
            default: next_state = A; // default case to handle unexpected states
        endcase
    end

    // Output Logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 0;
        end else begin
            case (current_state)
                A: out <= 0;
                B: out <= 0;
                C: out <= 0;
                D: out <= 1;
                default: out <= 0; // default case to handle unexpected states
            endcase
        end
    end

endmodule