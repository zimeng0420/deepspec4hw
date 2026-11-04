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

    // State register
    reg [1:0] state;

    // Shift register for start sequence detection
    reg [3:0] shift_reg;

    // Counter for shift_ena duration
    reg [1:0] shift_ena_counter;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_ena_counter <= 2'b00;
            shift_reg <= 4'b0000;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= SHIFT;
                        shift_ena_counter <= 2'b00;
                    end else
                        state <= IDLE;
                end
                SHIFT: begin
                    shift_ena <= 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    if (shift_ena_counter < 2'b11) begin
                        shift_ena_counter <= shift_ena_counter + 1'b1;
                        state <= SHIFT;
                    end else begin
                        state <= COUNTING;
                        shift_ena_counter <= 2'b00;
                    end
                end
                COUNTING: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                    done <= 1'b0;
                    if (done_counting)
                        state <= DONE;
                    else
                        state <= COUNTING;
                end
                DONE: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b1;
                    if (ack)
                        state <= IDLE;
                    else
                        state <= DONE;
                end
                default: begin
                    state <= IDLE;
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end
endmodule