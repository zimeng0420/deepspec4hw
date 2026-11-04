module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding
    typedef enum reg [3:0] {
        S0 = 4'b0000,
        S1 = 4'b0001,
        S2 = 4'b0010,
        S3 = 4'b0011,
        S4 = 4'b0100,
        S5 = 4'b0101,
        S6 = 4'b0110,
        Serr = 4'b0111,
        Sdisc = 4'b1000
    } state_t;

    // State variable
    state_t state, next_state;

    // Synchronous state transition
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic
    always @* begin
        case (state)
            S0: begin
                if (in == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
            
            S1: begin
                if (in == 1'b1)
                    next_state = S2;
                else
                    next_state = S0;
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
            
            S2: begin
                if (in == 1'b1)
                    next_state = S3;
                else
                    next_state = S0;
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
            
            S3: begin
                if (in == 1'b1)
                    next_state = S4;
                else
                    next_state = S0;
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
            
            S4: begin
                if (in == 1'b1)
                    next_state = S5;
                else
                    next_state = S0;
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
            
            S5: begin
                if (in == 1'b1)
                    next_state = S6;
                else
                    next_state = S0;
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
            
            S6: begin
                if (in == 1'b1) begin
                    next_state = Serr; // Transition to error state
                    err = 1'b1; // Set error signal
                end else begin
                    next_state = Sdisc; // Transition to discard state
                end
                disc = 1'b0;
                flag = 1'b0;
            end
            
            Serr: begin
                next_state = Serr; // Remain in error state
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b1; // Maintain the error signal
            end
            
            Sdisc: begin
                next_state = S0; // After discarding, go back to S0
                disc = 1'b1; // Set discard signal
            end
            
            default: begin
                next_state = S0; // Default state
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (state == Sdisc) begin
            disc <= 1'b1; // Assert disc output on the next cycle
        end else if (state == S6 && in == 1'b0) begin
            flag <= 1'b1; // Assert flag output on the next cycle
        end else if (state == S6 && in == 1'b1) begin
            err <= 1'b1; // Assert error on the next cycle
        end else begin
            disc <= 1'b0; // Reset disc output
            flag <= 1'b0; // Reset flag output
            err <= 1'b0; // Reset error output
        end
    end

endmodule