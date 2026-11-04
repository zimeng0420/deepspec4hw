module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output reg out
);

    typedef enum logic [1:0] {
        OFF = 1'b0,
        ON = 1'b1
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= OFF;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @(current_state, j, k) begin
        case (current_state)
            OFF: begin
                out = 1'b0;
                if (j) begin
                    next_state = ON;
                end else begin
                    next_state = OFF;
                end
            end
            ON: begin
                out = 1'b1;
                if (k) begin
                    next_state = OFF;
                end else begin
                    next_state = ON;
                end
            end
            default: begin
                next_state = OFF;
            end
        endcase
    end
endmodule