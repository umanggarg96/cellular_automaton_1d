module ca_core_test;

    reg         clk;
    reg         reset_n;
    reg  [3:0]  sw;
    reg         ack;

    wire [7:0]  debug_leds;
    wire        load;

    ca_core #(
            .N(7)
        ) inst_ca_core (
            .clk        (clk),
            .reset_n    (reset_n),
            .sw         (sw),
            .ack        (ack),
            .debug_leds (debug_leds),
            .load       (load)
        );

    initial
    begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial
    begin
        reset_n = 0;
        repeat(2) @(negedge clk);
        reset_n = 1;
    end

    initial
        sw = 4'b0000;

    always
    begin
        ack = 0;
        wait(load == 1);
        repeat (3) @(negedge clk);
        ack = 1;
        @(negedge clk);
        ack = 0;
    end

    initial
    begin
        repeat(10000) @(negedge clk);
        $stop;
    end

endmodule
