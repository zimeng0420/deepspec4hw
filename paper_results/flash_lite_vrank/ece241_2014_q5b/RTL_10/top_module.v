module top_module (
    input clk,
    input areset,
    input x,
    output z
);

    parameter A = 4'b0001;
    parameter B = 4'b0010;

    reg [3:0] state, next_state;
    reg z_reg;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            A: begin
                next_state = (x) ? B : A;
                z_reg = (x) ? 1'b1 : 1'b0;
            end
            B: begin
                next_state = B;
                z_reg = (x) ? 1'b0 : 1'b1;
            end
            default: begin
                next_state = A;
                z_reg = 1'b0;
            end
        endcase
    end

    assign z = z_reg;

endmodule