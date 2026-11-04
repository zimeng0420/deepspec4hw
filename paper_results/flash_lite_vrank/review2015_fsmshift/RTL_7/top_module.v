module top_module(
	input clk,
	input reset,
	output shift_ena
);

    parameter IDLE = 0, COUNT = 1;
    reg [1:0] state;
    reg [1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            state <= COUNT;
            count <= 4;
        end else begin
            case (state)
                IDLE: begin
                    shift_ena <= 0;
                end
                COUNT: begin
                    shift_ena <= 1;
                    count <= count - 1;
                    if (count == 1) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    always @(posedge clk) begin
        if (reset) begin
        end
    end

endmodule