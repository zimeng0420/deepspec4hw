module top_module(
	input clk,
	input reset,
	input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack );

    // Define states
    parameter IDLE = 3'b000;
    parameter DETECT = 3'b001;
    parameter SHIFT = 3'b010;
    parameter COUNTING = 3'b011;
    parameter NOTIFY = 3'b100;
    parameter ACKNOWLEDGE = 3'b101;

    // State register
    reg [2:0] state;
    reg [1:0] data_buffer; // Buffer for the input sequence (1101)
    reg [2:0] shift_count;

    // Default assignments
    always @(*) begin
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;
    end

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 3'b000;
        end else begin
            case (state)
                IDLE: begin
                    data_buffer <= {data_buffer[0], data}; // Shift in data
                    if (data_buffer == 2'b11 && data == 1'b0) begin
                        state <= DETECT;
                    end else if (data_buffer == 2'b10 && data == 1'b1) begin
                       state <= DETECT;
                    end
                    else
                        state <= IDLE;
                end
                DETECT: begin
                    if (data == 1'b1)
                        state <= SHIFT;
                    else
                        state <= IDLE;
                end
                SHIFT: begin
                    shift_ena <= 1'b1;
                    shift_count <= shift_count + 1'b1;
                    if(shift_count == 3'b100)
                        state <= COUNTING;
                    else
                        state <= SHIFT;
                end
                COUNTING: begin
                    counting <= 1'b1;
                    if (done_counting)
                        state <= NOTIFY;
                    else
                        state <= COUNTING;
                end
                NOTIFY: begin
                    done <= 1'b1;
                    state <= ACKNOWLEDGE;
                end
                ACKNOWLEDGE: begin
                    if (ack)
                        state <= IDLE;
                    else
                        state <= ACKNOWLEDGE;
                end
                default: begin
                    state <= IDLE;
                end
            endcase
            if(state != SHIFT)
                shift_count <= 3'b000;

        end
    end

endmodule