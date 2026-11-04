module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output [23:0] out_bytes,
	output done
);

    parameter IDLE = 0, READ1 = 1, READ2 = 2, DONE_STATE = 3;
    reg [1:0] state, next_state;
    reg [23:0] message;
    reg [7:0] byte1, byte2, byte3;
    
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    always @(*) begin
        next_state = state;
        done = 0;
        out_bytes = 24'b0;

        case (state)
            IDLE: begin
                if (in[3])
                    next_state = READ1;
            end
            READ1: begin
                byte1 = in;
                next_state = READ2;
            end
            READ2: begin
                byte2 = in;
                next_state = DONE_STATE;
            end
            DONE_STATE: begin
                byte3 = in;
                done = 1;
                message = {byte1, byte2, byte3};
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
    
    always @(*) begin
        if (done)
            out_bytes = message;
        else
            out_bytes = 24'b0;
    end
    
endmodule