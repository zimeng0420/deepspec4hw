module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] state, next_state;
    reg [23:0] buf;

    // State Encoding
    localparam [1:0] 
        IDLE = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        BYTE3 = 2'b11;

    // State Transition
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next State Logic and Output Logic
    always @(*) begin
        next_state = state;
        done = 1'b0;
        case (state)
            IDLE: begin
                if (in[3] == 1) begin
                    next_state = BYTE1;
                    buf[23:16] = in;
                end
            end
            BYTE1: begin
                buf[15:8] = in;
                next_state = BYTE2;
            end
            BYTE2: begin
                buf[7:0] = in;
                next_state = BYTE3;
            end
            BYTE3: begin
                out_bytes = buf;
                done = 1'b1;
                if (in[3] == 1)
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end
        endcase
    end

    // Output Logic
    always @(posedge clk) begin
        if (state == BYTE3) begin
            out_bytes <= buf;
        end
    end

endmodule