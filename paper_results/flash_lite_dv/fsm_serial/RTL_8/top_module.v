module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // State Definitions
    parameter IDLE      = 3'b000;
    parameter START_BIT = 3'b001;
    parameter DATA_BITS = 3'b010;
    parameter STOP_BIT  = 3'b011;
    parameter ERROR     = 3'b100;

    // State Register
    reg [2:0] state;

    // Data Bit Counter
    reg [2:0] bit_count;

    // Internal Signals
    reg data_bit;


    // FSM Logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            bit_count <= 3'b000;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (!in) begin  // Start bit detected
                        state <= START_BIT;
                    end
                end
                START_BIT: begin
                    state <= DATA_BITS;
                    bit_count <= 3'b000;
                end
                DATA_BITS: begin
                    data_bit <= in;
                    if (bit_count == 3'b111) begin // Received 8 bits
                        state <= STOP_BIT;
                    end else begin
                        state <= DATA_BITS;
                        bit_count <= bit_count + 1'b1;
                    end
                end
                STOP_BIT: begin
                    if (in) begin  // Stop bit valid
                        state <= IDLE;
                        done <= 1'b1;
                    end else begin  // Stop bit invalid
                        state <= ERROR;
                        done <= 1'b0;
                    end
                end
                ERROR: begin
                    done <= 1'b0;
                    if (in) begin  // Wait for stop bit
                        state <= IDLE;
                    end else begin
                        state <= ERROR;
                    end
                end
                default: begin
                    state <= IDLE;
                    done <= 1'b0;
                    bit_count <= 3'b000;
                end
            endcase
        end
    end

endmodule