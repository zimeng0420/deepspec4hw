module top_module(
	input clk, 
	input load, 
	input [9:0] data, 
	output tc
);

    reg [9:0] counter;
    reg tc_internal;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
            tc_internal <= 0; // Reset tc when loading
        end else begin
            if (counter > 0) begin
                counter <= counter - 1;
            end
            if (counter == 1) begin //Check if counter become zero in the next clock cycle.
                tc_internal <= 1;
            end
        end
    end

    assign tc = tc_internal;

endmodule