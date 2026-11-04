module top_module (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] y; // Present state

    always @(posedge clk) begin
        if (reset) begin
            y <= 3'b000;
        end else begin
            case (y)
                3'b000: begin
                    if (x == 0)
                        y <= 3'b000;
                    else
                        y <= 3'b001;
                end
                3'b001: begin
                    if (x == 0)
                        y <= 3'b001;
                    else
                        y <= 3'b100;
                end
                3'b010: begin
                    if (x == 0)
                        y <= 3'b010;
                    else
                        y <= 3'b001;
                end
                3'b011: begin
                    if (x == 0)
                        y <= 3'b001;
                    else
                        y <= 3'b010;
                end
                3'b100: begin
                    if (x == 0)
                        y <= 3'b011;
                    else
                        y <= 3'b100;
                end
                default: y <= 3'b000; // Should not happen, but good practice
            endcase
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            z <= 1'b0;
        end else begin
            case (y)
                3'b000: z <= 1'b0;
                3'b001: z <= 1'b0;
                3'b010: z <= 1'b0;
                3'b011: z <= 1'b1;
                3'b100: z <= 1'b1;
                default: z <= 1'b0; // Should not happen, but good practice
            endcase
        end
    end
endmodule