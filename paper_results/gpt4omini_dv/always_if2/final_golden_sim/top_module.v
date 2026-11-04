module top_module (
    input cpu_overheated,
    output reg shut_off_computer,
    input arrived,
    input gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        shut_off_computer = cpu_overheated; // Set shut_off_computer based on cpu_overheated
    end

    always @(*) begin
        if (~arrived) 
            keep_driving = ~gas_tank_empty; // Set keep_driving based on arrival and gas tank status
        else 
            keep_driving = 0; // Reset keep_driving when arrived
    end

endmodule