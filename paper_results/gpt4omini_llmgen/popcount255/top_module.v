module top_module (
    input [254:0] in,
    output reg [7:0] out
);

    // Internal signals and registers declaration
    reg [3:0] count[15:0]; // 16 groups of 4-bit counts
    reg [7:0] total_count;  // 8-bit total count

    integer i;

    always @(*) begin
        // Reset total count
        total_count = 0;

        // Count the number of '1's in each group
        for (i = 0; i < 16; i = i + 1) begin
            count[i] = count_ones(in[i*16 +: 16]); // count_ones is a function to count bit '1's in a 16-bit input
            total_count = total_count + count[i]; // Accumulate the counts
        end

        // Assign the total count to output
        out = total_count;
    end

    // Function to count number of '1's
    function [3:0] count_ones(input [15:0] data);
        integer j;
        begin
            count_ones = 0;
            for (j = 0; j < 16; j = j + 1) begin
                count_ones = count_ones + data[j];
            end
        end
    endfunction

endmodule