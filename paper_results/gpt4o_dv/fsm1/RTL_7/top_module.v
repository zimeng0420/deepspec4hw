module top_module (
    input clk,
    input in,
    input areset,
    output out
);

    reg state;
    reg next_state;

    // State encoding
    parameter A = 0, B = 1;

    // State transition logic
    always @(*) begin
        case (state)
            B: next_state = (in == 0) ? A : B;
            A: next_state = (in == 0) ? B : A;
        endcase
    end

    // State update logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Output logic
    assign out = (state == B) ? 1 : 0;

endmodule