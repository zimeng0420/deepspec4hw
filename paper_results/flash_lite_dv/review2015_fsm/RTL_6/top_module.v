module top_module(
    input clk,
    input reset,
    input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack
);

    // Define states
    parameter IDLE = 2'b00;
    parameter SHIFT = 2'b01;
    parameter COUNTING = 2'b10;
    parameter DONE = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;
    reg [2:0] bit_counter;
    reg [3:0] data_buffer;

    // State transition logic
    always @(*) begin
        next_state = state;
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case (state)
            IDLE: begin
                if (data_buffer == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                shift_ena = 1'b1;
                if (bit_counter == 3) begin
                    next_state = COUNTING;
                end
            end
            COUNTING: begin
                counting = 1'b1;
                if (done_counting) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                done = 1'b1;
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Data buffer shift register
    always @(posedge clk) begin
        if (reset) begin
            data_buffer <= 4'b0000;
        end else begin
            data_buffer <= {data_buffer[2:0], data};
        end
    end
    
    // Bit counter for shift_ena duration
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_counter <= 3'b000;
        end else if (state == SHIFT && bit_counter < 3) begin
            bit_counter <= bit_counter + 1'b1;
        end else if (state != SHIFT) begin
            bit_counter <= 3'b000;
        end
    end
    // State register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

endmodule