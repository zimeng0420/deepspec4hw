module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output reg out
);

    typedef enum reg [1:0] {
        OFF = 1'b0,
        ON = 1'b1
    } state_t;

    state_t state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            OFF: begin
                out = 1'b0;
                if (j) 
                    next_state = ON;
                else 
                    next_state = OFF;
            end
            ON: begin
                out = 1'b1;
                if (k) 
                    next_state = OFF;
                else 
                    next_state = ON;
            end
        endcase
    end

endmodule