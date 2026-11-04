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
    reg [2:0] next_state;
    reg [1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 2'b00;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (reset)
                    next_state = IDLE; // Stay in IDLE on reset
                else
                    next_state = (reset) ? IDLE : COUNT1;
            end

            COUNT1: begin
                next_state = (count == 2'b11) ? IDLE : COUNT2;
            end

            COUNT2: begin
                next_state = (count == 2'b11) ? IDLE : COUNT3;
            end
            
            COUNT3: begin
                next_state = (count == 2'b11) ? IDLE : COUNT4;
            end
            
            COUNT4: begin
                next_state = IDLE;
            end
            
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'b00;
        end else if (state >= COUNT1 && state <= COUNT4) begin
            count <= count + 1'b1;
        end else begin
            count <= 2'b00;
        end
    end

    assign shift_ena = (state >= COUNT1 && state <= COUNT4) ? 1'b1 : 1'b0;


endmodule