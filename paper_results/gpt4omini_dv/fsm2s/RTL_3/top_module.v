module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output reg out
);

    typedef enum reg [1:0] {OFF, ON} state_t;
    state_t current_state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= OFF;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            OFF: begin
                if (j) 
                    next_state = ON;
                else 
                    next_state = OFF;
            end
            
            ON: begin
                if (k) 
                    next_state = OFF;
                else 
                    next_state = ON;
            end
            
            default: next_state = OFF; // Default state
        endcase
    end

    always @(current_state) begin
        case (current_state)
            OFF: out = 0;
            ON: out = 1;
            default: out = 0; // Default output
        endcase
    end

endmodule