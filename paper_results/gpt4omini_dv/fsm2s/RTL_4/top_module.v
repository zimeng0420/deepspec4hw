module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output reg out
);
    typedef enum reg [1:0] {
        OFF = 1'b0,
        ON = 1'b1
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= OFF;
        end else begin
            current_state <= next_state;
        end
    end

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
            default: next_state = OFF;
        endcase
    end

    always @(current_state) begin
        out = (current_state == ON) ? 1'b1 : 1'b0;
    end
endmodule