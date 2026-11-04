module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output reg out
);

    // State Declaration
    typedef enum reg [1:0] {
        OFF = 1'b0,
        ON = 1'b1
    } state_t;

    state_t current_state, next_state;

    // Synchronous Reset and State Transition
    always @(posedge clk) begin
        if (reset) begin
            current_state <= OFF;
        end else begin
            current_state <= next_state;
        end
    end

    // Next State Logic
    always @(*) begin
        case (current_state)
            OFF: begin
                if (j) begin
                    next_state = ON;
                end else begin
                    next_state = OFF;
                end
            end
            ON: begin
                if (k) begin
                    next_state = OFF;
                end else begin
                    next_state = ON;
                end
            end
        endcase
    end

    // Output Logic
    always @(current_state) begin
        case (current_state)
            OFF: out = 1'b0;
            ON:  out = 1'b1;
        endcase
    end

endmodule