module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output reg done
);

    // State encoding
    reg [1:0] state, next_state;
    reg [1:0] byte_count; // To count received bytes

    // State encoding
    localparam WAIT_FOR_START = 2'd0,
               BYTE1_RECEIVED = 2'd1,
               BYTE2_RECEIVED = 2'd2,
               BYTE3_RECEIVED = 2'd3;

    // Sequential logic for state transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_START;
            byte_count <= 2'd0;
            done <= 0;
        end else begin
            state <= next_state;
            if (in[3] == 1'b1 && state == WAIT_FOR_START) begin
                byte_count <= 2'd1;
                done <= 0;
            end else if (state == BYTE1_RECEIVED || state == BYTE2_RECEIVED) begin
                byte_count <= byte_count + 1;
                done <= 0;
            end else if (state == BYTE3_RECEIVED) begin
                byte_count <= 2'd0;
                done <= 1;
            end else begin
                done <= 0;
            end
        end
    end

    // Combinational logic for state transition conditions
    always @(*) begin
        case (state)
            WAIT_FOR_START: 
                if (in[3] == 1'b1)
                    next_state = BYTE1_RECEIVED;
                else
                    next_state = WAIT_FOR_START;
            BYTE1_RECEIVED: 
                next_state = BYTE2_RECEIVED;
            BYTE2_RECEIVED: 
                next_state = BYTE3_RECEIVED;
            BYTE3_RECEIVED: 
                next_state = WAIT_FOR_START;
            default: 
                next_state = WAIT_FOR_START;
        endcase
    end

endmodule