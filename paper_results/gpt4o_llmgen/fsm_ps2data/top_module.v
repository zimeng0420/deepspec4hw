module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding
    typedef enum reg [2:0] {
        IDLE = 3'b000,
        BYTE1 = 3'b001,
        BYTE2 = 3'b010,
        BYTE3 = 3'b011,
        DONE = 3'b100
    } state_t;

    reg [2:0] current_state, next_state;
    reg [23:0] message;

    // State transition and data path logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 0;
            out_bytes <= 24'bx;
        end else begin
            current_state <= next_state;
            if (next_state == DONE) begin
                done <= 1;
                out_bytes <= message;
            end else begin
                done <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (in[3] == 1)
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end
            BYTE1: begin
                next_state = BYTE2;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                next_state = DONE;
            end
            DONE: begin
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Message data capturing logic
    always @(posedge clk) begin
        if (reset) begin
            message <= 24'b0;
        end else begin
            case (current_state)
                BYTE1: begin
                    message[23:16] <= in;
                end
                BYTE2: begin
                    message[15:8] <= in;
                end
                BYTE3: begin
                    message[7:0] <= in;
                end
                default: begin
                    message <= message; // Hold previous value, don't change
                end
            endcase
        end
    end

endmodule