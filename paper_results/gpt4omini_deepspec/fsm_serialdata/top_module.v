module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    reg [3:0] state;
    reg [2:0] bit_count;
    reg stop_bit_valid;
    
    localparam IDLE = 4'b0000,
               START_BIT = 4'b0001,
               DATA_RECEIVE = 4'b0010,
               STOP_BIT = 4'b0011;

    // State transition on clock
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b000;
            out_byte <= 8'b00000000;
            done <= 0;
        end else begin
            case(state)
                IDLE: begin
                    done <= 0;
                    if (in == 0) // Start bit detected
                        state <= START_BIT;
                end
                
                START_BIT: begin
                    if (in == 0) // Wait for start bit
                        state <= DATA_RECEIVE;
                end
                
                DATA_RECEIVE: begin
                    out_byte[bit_count] <= in; // Capture data bits
                    if (bit_count == 7) begin
                        state <= STOP_BIT; // Move to stop bit check
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end
                
                STOP_BIT: begin
                    stop_bit_valid <= (in == 1); // Check for stop bit
                    if (stop_bit_valid) begin
                        done <= 1; // Data received successfully
                        state <= IDLE; // Return to IDLE state
                    end else begin
                        state <= IDLE; // Error case, return to IDLE 
                    end
                end
                
                default: state <= IDLE; // Reset to IDLE on default
            endcase
        end
    end
endmodule