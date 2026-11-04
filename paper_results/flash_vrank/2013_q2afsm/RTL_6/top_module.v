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
    reg [1:0] current_state;
    reg [1:0] next_state;

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
              next_state <= A;
            end
            default: next_state <= A;
        endcase
    end

    // Output logic
    reg [3:1] g_temp;
    always @(current_state) begin
      case (current_state)
        A: g_temp = 3'b000;
        B: g_temp = 3'b100;
        C: g_temp = 3'b010;
        D: g_temp = 3'b001;
        default: g_temp = 3'b000;
      endcase
    end

    assign g = g_temp;


endmodule