module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    reg [1:0] state; // 2-bit state variable
    localparam IDLE = 2'b00, BYTE1 = 2'b01, BYTE2 = 2'b10, BYTE3 = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        state <= BYTE1;
                        done <= 0; // Reset done as we are starting a new message
                    end
                end
                
                BYTE1: begin
                    state <= BYTE2;
                end
                
                BYTE2: begin
                    state <= BYTE3;
                end
                
                BYTE3: begin
                    done <= 1; // Signal done after receiving third byte
                    state <= IDLE; // Go back to IDLE
                end
                
                default: state <= IDLE; // Should not reach here
            endcase
        end
    end

endmodule