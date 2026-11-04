module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg [2:0] state, next_state;
    reg [7:0] count; // Assuming a maximum input length of 8 bits
    reg [7:0] num;   // Register to hold the input number
    reg start;       // Signal to indicate starting of the operation

    // State Definitions
    parameter IDLE = 3'b000, LOAD = 3'b001, COMPL = 3'b010, ADD_ONE = 3'b011, DONE = 3'b100;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
            count <= 0;
            num <= 0;
            z <= 0;
            start <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(state or x) begin
        case (state)
            IDLE: begin
                if (!areset) begin
                    next_state = LOAD;
                end else begin
                    next_state = IDLE;
                end
            end

            LOAD: begin
                num[count] = x;
                count = count + 1;
                if (count < 8) begin
                    next_state = LOAD;
                end else begin
                    next_state = COMPL;
                end
            end

            COMPL: begin
                z = ~num; // Taking 1's complement
                next_state = ADD_ONE;
            end

            ADD_ONE: begin
                z = z + 1; // Adding 1 to complete 2's complement
                next_state = DONE;
            end

            DONE: begin
                next_state = IDLE; // Ready for the next number
            end

            default: next_state = IDLE;
        endcase
    end

endmodule