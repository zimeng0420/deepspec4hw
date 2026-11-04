module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [2:0] state;
    reg [2:0] byte_count;

    localparam IDLE       = 3'b000;
    localparam BYTE1     = 3'b001;
    localparam BYTE2     = 3'b010;
    localparam BYTE3     = 3'b011;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 0;
            out_bytes <= 24'b0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        state <= BYTE1;
                        byte_count <= 1;
                        out_bytes[23:16] <= in;
                        done <= 0;
                    end
                end

                BYTE1: begin
                    state <= BYTE2;
                    out_bytes[15:8] <= in;
                    byte_count <= byte_count + 1;
                end

                BYTE2: begin
                    state <= BYTE3;
                    out_bytes[7:0] <= in;
                    byte_count <= byte_count + 1;
                end

                BYTE3: begin
                    done <= 1;
                    if (in[3] == 1) begin
                        out_bytes <= {out_bytes[15:0], in}; // Capture next message
                        byte_count <= 1; // Restart byte count
                        state <= BYTE1;
                    end else begin
                        state <= IDLE; // Go back to idle
                        byte_count <= 0; // Reset byte count
                    end
                end

                default: begin
                    state <= IDLE;
                    byte_count <= 0;
                    out_bytes <= 24'b0;
                    done <= 0;
                end
            endcase
        end
    end

endmodule