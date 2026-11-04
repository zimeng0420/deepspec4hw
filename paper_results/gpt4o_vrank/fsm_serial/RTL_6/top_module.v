module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    reg [3:0] state, next_state;
    reg [3:0] bit_count;

    // State encoding
    localparam IDLE      = 4'b0000,
               START     = 4'b0001,
               DATA0     = 4'b0010,
               DATA1     = 4'b0011,
               DATA2     = 4'b0100,
               DATA3     = 4'b0101,
               DATA4     = 4'b0110,
               DATA5     = 4'b0111,
               DATA6     = 4'b1000,
               DATA7     = 4'b1001,
               STOP      = 4'b1010,
               ERROR     = 4'b1011;
               
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        done = 1'b0;
        case (state)
            IDLE: begin
                if (in == 1'b0)  // Start bit detected
                    next_state = START;
            end
            START: next_state = DATA0;
            DATA0: next_state = DATA1;
            DATA1: next_state = DATA2;
            DATA2: next_state = DATA3;
            DATA3: next_state = DATA4;
            DATA4: next_state = DATA5;
            DATA5: next_state = DATA6;
            DATA6: next_state = DATA7;
            DATA7: next_state = STOP;
            STOP: begin
                if (in == 1'b1) begin // Correct stop bit
                    done = 1'b1;
                    next_state = IDLE; // Ready for next byte
                end else begin
                    next_state = ERROR; // Incorrect stop bit
                end
            end
            ERROR: begin
                if (in == 1'b1) // Search for stop bit
                    next_state = IDLE; // Ready to start new byte
            end
        endcase
    end

endmodule