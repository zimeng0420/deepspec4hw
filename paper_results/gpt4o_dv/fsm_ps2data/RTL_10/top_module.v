module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    typedef enum reg [1:0] {IDLE, BYTE1, BYTE2, BYTE3} state_t;
    state_t state, next_state;

    reg [7:0] byte1, byte2, byte3;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'h00;
            byte2 <= 8'h00;
            byte3 <= 8'h00;
            out_bytes <= 24'h000000;
            done <= 0;
        end else begin
            state <= next_state;
            if (done) begin
                out_bytes <= {byte1, byte2, byte3};
            end
        end
    end

    always @(*) begin
        done = 0;
        next_state = state;
        case (state)
            IDLE: begin
                if (in[3]) begin
                    byte1 = in;
                    next_state = BYTE1;
                end
            end
            BYTE1: begin
                byte2 = in;
                next_state = BYTE2;
            end
            BYTE2: begin
                byte3 = in;
                next_state = BYTE3;
            end
            BYTE3: begin
                done = 1;
                next_state = IDLE;
            end
        endcase
    end

endmodule