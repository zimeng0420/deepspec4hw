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
    reg [2:0] bit_count;  // Counter for the 4 bits after start sequence
    reg [3:0] data_buffer; //shift register for data
    
    // State transition logic
    always @(*) begin
        next_state = state;
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case (state)
            IDLE: begin
                // Check for start sequence (1101)
                if (data_buffer == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                shift_ena = 1'b1;
                if (bit_count == 3) begin
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
            default: next_state = IDLE;
        endcase
    end
    
    // State register and output logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            data_buffer <= 4'b0;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            if(state == SHIFT)
                bit_count <= bit_count + 1'b1;
            else
                bit_count <= 3'b0;
             if (state == IDLE || state == SHIFT) begin
                data_buffer <= {data_buffer[2:0], data};
            end

        end
    end

endmodule