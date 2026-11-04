module top_module(
    input clk,
    output reg x,
    output reg y,
    output reg z
);

    initial begin
        x = 0;
        y = 0;
        z = 1;
    end

    always @(posedge clk) begin
        case ($time)
            0, 5, 10, 15, 20: begin
                x = 0;
                y = 0;
                z = 1;
            end
            25, 30: begin
                x = 1;
                y = 0;
                z = 0;
            end
            35, 40: begin
                x = 0;
                y = 1;
                z = 0;
            end
            45, 50: begin
                x = 1;
                y = 1;
                z = 1;
            end
            55: begin
                x = 0;
                y = 0;
                z = 1;
            end
            60, 65: begin
                x = 0;
                y = 1;
                z = 0;
            end
            70: begin
                x = 1;
                y = 1;
                z = 1;
            end
            75, 80, 85: begin
                x = 0;
                y = 1;
                z = 0;
            end
            90: begin
                x = 1;
                y = 0;
                z = 0;
            end
        endcase
    end
endmodule