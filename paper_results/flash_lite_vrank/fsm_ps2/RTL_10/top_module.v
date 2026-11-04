module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output done
);

    parameter IDLE = 2'b00;
    parameter BYTE1 = 2'b01;
    parameter BYTE2 = 2'b10;
    parameter BYTE3 = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;
    reg [7:0] byte1, byte2, byte3; // Store the received bytes
    reg [1:0] byte_count; // To keep track of byte received (1, 2, or 3)

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            byte_count <= 2'b00; // Reset byte counter
        end else begin
            state <= next_state;
            done <= (state == BYTE3) ? 1'b1 : 1'b0; // Signal done at the end of byte3
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE1;
                    byte_count = 2'b01;
                    byte1 = in;
                end
            end
            BYTE1: begin
                next_state = BYTE2;
                byte2 = in;
                byte_count = 2'b10;
            end
            BYTE2: begin
                next_state = BYTE3;
                byte3 = in;
                byte_count = 2'b11;
            end
            BYTE3: begin
                next_state = IDLE;
                byte_count = 2'b00;
            end
            default:
                next_state = IDLE;
        endcase
    end
endmodule