module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output out
);

    reg state, next_state;

    // State encoding
    localparam OFF = 1'b0, ON = 1'b1;

    // State transition logic
    always @(*) begin
        case (state)
            OFF: begin
                if (j)
                    next_state = ON;
                else
                    next_state = OFF;
            end
            ON: begin
                if (k)
                    next_state = OFF;
                else
                    next_state = ON;
            end
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) 
            state <= OFF;
        else 
            state <= next_state;
    end

    // Output logic
    assign out = (state == ON);

endmodule