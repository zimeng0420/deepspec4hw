module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    reg [3:0] state, next_state;
    reg [7:0] shift_register;
    reg [3:0] bit_counter;

    // Define states
    localparam IDLE   = 4'b0000;
    localparam START  = 4'b0001;
    localparam DATA   = 4'b0010;
    localparam STOP   = 4'b0011;
    localparam ERROR  = 4'b0100;

    // State Update on Clock Edge
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_register <= 8'd0;
            bit_counter <= 4'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            if (state == DATA && bit_counter < 4'd8) begin
                shift_register <= {in, shift_register[7:1]}; // Shift data bits
                bit_counter <= bit_counter + 1;
            end
            if (state == STOP && in == 1'b1) begin
                out_byte <= shift_register;
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

    // Next State Logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START;
            end
            START: begin
                next_state = DATA;
            end
            DATA: begin
                if (bit_counter == 4'd8)
                    next_state = STOP;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE; // Wait for a valid stop bit
            end
        endcase
    end

endmodule