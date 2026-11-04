module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output [23:0] out_bytes,
    output done
);

    // State Definitions
    parameter IDLE = 0;
    parameter BYTE1_RECEIVED = 1;
    parameter BYTE2_RECEIVED = 2;
    parameter BYTE3_RECEIVED = 3;

    // Internal Signals
    reg [1:0] state;
    reg [7:0] byte1;
    reg [7:0] byte2;
    reg [7:0] byte3;
    reg [23:0] out_bytes_internal;
    reg done_internal;
    reg [1:0] byte_count;

    // State Transition Logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_internal <= 0;
            byte_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done_internal <= 0;
                    byte_count <= 0;
                    if (in[3]) begin
                        state <= BYTE1_RECEIVED;
                        byte1 <= in;
                    end
                end
                BYTE1_RECEIVED: begin
                    byte_count <= 1;
                    done_internal <= 0;
                    state <= BYTE2_RECEIVED;
                    byte2 <= in;
                end
                BYTE2_RECEIVED: begin
                    byte_count <= 2;
                    done_internal <= 0;
                    state <= BYTE3_RECEIVED;
                    byte3 <= in;
                end
                BYTE3_RECEIVED: begin
                    byte_count <= 3;
                    done_internal <= 1;
                    state <= IDLE;

                end
            endcase
        end
    end

    // Output Logic
    always @(posedge clk) begin
        if (reset) begin
            out_bytes_internal <= 0;
        end else begin
            if (done_internal) begin
                out_bytes_internal <= {byte1, byte2, byte3};
            end else begin
                out_bytes_internal <= out_bytes_internal; // Keep previous value
            end
        end
    end

    assign out_bytes = out_bytes_internal;
    assign done = done_internal;

endmodule