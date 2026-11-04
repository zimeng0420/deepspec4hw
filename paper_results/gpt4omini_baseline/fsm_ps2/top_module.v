module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    reg [1:0] state; // 2 bits for 3 states (IDLE, BYTE1, BYTE2)
    parameter IDLE = 2'b00, BYTE1 = 2'b01, BYTE2 = 2'b10;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0; // not done in IDLE
                    if (in[3] == 1) 
                        state <= BYTE1; // transition to BYTE1
                end
                BYTE1: begin
                    if (in[3] == 1) 
                        state <= BYTE1; // keep in BYTE1 if in[3] is still 1
                    else 
                        state <= BYTE2; // transition to BYTE2
                end
                BYTE2: begin
                    done <= 1; // signal done for this cycle
                    state <= IDLE; // transition back to IDLE to look for new message
                end
            endcase
        end
    end

endmodule