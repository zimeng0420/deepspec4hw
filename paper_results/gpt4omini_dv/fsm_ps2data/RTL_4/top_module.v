module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] state;
    reg [2:0] byte_count;

    localparam IDLE = 2'b00,
               RECEIVE = 2'b01,
               DONE = 2'b10;

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
                        state <= RECEIVE;
                        byte_count <= 1;
                        out_bytes[23:16] <= in;
                        done <= 0;
                    end
                end

                RECEIVE: begin
                    if (byte_count < 3) begin
                        if (in[3] == 1) begin
                            // This could potentially be another start byte, reset byte count if needed
                            byte_count <= 1;
                            out_bytes[23:16] <= in;
                        end else begin
                            case (byte_count)
                                1: out_bytes[15:8] <= in;
                                2: out_bytes[7:0] <= in;
                            endcase
                            byte_count <= byte_count + 1;
                        end
                    end else begin
                        state <= DONE;
                        done <= 1;
                    end
                end

                DONE: begin
                    done <= 0; // Signal done in the cycle immediately after the third byte is received
                    state <= IDLE; // Prepare for the next message
                end
            endcase
        end
    end
endmodule