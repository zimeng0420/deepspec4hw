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
    reg [1:0] byte_count;
    reg done_internal;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 2'b00;
            done_internal <= 1'b0;
        end else begin
            state <= next_state;
            done_internal <= 1'b0;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = FIRST_BYTE;
                    byte_count = 2'b01; // reset to 1
                end
            end
            FIRST_BYTE: begin
                next_state = SECOND_BYTE;
                byte_count = 2'b10;
            end
            SECOND_BYTE: begin
                next_state = THIRD_BYTE;
                byte_count = 2'b11;
            end
            THIRD_BYTE: begin
                next_state = IDLE;
                done_internal = 1'b1;
                byte_count = 2'b00;
            end
            default: next_state = IDLE;
        endcase
    end

    assign done = done_internal;

endmodule