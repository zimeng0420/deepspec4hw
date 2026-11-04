module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output reg out
);

    typedef enum reg [1:0] {
        OFF = 2'b00,
        ON  = 2'b01
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
                out = 0;
                if (j) 
                    next_state = ON;
                else 
                    next_state = OFF;
            end
            ON: begin
                out = 1;
                if (k) 
                    next_state = OFF;
                else 
                    next_state = ON;
            end
            default: next_state = OFF;
        endcase
    end

endmodule