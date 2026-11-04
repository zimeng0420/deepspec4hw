module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output [23:0] out_bytes,
    output done
);

    reg [23:0] out_bytes_r;
    reg done_r;

    reg [1:0] state;
    localparam IDLE = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;
    localparam BYTE3 = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_bytes_r <= 0;
            done_r <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done_r <= 0;
                    if (in[3]) begin
                        out_bytes_r[23:16] <= in;
                        state <= BYTE1;
                    end
                end
                BYTE1: begin
                    out_bytes_r[15:8] <= in;
                    state <= BYTE2;
                end
                BYTE2: begin
                    out_bytes_r[7:0] <= in;
                    state <= BYTE3;
                end
                BYTE3: begin
                    done_r <= 1;
                    state <= IDLE;
                end
                default: begin
                    state <= IDLE;
                    done_r <= 0;
                end
            endcase
        end
    end

    assign out_bytes = out_bytes_r;
    assign done = done_r;

endmodule