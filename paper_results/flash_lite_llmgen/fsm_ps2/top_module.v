module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    // State Definitions
    localparam IDLE = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;
    localparam BYTE3 = 2'b11;

    // State Register
    reg [1:0] state;

    // Internal Signals
    reg [7:0] byte1, byte2, byte3; // Store the bytes if needed for debugging or further processing

    // State Transition Logic
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
                    byte1 <= in; // Store the first byte (optional)
                    state <= BYTE2;
                    done <= 1'b0;
                end
                BYTE2: begin
                    byte2 <= in; // Store the second byte (optional)
                    state <= BYTE3;
                    done <= 1'b0;
                end
                BYTE3: begin
                    byte3 <= in; // Store the third byte (optional)
                    state <= IDLE;
                    done <= 1'b1; // Assert done for one cycle
                end
                default: begin
                    state <= IDLE; // Default to IDLE for safety
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule