module top_module (
	input clk,
	input in,
	input areset,
	output out
);

    parameter A = 2'b00;
    parameter B = 2'b01;

    reg [1:0] state;
    reg out_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            case (state)
                A:
                    if (in)
                        state <= A;
                    else
                        state <= B;
                B:
                    if (in)
                        state <= B;
                    else
                        state <= A;
                default:
                    state <= B;
            endcase
        end
    end

    always @(*) begin
        case (state)
            A: out_reg = 1'b0;
            B: out_reg = 1'b1;
            default: out_reg = 1'b1;
        endcase
    end

    assign out = out_reg;

endmodule