module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_state;
    integer x, y;

    // Function to calculate the index with toroidal wrapping
    function [7:0] idx;
        input integer r, c;
        begin
            idx = ((r + 16) % 16) * 16 + ((c + 16) % 16);
        end
    endfunction

    // Calculate the next state
    always @(*) begin
        for (y = 0; y < 16; y = y + 1) begin
            for (x = 0; x < 16; x = x + 1) begin
                // Calculate the sum of the states of the 8 neighbors
                integer sum;
                sum = q[idx(y-1, x-1)] + q[idx(y-1, x)] + q[idx(y-1, x+1)] +
                      q[idx(y,   x-1)] +                     q[idx(y,   x+1)] +
                      q[idx(y+1, x-1)] + q[idx(y+1, x)] + q[idx(y+1, x+1)];
                
                // Apply the rules of the game
                if (sum < 2 || sum > 3)
                    next_state[idx(y, x)] = 1'b0; // Cell dies
                else if (sum == 3)
                    next_state[idx(y, x)] = 1'b1; // Cell becomes alive
                else
                    next_state[idx(y, x)] = q[idx(y, x)]; // Cell state does not change
            end
        end
    end

    // Update state on the clock edge
    always @(posedge clk) begin
        if (load)
            q <= data; // Load initial state
        else
            q <= next_state; // Update to next state
    end

endmodule