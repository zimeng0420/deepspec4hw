module top_module (
    input clk,
    input areset,
    input x,
    output z
);

    reg [1:0] state;
    reg z_r;

    // State encoding: A=2'b01, B=2'b10

    parameter A = 2'b01;
    parameter B = 2'b10;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            case (state)
                A: begin
                    if (x == 1'b1) begin
                        state <= B;
                    end else begin
                        state <= A;
                    end
                end
                B: begin
                    if (x == 1'b1) begin
                        state <= B;
                    end else begin
                        state <= B;
                    end
                end
                default: state <= A;
            endcase
        end
    end

    always @(*) begin
        case (state)
            A: begin
                if (x == 1'b0) begin
                    z_r = 1'b0;
                end else begin
                    z_r = 1'b1;
                end
            end
            B: begin
                if (x == 1'b0) begin
                    z_r = 1'b1;
                end else begin
                    z_r = 1'b0;
                end
            end
            default: z_r = 1'b0;
        endcase
    end

    assign z = z_r;

endmodule