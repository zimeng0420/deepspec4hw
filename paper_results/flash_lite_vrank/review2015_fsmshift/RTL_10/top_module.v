module top_module(
	input clk,
	input reset,
	output shift_ena
);

    parameter IDLE = 2'b00;
    parameter COUNT1 = 2'b01;
    parameter COUNT2 = 2'b10;
    parameter COUNT3 = 2'b11;

    reg [1:0] state;
    reg [1:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counter <= 2'b00;
        end else begin
            case (state)
                IDLE: begin
                    state <= COUNT1;
                    counter <= 2'b01;
                end
                COUNT1: begin
                    state <= COUNT2;
                    counter <= counter + 1'b1;
                end
                COUNT2: begin
                    state <= COUNT3;
                    counter <= counter + 1'b1;
                end
                COUNT3: begin
                    state <= IDLE;
                    counter <= counter + 1'b1;
                end
                default: begin
                    state <= IDLE;
                    counter <= 2'b00;
                end
            endcase
        end
    end

    assign shift_ena = (counter > 2'b00) && (counter <= 2'b10);

endmodule