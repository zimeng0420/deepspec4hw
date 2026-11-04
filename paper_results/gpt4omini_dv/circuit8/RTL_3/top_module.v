module top_module (
    input clock,
    input a, 
    output reg p,
    output reg q
);

    reg [1:0] state; // state register to hold the state of q and p

    always @(posedge clock) begin
        case(state)
            2'b00: begin
                p <= 0;
                q <= 0;
                if (a) state <= 2'b01; // transition to state 01 on a=1
            end
            2'b01: begin
                p <= 0;
                q <= 0;
                if (a) state <= 2'b10; // transition to state 10 on second a=1
                else state <= 2'b11; // transition to state 11 on a=0
            end
            2'b10: begin
                p <= 1;
                q <= 0;
                state <= 2'b00; // return to state 00
            end
            2'b11: begin
                p <= 0; 
                q <= 1; // set q to 1
                state <= 2'b00; // return to state 00
            end
        endcase
    end
endmodule