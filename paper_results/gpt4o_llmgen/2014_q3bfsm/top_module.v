module top_module (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] y, next_y;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 3'b000; // Reset to state 000
        end else begin
            y <= next_y; // Transition to next state
        end
    end

    always @(*) begin
        case (y)
            3'b000: begin
                next_y = (x == 1'b0) ? 3'b000 : 3'b001;
                z = 1'b0;
            end
            3'b001: begin
                next_y = (x == 1'b0) ? 3'b001 : 3'b100;
                z = 1'b0;
            end
            3'b010: begin
                next_y = (x == 1'b0) ? 3'b010 : 3'b001;
                z = 1'b0;
            end
            3'b011: begin
                next_y = (x == 1'b0) ? 3'b001 : 3'b010;
                z = 1'b1;
            end
            3'b100: begin
                next_y = (x == 1'b0) ? 3'b011 : 3'b100;
                z = 1'b1;
            end
            default: begin
                next_y = 3'b000; // Default state
                z = 1'b0;
            end
        endcase
    end

endmodule