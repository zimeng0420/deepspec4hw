module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg [1:0] state, next_state;
    reg [31:0] num; // Assuming a maximum of 32 bits for the input number
    reg [5:0] count;

    localparam IDLE = 2'b00,
               LOAD = 2'b01,
               COMPLEMENT = 2'b10,
               OUTPUT = 2'b11;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
            z <= 1'b0;
            num <= 32'b0;
            count <= 6'd0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (!areset) begin
                    next_state = LOAD;
                end else begin
                    next_state = IDLE;
                end
            end
            
            LOAD: begin
                if (count < 32) begin
                    num[count] = x; // Load the current input bit
                    count = count + 1;
                    next_state = LOAD;
                end else begin
                    next_state = COMPLEMENT;
                end
            end
            
            COMPLEMENT: begin
                z = ~num[count-1]; // Start complementing
                count = count - 1;
                if (count > 0) begin
                    next_state = COMPLEMENT;
                end else begin
                    next_state = OUTPUT;
                end
            end
            
            OUTPUT: begin
                z = ~z; // Final output is the 2's complement
                next_state = IDLE; // Go back to IDLE
            end

            default: next_state = IDLE;
        endcase
    end

endmodule