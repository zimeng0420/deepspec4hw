module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    reg [1:0] state;
    reg [1:0] count;

    // State encoding
    localparam WAIT_FOR_START = 2'd0;
    localparam BYTE_1_RECEIVED = 2'd1;
    localparam BYTE_2_RECEIVED = 2'd2;
    localparam BYTE_3_RECEIVED = 2'd3;

    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_START;
            count <= 2'd0;
            done <= 1'b0;
        end else begin
            case (state)
                WAIT_FOR_START: begin
                    done <= 1'b0;
                    if (in[3] == 1'b1) begin
                        state <= BYTE_1_RECEIVED;
                        count <= 2'd1;
                    end
                end
                BYTE_1_RECEIVED: begin
                    count <= count + 1;
                    if (count == 3) begin
                        state <= BYTE_3_RECEIVED;
                    end
                end
                BYTE_2_RECEIVED: begin
                    count <= count + 1;
                    if (count == 3) begin
                        state <= BYTE_3_RECEIVED;
                    end
                end
                BYTE_3_RECEIVED: begin
                    done <= 1'b1;
                    state <= WAIT_FOR_START;
                    count <= 2'd0;
                end
            endcase
        end
    end
endmodule