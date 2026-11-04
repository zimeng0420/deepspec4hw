module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    reg [1:0] state, next_state;
    reg [2:0] w_count;

    localparam A = 2'b00, B = 2'b01;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
            z <= 0;
            w_count <= 3'b000;
        end else begin
            state <= next_state;
        end
    end

    always @(posedge clk) begin
        if (state == B) begin
            w_count <= {w_count[1:0], w}; // Shift the count of w over 3 cycles
        end
    end

    always @(*) begin
        case (state)
            A: begin
                next_state = (s) ? B : A;
                z = 0; // z is 0 in state A
            end
            B: begin
                next_state = (s) ? B : A;
                // Count how many w's are 1 in w_count
                z = (w_count[0] + w_count[1] + w_count[2] == 2) ? 1 : 0;
            end
            default: begin
                next_state = A;
                z = 0;
            end
        endcase
    end

endmodule