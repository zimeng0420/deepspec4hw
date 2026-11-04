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

    // Synchronous logic for state transitions and done signal
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
                    end else begin
                        state <= IDLE;
                    end
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
                    done <= 1'b1; // Assert done for one cycle
                end
                default: begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule