module top_module (
    input clk,
    input areset,
    input x,
    output z
);
    reg [31:0] buffer; // Store the incoming bits
    reg [5:0] count;   // Count bits
    reg done;          // Indicate when conversion is done
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            buffer <= 0;
            count <= 0;
            done <= 0;
        end else if (!done) begin
            buffer[count] <= x; // Store the current input bit
            count <= count + 1; // Increment the count
            if (count == 31) begin // Assuming max input length is 32 bits
                done <= 1; // Mark completion
            end
        end
    end
    
    reg [31:0] twos_comp; // Register for 2's complement output
    always @(posedge clk) begin
        if (done) begin
            twos_comp <= ~buffer + 1; // 2's complement logic
        end
    end
    
    assign z = (done) ? twos_comp[0] : 1'b0; // Output the least significant bit

endmodule