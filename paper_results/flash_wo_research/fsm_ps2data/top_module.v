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

    localparam SEARCHING = 3'b000;
    localparam BYTE1_RECEIVED = 3'b001;
    localparam BYTE2_RECEIVED = 3'b010;
    localparam BYTE3_RECEIVED = 3'b011;

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCHING;
            out_bytes_reg <= 0;
            done_reg <= 0;
        end else begin
            case (state)
                SEARCHING: begin
                    done_reg <= 0;
                    if (in[3]) begin
                        state <= BYTE1_RECEIVED;
                        out_bytes_reg[23:16] <= in;
                    end
                end
                BYTE1_RECEIVED: begin
                    state <= BYTE2_RECEIVED;
                    out_bytes_reg[15:8] <= in;
                    done_reg <= 0;
                end
                BYTE2_RECEIVED: begin
                    state <= BYTE3_RECEIVED;
                    out_bytes_reg[7:0] <= in;
                    done_reg <= 0;
                end
                BYTE3_RECEIVED: begin
                    state <= SEARCHING;
                    done_reg <= 1;
                end
                default: begin
                    state <= SEARCHING;
                    done_reg <= 0;
                end
            endcase
        end
    end

    assign out_bytes = out_bytes_reg;
    assign done = done_reg;

endmodule