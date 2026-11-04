module top_module (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] y, y_next;

    // Define state parameters
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;

    // Sequential logic for state transition
    always @(posedge clk) begin
        if (reset) begin
            y <= S0;
        end else begin
            y <= y_next;
        end
    end

    // Combinational logic for next state and output
    always @(*) begin
        case (y)
            S0: begin
                if (x) y_next = S1;
                else   y_next = S0;
                z = 0;
            end
            S1: begin
                if (x) y_next = S4;
                else   y_next = S1;
                z = 0;
            end
            S2: begin
                if (x) y_next = S1;
                else   y_next = S2;
                z = 0;
            end
            S3: begin
                if (x) y_next = S2;
                else   y_next = S1;
                z = 1;
            end
            S4: begin
                if (x) y_next = S4;
                else   y_next = S3;
                z = 1;
            end
            default: begin
                y_next = S0;
                z = 0;
            end
        endcase
    end

endmodule