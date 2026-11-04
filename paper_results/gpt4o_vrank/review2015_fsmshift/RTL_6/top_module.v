module top_module(
    input clk,
    input reset,
    output shift_ena
);

    reg [2:0] state, next_state; // 3-bit state to count up to 4
    reg shift_ena_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
            shift_ena_reg <= 1'b1;
        end else if (shift_ena_reg) begin
            state <= next_state;
        end
    end

    always @(*) begin
        if (reset) begin
            next_state = 3'b001;
        end else begin
            if (shift_ena_reg) begin
                case (state)
                    3'b000: next_state = 3'b001;
                    3'b001: next_state = 3'b010;
                    3'b010: next_state = 3'b011;
                    3'b011: next_state = 3'b100;
                    3'b100: begin
                        next_state = 3'b100;
                        shift_ena_reg = 1'b0;
                    end
                    default: next_state = 3'b100;
                endcase
            end else begin
                next_state = 3'b100;
            end
        end
    end

    assign shift_ena = shift_ena_reg;

endmodule