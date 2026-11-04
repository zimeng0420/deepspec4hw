module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] state, next_state;
    reg [23:0] message;
    reg [7:0] byte1, byte2;
    parameter IDLE = 2'b00, BYTE2 = 2'b01, BYTE3 = 2'b10, DONE = 2'b11;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in[3] == 1)
                    next_state = BYTE2;
                else
                    next_state = IDLE;
            end
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = DONE;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic and data capture
    always @(posedge clk) begin
        if (reset) begin
            byte1 <= 8'h00;
            byte2 <= 8'h00;
            message <= 24'h000000;
            done <= 0;
            out_bytes <= 24'hXXXXXX;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1)
                        byte1 <= in; // Capture first byte
                    done <= 0;
                end
                BYTE2: byte2 <= in; // Capture second byte
                BYTE3: message <= { byte1, byte2, in }; // Capture third byte and form message
                DONE: begin
                    out_bytes <= message;
                    done <= 1; 
                end
            endcase
        end
    end
endmodule