module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    reg [2:0] state, next_state;
    reg [1:0] y_counter;
    
    localparam STATE_A = 3'b000, // Initial state
               STATE_B = 3'b001, // First 1 detected
               STATE_C = 3'b010, // 0 detected
               STATE_D = 3'b011; // Second 1 detected

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= STATE_A;
            f <= 0;
            g <= 0;
            y_counter <= 0;
        end else begin
            state <= next_state;
            if (next_state == STATE_A) begin
                f <= 0;
            end else if (next_state == STATE_B) begin
                f <= 1;
            end else if (next_state == STATE_D) begin
                if (y_counter < 2 && y) begin
                    g <= 1;
                end else if (y_counter < 2) begin
                    g <= 0;
                end
            end
        end
    end

    always @(*) begin
        case (state)
            STATE_A: begin
                next_state = STATE_B;
                y_counter = 0;
            end
            STATE_B: begin
                if (x == 0) 
                    next_state = STATE_C;
                else 
                    next_state = STATE_B;
                y_counter = 0;
            end
            STATE_C: begin
                if (x == 1) 
                    next_state = STATE_D;
                else 
                    next_state = STATE_A;
                y_counter = 0;
            end
            STATE_D: begin
                if (y) 
                    g <= 1;
                else if (y_counter < 1) 
                    y_counter = y_counter + 1;
                else 
                    g <= 0;
                
                next_state = STATE_D; // Remain in this state
            end
            default: next_state = STATE_A;
        endcase
    end

endmodule