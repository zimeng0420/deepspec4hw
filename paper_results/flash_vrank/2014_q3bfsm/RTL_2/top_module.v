module top_module (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
        end else begin
            case (state)
                3'b000: begin
                    if (x == 0) begin
                        state <= 3'b000;
                    end else begin
                        state <= 3'b001;
                    end
                end
                3'b001: begin
                    if (x == 0) begin
                        state <= 3'b001;
                    end else begin
                        state <= 3'b100;
                    end
                end
                3'b010: begin
                    if (x == 0) begin
                        state <= 3'b010;
                    end else begin
                        state <= 3'b001;
                    end
                end
                3'b011: begin
                    if (x == 0) begin
                        state <= 3'b001;
                    end else begin
                        state <= 3'b010;
                    end
                end
                3'b100: begin
                    if (x == 0) begin
                        state <= 3'b011;
                    end else begin
                        state <= 3'b100;
                    end
                end
                default: state <= 3'b000;
            endcase
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            z <= 1'b0;
        end else begin
            case (state)
                3'b000: z <= 1'b0;
                3'b001: z <= 1'b0;
                3'b010: z <= 1'b0;
                3'b011: z <= 1'b1;
                3'b100: z <= 1'b1;
                default: z <= 1'b0;
            endcase
        end
    end

endmodule