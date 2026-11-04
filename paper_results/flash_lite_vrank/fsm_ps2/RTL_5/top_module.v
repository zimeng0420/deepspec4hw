module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output done
);

    parameter IDLE = 2'b00;
    parameter FIRST_BYTE = 2'b01;
    parameter SECOND_BYTE = 2'b10;
    parameter THIRD_BYTE = 2'b11;

    reg [1:0] state, next_state;
    reg [7:0] byte1, byte2, byte3;
    reg [1:0] byte_count;
    reg done_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_reg <= 1'b0;
            byte_count <= 2'b00;
        end else begin
            state <= next_state;
            done_reg <= 1'b0;  // Reset done on every clock cycle.
        end
    end

    // Next state logic and output logic
    always @(*) begin
        next_state = state;
        done = 1'b0;
        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = FIRST_BYTE;
                    byte_count = 2'b01;
                    byte1 = in;
                end
            end
            FIRST_BYTE: begin
                next_state = SECOND_BYTE;
                byte_count = 2'b10;
                byte2 = in;
            end
            SECOND_BYTE: begin
                next_state = THIRD_BYTE;
                byte_count = 2'b11;
                byte3 = in;
            end
            THIRD_BYTE: begin
                next_state = IDLE;
                done = 1'b1;
                done_reg = 1'b1;

                byte_count = 2'b00;
            end
            default: next_state = IDLE;
        endcase
    end
    assign done = done_reg;


endmodule