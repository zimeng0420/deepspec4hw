module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    reg [1:0] state, next_state;

    localparam [1:0] 
        WAIT_FOR_FIRST_BYTE = 2'b00, 
        BYTE_1_RECEIVED    = 2'b01, 
        BYTE_2_RECEIVED    = 2'b10, 
        BYTE_3_RECEIVED    = 2'b11;

    // State transition logic
    always @(*) begin
        case (state)
            WAIT_FOR_FIRST_BYTE: begin
                if (in[3] == 1) begin
                    next_state = BYTE_1_RECEIVED;
                end else begin
                    next_state = WAIT_FOR_FIRST_BYTE;
                end
            end
            BYTE_1_RECEIVED: begin
                next_state = BYTE_2_RECEIVED;
            end
            BYTE_2_RECEIVED: begin
                next_state = BYTE_3_RECEIVED;
            end
            BYTE_3_RECEIVED: begin
                if (in[3] == 1) begin
                    next_state = BYTE_1_RECEIVED;
                end else begin
                    next_state = WAIT_FOR_FIRST_BYTE;
                end
            end
        endcase
    end

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_FIRST_BYTE;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    always @(*) begin
        done = (state == BYTE_2_RECEIVED);
    end

endmodule