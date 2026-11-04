module top_module (
    input cpu_overheated,
    output reg shut_off_computer,
    input arrived,
    input gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        shut_off_computer = cpu_overheated; // Set to 1 if cpu_overheated is true, else set to 0
    end

    always @(*) begin
        if (~arrived) 
            keep_driving = ~gas_tank_empty; // Keep driving if not arrived and gas tank is not empty
        else 
            keep_driving = 0; // Set to 0 if arrived
    end

endmodule