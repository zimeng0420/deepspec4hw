module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    // Define states
    localparam IDLE = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;
    localparam BYTE3 = 2'b11;

    // Define state register
    reg [1:0] state;

    // State transition logic and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        state <= BYTE1;
                    end
                    done <= 1'b0;
                end
                BYTE1: begin
                    state <= BYTE2;
                    done <= 1'b0;
                end
                BYTE2: begin
                    state <= BYTE3;
                    done <= 1'b0;
                end
                BYTE3: begin
                    state <= IDLE;
                    done <= 1'b1;
                end
                default: begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            endcase
        end
    end
endmodule