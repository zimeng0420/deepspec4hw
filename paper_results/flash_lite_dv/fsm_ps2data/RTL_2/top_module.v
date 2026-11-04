module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output [23:0] out_bytes,
    output done
);

    // States
    parameter IDLE = 2'b00;
    parameter BYTE1 = 2'b01;
    parameter BYTE2 = 2'b10;
    parameter BYTE3 = 2'b11;

    // State register
    reg [1:0] state;

    // Byte storage registers
    reg [7:0] byte1;
    reg [7:0] byte2;
    reg [7:0] byte3;

    // Output register for out_bytes
    reg [23:0] out_bytes_reg;

    // Done signal register
    reg done_reg;

    // Combinational logic for next state and outputs
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done_reg <= 0;
                    if (in[3]) begin
                        state <= BYTE1;
                    end
                end
                BYTE1: begin
                    done_reg <= 0;
                    byte1 <= in;
                    state <= BYTE2;
                end
                BYTE2: begin
                    done_reg <= 0;
                    byte2 <= in;
                    state <= BYTE3;
                end
                BYTE3: begin
                    done_reg <= 1;
                    byte3 <= in;
                    out_bytes_reg <= {byte1, byte2, byte3};
                    state <= IDLE;
                end
                default: begin
                    state <= IDLE;
                    done_reg <= 0;
                end
            endcase
        end
    end

    // Assign output
    assign out_bytes = out_bytes_reg;
    assign done = done_reg;

endmodule