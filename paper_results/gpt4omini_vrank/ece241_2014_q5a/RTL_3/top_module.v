module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);
    reg [1:0] state, next_state;
    reg [31:0] result; // 32-bit result to store the 2's complement.
    reg [4:0] count;   // Counter for the number of bits processed

    parameter IDLE = 2'b00, PROCESS = 2'b01, OUTPUT = 2'b10;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
            count <= 0;
            result <= 0;
            z <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (!areset) begin
                    next_state = PROCESS;
                    count = 0;
                    result = 0;
                end else begin
                    next_state = IDLE;
                end
            end
            
            PROCESS: begin
                if (count < 32) begin
                    result[count] = x; // Store the bit
                    count = count + 1;
                    next_state = PROCESS;
                end else begin
                    next_state = OUTPUT;
                end
            end
            
            OUTPUT: begin
                z = ~result + 1; // Compute 2's complement
                next_state = IDLE; // Go back to idle
            end
            
            default: next_state = IDLE;
        endcase
    end
endmodule