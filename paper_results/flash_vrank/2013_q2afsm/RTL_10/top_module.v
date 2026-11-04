module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output [3:1] g
);

    // State definition
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    // State variable
    reg [1:0] current_state, next_state;

    // State flip-flops
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // State table
    always @(*) begin
        case (current_state)
            A: begin
                if (r[1]) begin
                    next_state <= B;
                end else if (r[2]) begin
                    next_state <= C;
                end else if (r[3]) begin
                    next_state <= D;
                end else begin
                    next_state <= A;
                end
            end
            B: begin
                if (r[1]) begin
                    next_state <= B;
                end else begin
                    next_state <= A;
                end
            end
            C: begin
                if (r[2]) begin
                    next_state <= C;
                end else begin
                    next_state <= A;
                end
            end
            D: begin
                if (r[3]) begin
                    next_state <= D;
                end else begin
                    next_state <= A;
                end
            end
            default: next_state <= A;
        endcase
    end

    // Output logic
    always @(*) begin
        g[1] = (current_state == B) ? 1'b1 : 1'b0;
        g[2] = (current_state == C) ? 1'b1 : 1'b0;
        g[3] = (current_state == D) ? 1'b1 : 1'b0;
    end

endmodule