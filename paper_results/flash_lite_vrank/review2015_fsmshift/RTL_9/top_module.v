module top_module(
	input clk,
	input reset,
	output shift_ena
);

    parameter IDLE = 2'b00;
    parameter COUNT1 = 2'b01;
    parameter COUNT2 = 2'b10;
    parameter COUNT3 = 2'b11;

    reg [1:0] state, next_state;
    reg [1:0] counter;
    reg shift_ena_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_ena_reg <= 1'b1;
            counter <= 2'b00;
        end else begin
            state <= next_state;
            shift_ena_reg <= (state == COUNT1 || state == COUNT2 || state == COUNT3);
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (reset) begin
                    next_state = COUNT1;
                end
                 else
                    next_state = IDLE;
            end
            COUNT1: begin
                next_state = COUNT2;
            end
            COUNT2: begin
                next_state = COUNT3;
            end
            COUNT3: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    assign shift_ena = shift_ena_reg;

endmodule