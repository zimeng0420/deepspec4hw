module top_module (
	input clk,
	input in,
	input areset,
	output out
);

    parameter A = 2'b00;
    parameter B = 2'b01;

    reg [1:0] state;
    reg out_r;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            case (state)
                A:
                    state <= in ? A : B;
                B:
                    state <= in ? B : A;
                default:
                    state <= B;
            endcase
    end

    // Output logic
    always @(state) begin
        case (state)
            A:
                out_r <= 1'b0;
            B:
                out_r <= 1'b1;
            default:
                out_r <= 1'b1; // Default to B
        endcase
    end

    assign out = out_r;

endmodule