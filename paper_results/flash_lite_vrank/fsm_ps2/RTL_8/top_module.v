module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output done
);

    parameter IDLE = 2'b00;
    parameter GOT_FIRST = 2'b01;
    parameter GOT_SECOND = 2'b10;
    parameter GOT_THIRD = 2'b11;

    reg [1:0] state, next_state;
    reg [1:0] byte_count;
    reg [7:0] byte1, byte2, byte3;
    reg done_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 2'b00;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            done_reg <= (state == GOT_THIRD);
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = GOT_FIRST;
                end
            end
            GOT_FIRST: begin
                next_state = GOT_SECOND;
            end
            GOT_SECOND: begin
                next_state = GOT_THIRD;
            end
            GOT_THIRD: begin
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    assign done = done_reg;

endmodule