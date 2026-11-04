module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output [23:0] out_bytes,
    output done
);

    // State Definitions
    localparam IDLE = 2'b00;
    localparam BYTE1_RECEIVED = 2'b01;
    localparam BYTE2_RECEIVED = 2'b10;
    localparam DONE_STATE = 2'b11;

    // Internal Signals
    reg [1:0] state;
    reg [7:0] byte1;
    reg [7:0] byte2;
    reg [7:0] byte3;
    reg [23:0] out_bytes_internal;
    reg done_internal;

    // State Transition Logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_internal <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done_internal <= 1'b0;
                    if (in[3]) begin
                        state <= BYTE1_RECEIVED;
                    end else begin
                        state <= IDLE;
                    end
                end
                BYTE1_RECEIVED: begin
                    byte1 <= in;
                    state <= BYTE2_RECEIVED;
                end
                BYTE2_RECEIVED: begin
                    byte2 <= in;
                    state <= DONE_STATE;
                end
                DONE_STATE: begin
                    byte3 <= in;
                    done_internal <= 1'b1;
                    state <= IDLE;
                end
                default: begin
                    state <= IDLE;
                    done_internal <= 1'b0;
                end
            endcase
        end
    end
    
    always @(posedge clk) begin
        if (reset) begin
            out_bytes_internal <= 24'b0;
        end else begin
        case (state)
            BYTE2_RECEIVED: begin
                out_bytes_internal <= {byte1, byte2, in};
            end
            DONE_STATE: begin
               out_bytes_internal <= {byte1, byte2, byte3};
            end
            default: begin
                out_bytes_internal <= out_bytes_internal; // Keep previous value, or don't care.
            end
        endcase
        end
    end

    // Output Assignments
    assign out_bytes = out_bytes_internal;
    assign done = done_internal;

endmodule