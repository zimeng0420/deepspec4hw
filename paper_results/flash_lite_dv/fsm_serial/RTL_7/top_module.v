module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // States
    parameter IDLE       = 3'b000;
    parameter START_BIT  = 3'b001;
    parameter DATA_BITS  = 3'b010;
    parameter STOP_BIT   = 3'b011;
    parameter ERROR      = 3'b100;

    // State register
    reg [2:0] state;

    // Data bit counter
    reg [2:0] bit_count;

    // Internal signals
    reg data_bit;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b000;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (!in) begin  // Start bit detected (0)
                        state <= START_BIT;
                    end
                end
                START_BIT: begin
                    state <= DATA_BITS;
                end
                DATA_BITS: begin
                    data_bit <= in; // Capture the data bit
                    if (bit_count == 3'b111) begin // 8 data bits received
                        state <= STOP_BIT;
                        bit_count <= 3'b000;
                    end else begin
                        state <= DATA_BITS;
                        bit_count <= bit_count + 1'b1;
                    end
                end
                STOP_BIT: begin
                    if (in) begin // Stop bit valid (1)
                        state <= IDLE;
                        done <= 1'b1;
                    end else begin // Stop bit invalid (0)
                        state <= ERROR;
                    end
                end
                ERROR: begin
                    done <= 1'b0;
                    if (in) begin // Wait for valid stop bit (1)
                        state <= IDLE;
                    end else begin
                        state <= ERROR;
                    end
                end
                default: begin
                    state <= IDLE; // Default to IDLE
                    bit_count <= 3'b000;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule