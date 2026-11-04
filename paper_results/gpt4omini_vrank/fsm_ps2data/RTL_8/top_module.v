module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);
    reg [1:0] state;
    reg [1:0] byte_count;

    localparam IDLE = 2'b00,
               RECEIVING = 2'b01,
               COMPLETE = 2'b10;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 0;
            out_bytes <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        state <= RECEIVING;
                        byte_count <= 0;
                        out_bytes <= {16'b0, in}; // Start first byte
                        done <= 0;
                    end
                end

                RECEIVING: begin
                    if (byte_count < 2) begin
                        byte_count <= byte_count + 1;
                        out_bytes <= {out_bytes[23:8], in}; // Shift in next byte
                    end else begin
                        state <= COMPLETE;
                    end
                end

                COMPLETE: begin
                    done <= 1; // Signal done after receiving 3 bytes
                    if (in[3] == 1) begin // Check for a new message start
                        state <= RECEIVING;
                        byte_count <= 0;
                        out_bytes <= {16'b0, in}; // Start next message
                        done <= 0;
                    end
                end
                
                default: begin
                    state <= IDLE; // Fallback to IDLE
                end
            endcase
        end
    end
endmodule