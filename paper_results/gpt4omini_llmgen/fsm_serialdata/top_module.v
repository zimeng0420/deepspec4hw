module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    parameter IDLE = 3'b000, START = 3'b001, DATA = 3'b010, STOP = 3'b011;
    reg [2:0] state, next_state;
    
    reg [2:0] bit_count; // Counts the number of bits received
    reg [7:0] byte_reg; // Temporary register to hold received byte

    // State transition on clock edge
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            out_byte <= 8'b0;
            done <= 1'b0;
            bit_count <= 3'b0;
            byte_reg <= 8'b0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                done = 1'b0; // Clear done flag in IDLE
                if (~in) // Detect start bit
                    next_state = START;
                else
                    next_state = IDLE;
            end
            
            START: begin
                // Ensure stable start bit
                if (bit_count == 3'd0) 
                    next_state = DATA;
                else 
                    next_state = START;        
            end

            DATA: begin
                if (bit_count < 3'd7) begin
                    next_state = DATA; // Stay in DATA state until all bits are sampled
                end else begin
                    next_state = STOP; // After 8 bits, go to STOP state
                end
            end
            
            STOP: begin
                if (in) begin // Check for stop bit
                    done = 1'b1; // Assert done
                    out_byte = byte_reg; // Output the received byte
                    next_state = IDLE; // Go back to IDLE after stop bit
                end else begin
                    next_state = STOP; // Remain in STOP state until valid stop is detected
                end
            end
            
            default: next_state = IDLE; // Default to IDLE on unknown state
        endcase
    end

    // Data bit reception logic
    always @(posedge clk) begin
        if (state == DATA) begin
            byte_reg <= {in, byte_reg[7:1]}; // Shift left and add new bit
            bit_count <= bit_count + 1; // Increment bit count
        end else if (state == IDLE) begin
            bit_count <= 3'b0; // Reset bit count in IDLE
            byte_reg <= 8'b0; // Reset byte register in IDLE
        end else if (state == STOP) begin
            // Do nothing, wait for stop bit, done is handled here
        end
    end

endmodule