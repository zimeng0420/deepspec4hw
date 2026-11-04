module top_module (
    input cpu_overheated,
    output reg shut_off_computer,
    input arrived,
    input gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        if (cpu_overheated)
            shut_off_computer = 1;
        else
            shut_off_computer = 0;  //Crucial addition:  Ensure shut_off_computer defaults to 0 when not overheated.
    end

    always @(*) begin
        if (!arrived)
            keep_driving = !gas_tank_empty;
        else
            keep_driving = 0; //Crucial addition:  Ensure keep_driving defaults to 0 when arrived.
    end

endmodule