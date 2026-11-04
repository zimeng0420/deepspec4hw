module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg [1:0] state, next_state;
    reg [31:0] data; // Buffer for input data
    reg [4:0] count; // Count the number of bits

    localparam IDLE = 2'b00,
               READ = 2'b01,
               COMPLEMENT = 2'b10,
               OUTPUT = 2'b11;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
            count <= 0;
            data <= 0;
            z <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (!areset) begin
                    next_state = READ;
                end
            end
            READ: begin
                data[count] = x; // Read input bit
                if (count < 31) begin
                    count = count + 1;
                end else begin
                    next_state = COMPLEMENT;
                end
            end
            COMPLEMENT: begin
                data = ~data + 1; // 2's complement operation
                next_state = OUTPUT;
            end
            OUTPUT: begin
                z = data[0]; // Output least significant bit
                next_state = IDLE;
            end
        endcase
    end

endmodule