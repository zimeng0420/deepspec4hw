module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

// State Definitions
parameter IDLE = 3'b000;
parameter START = 3'b001;
parameter DATA = 3'b010;
parameter STOP = 3'b011;
parameter ERROR = 3'b100; // Optional: For error handling (e.g., incorrect stop bit)

// Internal Signals
reg [2:0] state;
reg [7:0] data_buffer;
reg [2:0] bit_count; // Counter for data bits

// State Transition Logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        done <= 1'b0;
        data_buffer <= 8'b0;
        bit_count <= 3'b000;
    end else begin
        case (state)
            IDLE: begin
                done <= 1'b0;
                if (!in) begin // Detect start bit (0)
                    state <= START;
                end else begin
                    state <= IDLE; // Stay in IDLE if not start bit
                end
            end
            START: begin
                state <= DATA; // Transition to DATA after start bit
                bit_count <= 3'b000;
            end
            DATA: begin
                data_buffer[bit_count] <= in; // Capture data bit
                bit_count <= bit_count + 1'b1;
                if (bit_count == 3'b111) begin // All 8 data bits received
                    state <= STOP;
                end else begin
                    state <= DATA;
                end
            end
            STOP: begin
                if (in) begin // Check for stop bit (1)
                    done <= 1'b1;
                    state <= IDLE; // Go back to IDLE after valid stop bit
                end else begin
                    state <= ERROR; // Incorrect stop bit
                end
            end
            ERROR: begin
                done <= 1'b0;
                if (in) begin // Wait for a stop bit
                    state <= IDLE; // Resynchronize when stop bit is found
                end else begin
                    state <= ERROR; // Stay in ERROR until stop bit
                end
            end
            default: begin
                state <= IDLE; // Default to IDLE for safety
            end
        endcase
    end
end

// Output Assignment
always @(posedge clk) begin
    if (done) begin
        out_byte <= data_buffer;
    end
end

endmodule