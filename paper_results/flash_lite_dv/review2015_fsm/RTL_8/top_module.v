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

    // State definitions
    parameter IDLE = 2'b00;
    parameter SHIFT = 2'b01;
    parameter COUNTING = 2'b10;
    parameter DONE = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;
    reg [1:0] data_reg; // Shift register for data input
    reg [1:0] counter; // Counter for shift_ena duration

    // Default values for outputs
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // Default: stay in the same state

        case (state)
            IDLE: begin
                //Detect start sequence 1101
                if (data_reg == 2'b11 && data == 1'b0) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                //Wait for the counter to finish
                if (counter == 2'd3) begin
                    next_state = COUNTING;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Data shift register
    always @(posedge clk) begin
      data_reg <= {data_reg[0], data};
    end

    // Output logic
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
            SHIFT: begin
                shift_ena <= 1'b1;
                counting <= 1'b0;
                done <= 1'b0;
            end
            COUNTING: begin
                shift_ena <= 1'b0;
                counting <= 1'b1;
                done <= 1'b0;
            end
            DONE: begin
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b1;
            end
        endcase
    end
    //Counter for shift_ena duration
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 2'b00;
        end else if (state == SHIFT) begin
           if(counter < 2'b11)
              counter <= counter + 1'b1;
           else
              counter <= 2'b00;
        end
        else
           counter <= 2'b00;

    end

endmodule