module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg [1:0] state;
    reg [1:0] next_state;
    reg [31:0] counter; // To count the number of bits
    reg [31:0] twos_complement; // To store the 2's complement result
    
    parameter IDLE = 2'b00,
              SHIFT = 2'b01,
              COMPLEMENT = 2'b10;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
            counter <= 0;
            twos_complement <= 0;
            z <= 0;
        end else begin
            state <= next_state;
        end
    end
    
    always @(*) begin
        case (state)
            IDLE: begin
                if (!areset) begin
                    next_state = SHIFT;
                end else begin
                    next_state = IDLE;
                end
            end

            SHIFT: begin
                counter <= counter + 1;
                twos_complement <= (twos_complement << 1) | x;
                if (x) begin
                    twos_complement <= twos_complement + 1; // Add 1 for 2's complement
                end
                next_state = counter >= 31 ? COMPLEMENT : SHIFT; // Change states based on counter
            end

            COMPLEMENT: begin
                z <= ~twos_complement; // Output the 2's complement
                next_state = IDLE; // Go back to IDLE
            end
            
            default: next_state = IDLE; // Default case
        endcase
    end

endmodule