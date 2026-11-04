module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);

    // State encoding
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State register
    reg [1:0] state;

    // Next state logic
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            state <= A;
        else
            case (state)
                A: begin
                    if (r[1])
                        state <= B;
                    else if (r[2])
                        state <= C;
                    else if (r[3])
                        state <= D;
                    else
                        state <= A;
                end
                B: begin
                    if (r[1])
                        state <= B;
                    else
                        state <= A;
                end
                C: begin
                    if (r[2])
                        state <= C;
                    else
                        state <= A;
                end
                D: begin
                    if (r[3])
                        state <= D;
                    else
                        state <= A;
                end
            endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            A: begin
                g[1] = r[1];
                g[2] = !r[1] & r[2];
                g[3] = !r[1] & !r[2] & r[3];
            end
            B: begin
                g[1] = r[1];
                g[2] = 0;
                g[3] = 0;
            end
            C: begin
                g[1] = 0;
                g[2] = r[2];
                g[3] = 0;
            end
            D: begin
                g[1] = 0;
                g[2] = 0;
                g[3] = r[3];
            end
            default: begin
                g[1] = 0;
                g[2] = 0;
                g[3] = 0;
            end
        endcase
    end
endmodule