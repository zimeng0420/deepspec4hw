module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Define states
    parameter IDLE = 0;
    parameter START_BIT = 1;
    parameter DATA_BITS = 2;
    parameter STOP_BIT = 3;
    parameter ERROR = 4;

    // State register
    reg [2:0] state;

    // Internal registers
    reg [7:0] data_buffer;
    reg [2:0] bit_count;
    reg in_prev; // store the previous value of in

    // Baud rate counter (assuming 16x oversampling for simplicity - not a true baud rate implementation)
    localparam BAUD_RATE_DIV = 16; // for example, for 16x oversampling.
    reg [3:0] baud_counter;
    wire baud_tick;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data_buffer <= 0;
            bit_count <= 0;
            done <= 0;
            baud_counter <= 0;
            in_prev <= 1; // Assuming idle is logic 1.
        end else begin
           in_prev <= in; // store the previous value of in
            case (state)
                IDLE: begin
                    done <= 0;
                    if (in_prev == 1 && in == 0) begin  // Start bit detected
                        state <= START_BIT;
                        baud_counter <= 0;
                    end
                end
                START_BIT: begin
                    if (baud_counter == BAUD_RATE_DIV - 1) begin
                        state <= DATA_BITS;
                        baud_counter <= 0;
                    end else begin
                       baud_counter <= baud_counter + 1;
                    end
                end

                DATA_BITS: begin
                    if (baud_counter == BAUD_RATE_DIV - 1) begin
                        data_buffer <= {in, data_buffer[7:1]}; // Shift in the new data bit
                        bit_count <= bit_count + 1;
                        baud_counter <= 0;

                        if (bit_count == 7) begin
                            state <= STOP_BIT;
                            bit_count <= 0;
                        end
                    end else begin
                        baud_counter <= baud_counter + 1;
                    end
                end
                STOP_BIT: begin
                    if (baud_counter == BAUD_RATE_DIV - 1) begin
                        if (in == 1) begin  // Stop bit valid
                            out_byte <= data_buffer;
                            done <= 1;
                            state <= IDLE;
                        end else begin // Stop bit error
                            state <= ERROR; // Go to error state
                        end
                         baud_counter <= 0;
                    end else begin
                        baud_counter <= baud_counter + 1;
                    end
                end
                ERROR: begin
                    done <= 0;
                    if (in == 1) begin
                        state <= IDLE;  // Wait for the next start bit
                    end
                end
            endcase
        end
    end
endmodule