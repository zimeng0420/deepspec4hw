module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output done
);

    parameter IDLE = 2'b00;
    parameter BYTE1 = 2'b01;
    parameter BYTE2 = 2'b10;
    parameter BYTE3 = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;
    reg [7:0] byte1, byte2, byte3;
    reg done_reg;


    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            done_reg <= (state == BYTE3);
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE1;
                end
            end
            BYTE1: begin
                next_state = BYTE2;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;


endmodule