```verilog
module top_module (
    input clk,
    input reset,
    input x,
    output reg z
);
    // State encoding
    typedef enum reg [2:0] {
        S000 = 3'b000,
        S001 = 3'b001,
        S010 = 3'b010,
        S011 = 3'b011,
        S100 = 3'b100
    } state_t;

    // State register
    state_t current_state, next_state;

    // Output logic based on current state and input x
    always @(*) begin
        case (current_state)
            S000: begin
                next_state = (x == 0) ? S000 : S001;
                z = 1'b0;
            end
            S001: begin
                next_state = (x == 0) ? S001 : S100;
                z = 1'b0;
            end
            S010: begin
                next_state = (x == 0) ? S010 : S001;
                z = 1'b0;
            end
            S011: begin
                next_state = (x == 0) ? S001 : S010;
                z = 1'b1;
            end
            S100: begin
                next_state = (x == 0) ? S011 : S100;
                z = 1'b1;
            end
            default: begin
                next_state = S000; // Default to state 000
                z = 1'b0;
            end
        endcase
    end

    // State transition and output update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S000; // On reset, go to state 000
        end else begin
            current_state <= next_state; // Update state
        end
    end

endmodule
```