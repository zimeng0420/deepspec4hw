module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

reg [3:0] state, next_state;

// State encoding
parameter IDLE = 4'b0000;
parameter START = 4'b0001;
parameter DATA0 = 4'b0010;
parameter DATA1 = 4'b0011;
parameter DATA2 = 4'b0100;
parameter DATA3 = 4'b0101;
parameter DATA4 = 4'b0110;
parameter DATA5 = 4'b0111;
parameter DATA6 = 4'b1000;
parameter DATA7 = 4'b1001;
parameter STOP = 4'b1010;
parameter ERROR = 4'b1011;

// Next state logic
always @* begin
    case(state)
        IDLE:
            if (in == 0) next_state = START;
            else next_state = IDLE;
        START:
            next_state = DATA0;
        DATA0: next_state = DATA1;
        DATA1: next_state = DATA2;
        DATA2: next_state = DATA3;
        DATA3: next_state = DATA4;
        DATA4: next_state = DATA5;
        DATA5: next_state = DATA6;
        DATA6: next_state = DATA7;
        DATA7: next_state = STOP;
        STOP:
            if (in == 1)
                next_state = IDLE;
            else
                next_state = ERROR;
        ERROR:
            if (in == 1) next_state = IDLE;
            else next_state = ERROR; 
        default: next_state = IDLE;
    endcase
end

// State transition with clock and reset
always @(posedge clk or posedge reset) begin
    if (reset)
        state <= IDLE;
    else
        state <= next_state;
end

// Done logic
always @(posedge clk) begin
    if (state == STOP && in == 1) 
        done <= 1;
    else 
        done <= 0;
end

endmodule