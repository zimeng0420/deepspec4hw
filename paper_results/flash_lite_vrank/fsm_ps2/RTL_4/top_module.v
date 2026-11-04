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

    reg [1:0] state;
    reg [1:0] next_state;
    reg [7:0] byte1, byte2, byte3;
    reg [1:0] byte_count; // count the bytes received for a message
    reg done_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_reg <= 1'b0;
            byte_count <= 2'b00;
        end else begin
            state <= next_state;
            done_reg <= (state == GOT_THIRD);
            if(state == GOT_FIRST) begin
              byte_count <= 2'b01;
            end
            else if(state == GOT_SECOND) begin
              byte_count <= 2'b10;
            end
            else if (state == GOT_THIRD) begin
              byte_count <= 2'b00;
            end

        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = GOT_FIRST;
                    byte1 = in;
                end else begin
                    next_state = IDLE;
                end
            end
            GOT_FIRST: begin
                next_state = GOT_SECOND;
                byte2 = in;
            end
            GOT_SECOND: begin
                next_state = GOT_THIRD;
                byte3 = in;
            end
            GOT_THIRD: begin
                next_state = IDLE;
            end
        endcase
    end

    assign done = done_reg;

endmodule