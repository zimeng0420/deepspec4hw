module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] state;
    reg [2:0] byte_count;

    localparam IDLE = 2'b00, BYTE1 = 2'b01, BYTE2 = 2'b10, BYTE3 = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 0;
            out_bytes <= 24'b0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1'b1) begin
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
                    done <= 0;
                end
                
                BYTE2: begin
                    state <= BYTE3;
                    out_bytes[7:0] <= in;
                    byte_count <= byte_count + 1;
                    done <= 0;
                end
                
                BYTE3: begin
                    if (byte_count == 2) begin
                        done <= 1;
                    end
                    if (in[3] == 1'b1) begin
                        state <= BYTE1;
                        out_bytes[23:16] <= in;
                        byte_count <= 1;
                    end else begin
                        done <= 0;
                        state <= IDLE;
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end

    always @(negedge clk) begin
        if (done) begin
            // Additional logic can be added if needed on done
        end
    end

endmodule