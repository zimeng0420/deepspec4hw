module top_module(
	input x,
	input y,
	output z
);

    reg z_internal;
    reg [6:0] state;
    parameter IDLE = 7'd0;
    parameter STATE_1 = 7'd1;
    parameter STATE_2 = 7'd2;
    parameter STATE_3 = 7'd3;
    parameter STATE_4 = 7'd4;
    parameter STATE_5 = 7'd5;
    parameter STATE_6 = 7'd6;
    parameter STATE_7 = 7'd7;
    parameter STATE_8 = 7'd8;
    parameter STATE_9 = 7'd9;
    parameter STATE_10 = 7'd10;
    parameter STATE_11 = 7'd11;
    parameter STATE_12 = 7'd12;
    parameter STATE_13 = 7'd13;
    parameter STATE_14 = 7'd14;
    parameter STATE_15 = 7'd15;
    parameter STATE_16 = 7'd16;
    parameter STATE_17 = 7'd17;
    parameter STATE_18 = 7'd18;
    parameter STATE_19 = 7'd19;

    reg clk;
    reg rst;

    parameter CLK_PERIOD = 5;

    always # (CLK_PERIOD/2) clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        #10 rst = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z_internal <= 1'b1;
        end else begin
            case (state)
                IDLE: begin
                    z_internal <= 1'b1;
                    state <= STATE_1;
                end
                STATE_1: begin
                    z_internal <= 1'b1;
                    state <= STATE_2;
                end
                STATE_2: begin
                    z_internal <= 1'b1;
                    state <= STATE_3;
                end
                STATE_3: begin
                    z_internal <= 1'b1;
                    state <= STATE_4;
                end
                STATE_4: begin
                    z_internal <= 1'b1;
                    state <= STATE_5;
                end
                STATE_5: begin
                    z_internal <= 1'b0;
                    state <= STATE_6;
                end
                STATE_6: begin
                    z_internal <= 1'b0;
                    state <= STATE_7;
                end
                STATE_7: begin
                    z_internal <= 1'b0;
                    state <= STATE_8;
                end
                STATE_8: begin
                    z_internal <= 1'b0;
                    state <= STATE_9;
                end
                STATE_9: begin
                    z_internal <= 1'b1;
                    state <= STATE_10;
                end
                STATE_10: begin
                    z_internal <= 1'b1;
                    state <= STATE_11;
                end
                STATE_11: begin
                    z_internal <= 1'b1;
                    state <= STATE_12;
                end
                STATE_12: begin
                    z_internal <= 1'b0;
                    state <= STATE_13;
                end
                STATE_13: begin
                    z_internal <= 1'b0;
                    state <= STATE_14;
                end
                STATE_14: begin
                    z_internal <= 1'b0;
                    state <= STATE_15;
                end
                STATE_15: begin
                    z_internal <= 1'b1;
                    state <= STATE_16;
                end
                STATE_16: begin
                    z_internal <= 1'b0;
                    state <= STATE_17;
                end
                STATE_17: begin
                    z_internal <= 1'b0;
                    state <= STATE_18;
                end
                STATE_18: begin
                    z_internal <= 1'b0;
                    state <= STATE_19;
                end
                STATE_19: begin
                    z_internal <= 1'b0;
                    state <= IDLE;
                end
                default: begin
                    z_internal <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

    always @(*) begin
        z = z_internal;
    end

endmodule