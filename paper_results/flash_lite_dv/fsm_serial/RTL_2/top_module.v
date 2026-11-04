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
    reg [2:0] current_state, next_state;

    // Data Bit Counter
    reg [2:0] bit_count;

    // Data register to store received data (optional, but good practice)
    reg [7:0] data_in_reg;

    // Combinational Logic for Next State and Output
    always @(*) begin
        next_state = current_state;
        done = 1'b0;  // Default: not done

        case (current_state)
            IDLE: begin
                if (in == 1'b0) begin // Start bit detected
                    next_state = START_BIT;
                end
            end
            START_BIT: begin
                next_state = DATA_BITS;
            end
            DATA_BITS: begin
                if (bit_count == 3'b111) begin  // 8 bits received
                    next_state = STOP_BIT;
                end else begin
                    next_state = DATA_BITS;
                end
            end
            STOP_BIT: begin
                if (in == 1'b1) begin // Stop bit valid
                    next_state = IDLE;
                    done = 1'b1;
                end else begin
                    next_state = ERROR;
                end
            end
            ERROR: begin
                if (in == 1'b1) begin // Wait for valid stop bit
                    next_state = IDLE;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Sequential Logic for State and Counter Updates
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            bit_count <= 3'b000;
        end else begin
            current_state <= next_state;
            if (current_state == DATA_BITS) begin
                bit_count <= bit_count + 1'b1;
            end else if (current_state == START_BIT) begin
                bit_count <= 3'b000;
            end
            else if (current_state == IDLE) begin
              bit_count <= 3'b000;
            end
            else if (current_state == STOP_BIT && in == 1'b1) begin
              bit_count <= 3'b000;
            end
        end
    end
endmodule