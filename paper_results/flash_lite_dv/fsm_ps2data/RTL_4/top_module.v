module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output [23:0] out_bytes,
    output done
);

    parameter IDLE = 2'b00;
    parameter BYTE1_RECEIVED = 2'b01;
    parameter BYTE2_RECEIVED = 2'b10;
    parameter DONE_STATE = 2'b11;

    reg [1:0] state;
    reg [7:0] byte1, byte2, byte3;
    reg [23:0] out_bytes_reg;
    reg done_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                        state <= BYTE1_RECEIVED;
                    end
                    done_reg <= 0;
                end
                BYTE1_RECEIVED: begin
                    byte2 <= in;
                    state <= BYTE2_RECEIVED;
                    done_reg <= 0;
                end
                BYTE2_RECEIVED: begin
                    byte3 <= in;
                    out_bytes_reg <= {byte1, byte2, byte3};
                    state <= DONE_STATE;
                    done_reg <= 1;
                end
                DONE_STATE: begin
                    state <= IDLE;
                    done_reg <= 0;
                end
            endcase
        end
    end

    assign out_bytes = (done_reg) ? out_bytes_reg : 24'b0;
    assign done = done_reg;

endmodule