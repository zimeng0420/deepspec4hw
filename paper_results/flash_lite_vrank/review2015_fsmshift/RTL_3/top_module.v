module top_module(
	input clk,
	input reset,
	output shift_ena
);

    parameter IDLE = 0, COUNT1 = 1, COUNT2 = 2, COUNT3 = 3, COUNT4 = 4;
    reg [2:0] state, next_state;
    reg [1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (reset) begin
                    next_state = COUNT1;
                end
            end
            COUNT1: begin
                next_state = COUNT2;
            end
            COUNT2: begin
                next_state = COUNT3;
            end
            COUNT3: begin
                next_state = COUNT4;
            end
            COUNT4: begin
                next_state = IDLE;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'b00;
        end else begin
            if (state >= COUNT1 && state <= COUNT4) begin
                count <= count + 1'b1;
            end else begin
                count <= 2'b00;
            end
        end
    end

    assign shift_ena = (state >= COUNT1 && state <= COUNT4) || reset;

endmodule