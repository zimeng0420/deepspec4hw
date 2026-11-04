module top_module(
    input clk,
    input reset,
    output shift_ena
);

    reg [2:0] state, next_state;
    reg [1:0] cycle_count;
    reg shift_ena_reg;

    // State encoding
    localparam IDLE = 3'b000;
    localparam ENABLE_SHIFT = 3'b001;
    localparam DONE = 3'b010;

    assign shift_ena = shift_ena_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE_SHIFT;
            cycle_count <= 2'b00;
            shift_ena_reg <= 1'b1;
        end else begin
            state <= next_state;
            if (state == ENABLE_SHIFT) begin
                cycle_count <= cycle_count + 1;

                if (cycle_count == 2'b11) begin
                    shift_ena_reg <= 1'b0;
                end else begin
                    shift_ena_reg <= 1'b1;
                end
            end else begin
                cycle_count <= 2'b00;
                shift_ena_reg <= 1'b0;
            end
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                next_state = IDLE;
            end
            ENABLE_SHIFT: begin
                if (cycle_count == 2'b11)
                    next_state = DONE;
                else
                    next_state = ENABLE_SHIFT;
            end
            DONE: begin
                next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule