module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output done
);

    parameter IDLE = 0;
    parameter BYTE1 = 1;
    parameter BYTE2 = 2;
    parameter BYTE3 = 3;

    reg [1:0] state;
    reg [1:0] next_state;
    reg [7:0] byte1, byte2, byte3;
    reg done_r;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_r <= 1'b0;
        end else begin
            state <= next_state;
            if (state == BYTE3)
                done_r <= 1'b1;
            else
                done_r <= 1'b0;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE1;
                    byte1 = in;
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

    assign done = done_r;

endmodule