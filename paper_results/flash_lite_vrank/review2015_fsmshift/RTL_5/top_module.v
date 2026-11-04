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
    reg [1:0] count;
    reg shift_ena_internal;

    always @(posedge clk) begin
        if (reset) begin
            state <= COUNT1;
            count <= 2'b00;
            shift_ena_internal <= 1'b1;
        end else begin
            case (state)
                IDLE: begin
                    shift_ena_internal <= 1'b0;
                    count <= 2'b00;
                end
                COUNT1: begin
                    shift_ena_internal <= 1'b1;
                    count <= count + 1'b1;
                    state <= COUNT2;
                end
                COUNT2: begin
                    shift_ena_internal <= 1'b1;
                    count <= count + 1'b1;
                    state <= COUNT3;
                end
                COUNT3: begin
                    shift_ena_internal <= 1'b1;
                    count <= count + 1'b1;
                    state <= COUNT4;
                end
                COUNT4: begin
                    shift_ena_internal <= 1'b1;
                    count <= count + 1'b1;
                    state <= IDLE;
                end
                default: begin
                    shift_ena_internal <= 1'b0;
                    count <= 2'b00;
                    state <= IDLE;
                end
            endcase
        end
    end

    assign shift_ena = shift_ena_internal;

endmodule