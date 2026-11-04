module top_module(
	input clk,
	input reset,
	input data,
	output start_shifting);

    parameter IDLE = 0;
    parameter S1 = 1;
    parameter S11 = 2;
    parameter S110 = 3;
    parameter S1101 = 4;

    reg [2:0] state;
    reg [2:0] next_state;
    reg start_shifting_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            start_shifting_reg <= 0;
        end else begin
            state <= next_state;
            start_shifting_reg <= start_shifting_reg;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (data)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1: begin
                if (data)
                    next_state = S11;
                else
                    next_state = IDLE;
            end
            S11: begin
                if (data)
                    next_state = S11;
                else
                    next_state = S110;
            end
            S110: begin
                if (data)
                    next_state = S1101;
                else
                    next_state = IDLE;
            end
            S1101: begin
                next_state = S1101;
                start_shifting_reg = 1;
            end
            default:
                next_state = IDLE;
        endcase
    end
    
    assign start_shifting = start_shifting_reg;
endmodule