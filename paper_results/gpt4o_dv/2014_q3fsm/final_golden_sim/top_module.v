module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State Encoding
    reg [1:0] state, next_state;
    localparam A = 2'b00, B1 = 2'b01, B2 = 2'b10, B3 = 2'b11;

    // Counter to track occurrences of w = 1
    reg [1:0] w_count;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
            w_count <= 0;
        end else begin
            state <= next_state;
            
            case (state)
                B1: if (w) w_count <= w_count + 1;
                B2: if (w) w_count <= w_count + 1;
                B3: if (w) w_count <= w_count + 1;
            endcase
            
            if (state == B3) begin
                z <= (w_count == 2);
                w_count <= 0;  // Reset count for next set of cycles
            end
        end
    end

    always @(*) begin
        case (state)
            A: next_state = s ? B1 : A;
            B1: next_state = B2;
            B2: next_state = B3;
            B3: next_state = B1;
            default: next_state = A;
        endcase
    end

endmodule