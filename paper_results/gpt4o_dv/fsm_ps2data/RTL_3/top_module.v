module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        BYTE3 = 2'b11
    } state_t;

    reg [7:0] byte_reg1, byte_reg2, byte_reg3;
    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_bytes <= 24'b0;
            done <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            byte_reg1 <= 8'b0;
            byte_reg2 <= 8'b0;
            byte_reg3 <= 8'b0;
        end else begin
            case (state)
                BYTE1: byte_reg1 <= in;
                BYTE2: byte_reg2 <= in;
                BYTE3: byte_reg3 <= in;
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        done = 0; // Default done signal

        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE1;
                end
            end
            BYTE1: begin
                next_state = BYTE2;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                out_bytes = {byte_reg1, byte_reg2, in}; // Assemble and capture
                done = 1; // Message complete
                next_state = IDLE;
            end
        endcase
    end

endmodule