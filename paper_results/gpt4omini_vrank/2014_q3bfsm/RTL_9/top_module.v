module top_module (
    input clk,
    input reset,
    input x,
    output reg z
);
    reg [2:0] state, next_state;

    // State encoding
    parameter S000 = 3'b000;
    parameter S001 = 3'b001;
    parameter S010 = 3'b010;
    parameter S011 = 3'b011;
    parameter S100 = 3'b100;

    // State transition logic
    always @(*) begin
        case (state)
            S000: next_state = (x == 0) ? S000 : S001;
            S001: next_state = (x == 0) ? S001 : S100;
            S010: next_state = (x == 0) ? S010 : S001;
            S011: begin
                next_state = (x == 0) ? S001 : S010;
                z = 1; // Output logic for state S011
            end
            S100: begin
                next_state = (x == 0) ? S011 : S100;
                z = 1; // Output logic for state S100
            end
            default: next_state = S000;
        endcase
    end

    // Output logic
    always @(*) begin
        if (state == S011 || state == S100) 
            z = 1;
        else
            z = 0;
    end

    // State update
    always @(posedge clk) begin
        if (reset) 
            state <= S000; 
        else 
            state <= next_state;
    end
endmodule