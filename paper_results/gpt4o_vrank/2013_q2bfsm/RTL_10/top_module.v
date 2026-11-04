module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    reg [2:0] state, next_state;
    reg [1:0] y_count;

    // State encoding
    localparam A = 3'b000,
               B = 3'b001,
               C = 3'b010,
               D = 3'b011,
               E = 3'b100;

    // State transitions
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // Default to retain state
        case (state)
            A: begin
                next_state = B;
            end
            B: begin
                if (x == 1)
                    next_state = C;
            end
            C: begin
                if (x == 0)
                    next_state = D;
            end
            D: begin
                if (x == 1)
                    next_state = E;
            end
            E: begin
                if (g == 0) begin  // only check for y if g is not permanently set yet
                    if (y_count < 2 && y == 1)
                        g = 1; // Keep g high if y=1 within two cycles
                    else if (y_count == 2 && y == 0)
                        g = 0; // Drop g if y hasn't become 1 within two cycles
                end
            end
        endcase
    end

    // Output logic and y_count management
    always @(posedge clk) begin
        if (!resetn) begin
            f <= 0;
            g <= 0;
            y_count <= 0;
        end else begin
            case (state)
                A: begin
                    f <= 1;
                    g <= 0;
                    y_count <= 0;
                end
                B, C, D: begin
                    f <= 0;
                end
                E: begin
                    if (g == 0) begin
                        if (y_count < 2) begin
                            y_count <= y_count + 1;
                            if (y == 1)
                                g <= 1;
                        end else if (y_count == 2) begin
                            if (y != 1)
                                g <= 0;
                        end
                    end
                end
            endcase
        end
    end

endmodule