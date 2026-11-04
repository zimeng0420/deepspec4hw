module top_module(
	input clk,
	input reset,
	output shift_ena
);

    parameter IDLE = 0;
    parameter SHIFTING = 1;
    parameter DONE = 2;

    reg [1:0] state;
    reg [1:0] shift_count;
    reg shift_ena_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 2'b00;
            shift_ena_reg <= 1'b1; // Assert shift_ena for the first cycle after reset
        end else begin
            case (state)
                IDLE: begin
                    shift_ena_reg <= 1'b0;
                    state <= (shift_ena_reg == 1'b0) ? IDLE : SHIFTING;
                end
                SHIFTING: begin
                    shift_ena_reg <= 1'b1;
                    shift_count <= shift_count + 1'b1;
                    if (shift_count == 2'b11) begin
                        state <= DONE;
                    end
                end
                DONE: begin
                    shift_ena_reg <= 1'b0;
                    state <= IDLE;
                    shift_count <= 2'b00;
                end
            endcase
        end
    end

    assign shift_ena = (reset) ? shift_ena_reg : (state == SHIFTING) ? shift_ena_reg : 1'b0;

endmodule