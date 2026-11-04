module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output [23:0] out_bytes,
    output done
);

    // States
    parameter IDLE = 0;
    parameter BYTE1_RECEIVED = 1;
    parameter BYTE2_RECEIVED = 2;
    parameter BYTE3_RECEIVED = 3;

    // Internal signals
    reg [1:0] state;
    reg [7:0] byte1, byte2, byte3;
    reg [23:0] out_bytes_internal;
    reg done_internal;
    reg [1:0] byte_count;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 0;
            done_internal <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                        state <= BYTE1_RECEIVED;
                        byte_count <= 1;
                        done_internal <= 0;
                    end else begin
                        state <= IDLE;
                        done_internal <= 0;
                    end
                end
                BYTE1_RECEIVED: begin
                    byte2 <= in;
                    state <= BYTE2_RECEIVED;
                    byte_count <= 2;
                    done_internal <= 0;
                end
                BYTE2_RECEIVED: begin
                    byte3 <= in;
                    state <= BYTE3_RECEIVED;
                    byte_count <= 3;
                    done_internal <= 1;
                end
                BYTE3_RECEIVED: begin
                    state <= IDLE;
                    byte_count <= 0;
                    done_internal <= 0;
                end
            endcase
        end
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) {
          out_bytes_internal <= 24'b0;
        } else begin
            if (done_internal) begin
                out_bytes_internal <= {byte1, byte2, byte3};
            end
        end
    end

    // Assign outputs
    assign out_bytes = out_bytes_internal;
    assign done = done_internal;

endmodule