module top_module(
    input clk,
    input reset,
    input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack );

    typedef enum logic [2:0] {
        IDLE, 
        S1, 
        S2, 
        S3, 
        SHIFT, 
        COUNTING, 
        DONE
    } state_t;
    
    state_t current_state, next_state;
    integer shift_count; // to count the number of shift cycles

    always_ff @(posedge clk or posedge reset) begin
        if (reset) 
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    always_ff @(posedge clk) begin
        if (current_state == SHIFT) begin
            if (shift_count < 4) begin
                shift_ena <= 1;
                shift_count <= shift_count + 1;
            end else begin
                shift_ena <= 0;
                shift_count <= 0;
            end
        end else begin
            shift_ena <= 0;
        end

        if (current_state == COUNTING) begin
            counting <= 1;
        end else begin
            counting <= 0;
        end

        if (current_state == DONE) begin
            done <= 1;
        end else begin
            done <= 0;
        end
    end

    always_comb begin
        case(current_state)
            IDLE: begin
                if (data == 1) 
                    next_state = S1;
                else 
                    next_state = IDLE;
            end
            S1: begin
                if (data == 1) 
                    next_state = S2;
                else 
                    next_state = IDLE;
            end
            S2: begin
                if (data == 0) 
                    next_state = S3;
                else 
                    next_state = IDLE;
            end
            S3: begin
                if (data == 1) 
                    next_state = SHIFT;
                else 
                    next_state = IDLE;
            end
            SHIFT: begin
                if (shift_count < 4) 
                    next_state = SHIFT;
                else 
                    next_state = COUNTING;
            end
            COUNTING: begin
                if (done_counting) 
                    next_state = DONE;
                else 
                    next_state = COUNTING;
            end
            DONE: begin
                if (ack) 
                    next_state = IDLE;
                else 
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule