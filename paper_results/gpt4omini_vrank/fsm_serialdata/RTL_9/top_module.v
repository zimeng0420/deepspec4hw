module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    reg [3:0] state;
    reg [3:0] bit_count;
    
    parameter IDLE    = 4'b0000,
              START   = 4'b0001,
              DATA    = 4'b0010,
              STOP    = 4'b0011;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            out_byte <= 8'b0;
            done <= 0;
            bit_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (in == 0) begin // Start bit detected
                        state <= START;
                    end
                end
                START: begin
                    state <= DATA;
                    bit_count <= 0;
                end
                DATA: begin
                    if (bit_count < 8) begin
                        out_byte[bit_count] <= in; // Receive data bits
                        bit_count <= bit_count + 1;
                    end else begin
                        state <= STOP; // Move to stop bit checking
                    end
                end
                STOP: begin
                    done <= 1; // Assert done signal
                    if (in == 1) begin // Check stop bit
                        state <= IDLE; // Back to idle state
                    end else begin
                        state <= IDLE; // Wait for a valid stop bit
                    end
                end
            endcase
        end
    end
endmodule