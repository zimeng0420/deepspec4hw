module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    // State Definitions
    parameter IDLE = 0;
    parameter BYTE1 = 1;
    parameter BYTE2 = 2;
    parameter BYTE3 = 3;

    // State Register
    reg [1:0] state;

    // Internal Registers
    reg [7:0] byte1;
    reg [7:0] byte2;
    reg [2:0] byte_count;

    // State Transition Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            byte_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (in[3]) begin
                        state <= BYTE1;
                        byte_count <= 1;
                        byte1 <= in;
                    end
                end
                BYTE1: begin
                    done <= 0;
                    byte2 <= in;
                    state <= BYTE2;
                    byte_count <= 2;
                end
                BYTE2: begin
                    done <= 0;
                    out_bytes[23:16] <= byte1;
                    out_bytes[15:8] <= byte2;
                    out_bytes[7:0] <= in;
                    state <= BYTE3;
                    byte_count <= 3;
                end
                BYTE3: begin
                    done <= 1;
                    state <= IDLE;
                    byte_count <= 0;
                end
                default: begin
                    state <= IDLE;
                    done <= 0;
                    byte_count <= 0;
                end
            endcase
        end
    end
endmodule