module top_module (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] y_present;
    reg [2:0] y_next;

    always @(posedge clk) begin
        if (reset) begin
            y_present <= 3'b000;
        end else begin
            y_present <= y_next;
        end
    end

    always @(*) begin
        case (y_present)
            3'b000: begin
                if (x == 0) y_next = 3'b000;
                else y_next = 3'b001;
                z = 0;
            end
            3'b001: begin
                if (x == 0) y_next = 3'b001;
                else y_next = 3'b100;
                z = 0;
            end
            3'b010: begin
                if (x == 0) y_next = 3'b010;
                else y_next = 3'b001;
                z = 0;
            end
            3'b011: begin
                if (x == 0) y_next = 3'b001;
                else y_next = 3'b010;
                z = 1;
            end
            3'b100: begin
                if (x == 0) y_next = 3'b011;
                else y_next = 3'b100;
                z = 1;
            end
            default: begin
                y_next = 3'b000;
                z = 0;
            end
        endcase
    end

endmodule