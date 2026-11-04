module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output [23:0] out_bytes,
    output done
);

    reg [2:0] state;
    reg [23:0] out_bytes_reg;
    reg done_reg;

    localparam IDLE = 0;
    localparam BYTE1 = 1;
    localparam BYTE2 = 2;
    localparam BYTE3 = 3;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_bytes_reg <= 0;
            done_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done_reg <= 0;
                    if (in[3]) begin
                        out_bytes_reg[23:16] <= in;
                        state <= BYTE1;
                    end
                end
                BYTE1: begin
                    out_bytes_reg[15:8] <= in;
                    state <= BYTE2;
                end
                BYTE2: begin
                    out_bytes_reg[7:0] <= in;
                    state <= BYTE3;
                end
                BYTE3: begin
                    done_reg <= 1;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

    assign out_bytes = out_bytes_reg;
    assign done = done_reg;

endmodule