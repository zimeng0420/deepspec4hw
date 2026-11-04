module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    reg [1:0] state;
    reg [2:0] count_w;

    localparam A = 2'b00, B = 2'b01;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
            z <= 0;
            count_w <= 0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        count_w <= 0;
                    end
                end
                B: begin
                    count_w <= {count_w[1:0], w};  // Shift in new w value
                    if (count_w[2:1] == 2'b11) begin
                        z <= 1;  // Set z to 1 if exactly two w's are 1
                    end else if (count_w[2:1] == 2'b00) begin
                        z <= 0;
                    end
                end
            endcase
        end
    end

    always @(posedge clk) begin
        if (state == B) begin
            if (count_w[2:0] == 3'b110 || count_w[2:0] == 3'b101 || count_w[2:0] == 3'b011) begin
                z <= 1;
            end else begin
                z <= 0;
            end
        end
    end

endmodule