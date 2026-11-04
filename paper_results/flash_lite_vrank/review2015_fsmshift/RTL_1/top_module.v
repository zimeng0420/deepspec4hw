module top_module(
	input clk,
	input reset,
	output shift_ena
);

    parameter IDLE = 0;
    parameter COUNT1 = 1;
    parameter COUNT2 = 2;
    parameter COUNT3 = 3;
    parameter COUNT4 = 4;

    reg [2:0] state;
    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            state <= COUNT1;
            count <= 1;
        end else begin
            case (state)
                IDLE: begin
                    state <= IDLE;
                    count <= 0;
                end
                COUNT1: begin
                    state <= COUNT2;
                    count <= 2;
                end
                COUNT2: begin
                    state <= COUNT3;
                    count <= 3;
                end
                COUNT3: begin
                    state <= COUNT4;
                    count <= 4;
                end
                COUNT4: begin
                    state <= IDLE;
                    count <= 0;
                end
                default: begin
                    state <= IDLE;
                    count <= 0;
                end
            endcase
        end
    end

    assign shift_ena = (state != IDLE);

endmodule