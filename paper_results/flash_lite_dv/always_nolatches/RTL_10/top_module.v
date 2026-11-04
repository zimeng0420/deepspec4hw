module top_module(
    input [15:0] sc_code,
    output left,
    output down,
    output right,
    output up
);
    
    reg left_reg, down_reg, right_reg, up_reg;

    always @(sc_code) begin
        case (sc_code)
            16'he06b: begin
                left_reg = 1'b1;
                down_reg = 1'b0;
                right_reg = 1'b0;
                up_reg = 1'b0;
            end
            16'he072: begin
                left_reg = 1'b0;
                down_reg = 1'b1;
                right_reg = 1'b0;
                up_reg = 1'b0;
            end
            16'he074: begin
                left_reg = 1'b0;
                down_reg = 1'b0;
                right_reg = 1'b1;
                up_reg = 1'b0;
            end
            16'he075: begin
                left_reg = 1'b0;
                down_reg = 1'b0;
                right_reg = 1'b0;
                up_reg = 1'b1;
            end
            default: begin
                left_reg = 1'b0;
                down_reg = 1'b0;
                right_reg = 1'b0;
                up_reg = 1'b0;
            end
        endcase
    end
    
    assign left = left_reg;
    assign down = down_reg;
    assign right = right_reg;
    assign up = up_reg;

endmodule