module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output done
);

    reg [1:0] state, next_state;
    reg done_reg;
    
    localparam [1:0] IDLE = 2'd0,
                     BYTE1 = 2'd1,
                     BYTE2 = 2'd2,
                     BYTE3 = 2'd3;

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
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    next_state = BYTE1;
                end else begin
                    next_state = IDLE;
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
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    assign done = done_reg;

endmodule