module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    // Define states
    parameter IDLE = 2'b00;
    parameter BYTE1 = 2'b01;
    parameter BYTE2 = 2'b10;
    parameter BYTE3 = 2'b11;

    // State register
    reg [1:0] state;

    // FSM logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (in[3]) begin
                        state <= BYTE1;
                    end
                end
                BYTE1: begin
                    done <= 1'b0;
                    state <= BYTE2;
                end
                BYTE2: begin
                    done <= 1'b0;
                    state <= BYTE3;
                end
                BYTE3: begin
                    done <= 1'b1;
                    state <= IDLE;
                end
                default: begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule