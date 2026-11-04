module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    typedef enum logic [2:0] {
        STATE_A,
        STATE_F_HIGH,
        STATE_MONITOR_X,
        STATE_G_HIGH,
        STATE_Y_CHECK
    } state_t;

    state_t current_state, next_state;
    logic [2:0] x_sequence;
    logic y_check;
    int cycle_count;

    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= STATE_A;
            f <= 0;
            g <= 0;
            x_sequence <= 3'b000;
            cycle_count <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        next_state = current_state;
        case (current_state)
            STATE_A: begin
                f = 0;
                g = 0;
                next_state = STATE_F_HIGH;
            end
            
            STATE_F_HIGH: begin
                f = 1;
                next_state = STATE_MONITOR_X;
            end
            
            STATE_MONITOR_X: begin
                f = 0;
                if (x_sequence == 3'b101) begin
                    next_state = STATE_G_HIGH;
                end else begin
                    if (cycle_count < 3) begin
                        x_sequence <= {x_sequence[1:0], x};
                        cycle_count = cycle_count + 1;
                    end else begin
                        x_sequence <= {x_sequence[1:0], x};
                    end
                end
            end
            
            STATE_G_HIGH: begin
                g = 1;
                next_state = STATE_Y_CHECK;
            end
            
            STATE_Y_CHECK: begin
                if (y == 1) begin
                    g = 1;
                end else if (cycle_count < 2) begin
                    cycle_count = cycle_count + 1;
                end else begin
                    g = 0;
                end
            end
        endcase
    end
    
endmodule