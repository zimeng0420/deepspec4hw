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

    // State definition
    parameter IDLE = 3'b000;
    parameter CHECK_1 = 3'b001;
    parameter CHECK_2 = 3'b010;
    parameter CHECK_3 = 3'b011;
    parameter SHIFT = 3'b100;
    parameter COUNT = 3'b101;
    parameter NOTIFY = 3'b110;
    
    reg [2:0] state, next_state;
    reg [1:0] shift_count; // Counter for shift_ena

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic and output logic
    always @(*) begin
        next_state = state;
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;
        shift_count = 2'b00;
        
        case (state)
            IDLE: begin
                if (data)
                    next_state = CHECK_1;
                else
                    next_state = IDLE;
            end
            CHECK_1: begin
                if (data)
                    next_state = CHECK_2;
                else
                    next_state = IDLE;
            end
            CHECK_2: begin
                if (!data)
                    next_state = CHECK_3;
                else
                    next_state = IDLE;
            end
            CHECK_3: begin
                if (data)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end
            SHIFT: begin
                shift_ena = 1'b1;
                shift_count = shift_count + 1'b1;
                if (shift_count == 2'b11)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end
            COUNT: begin
                counting = 1'b1;
                if (done_counting)
                    next_state = NOTIFY;
                else
                    next_state = COUNT;
            end
            NOTIFY: begin
                done = 1'b1;
                if (ack)
                    next_state = IDLE;
                else
                    next_state = NOTIFY;
            end
            default:
                next_state = IDLE;
        endcase
    end

endmodule