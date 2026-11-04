module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);
    reg [1:0] state;
    reg [7:0] byte_counter;

    parameter IDLE = 2'b00,
              BYTE1 = 2'b01,
              BYTE2 = 2'b10,
              BYTE3 = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_counter <= 0;
            out_bytes <= 0;
            done <= 0;
        end else begin
            done <= 0;
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        state <= BYTE1;
                        byte_counter <= 1;
                        out_bytes[23:16] <= in;
                    end
                end

                BYTE1: begin
                    out_bytes[15:8] <= in;
                    state <= BYTE2;
                    byte_counter <= byte_counter + 1;
                end

                BYTE2: begin
                    out_bytes[7:0] <= in;
                    state <= BYTE3;
                    byte_counter <= byte_counter + 1;
                end

                BYTE3: begin
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule