module ca_controller_fsm_test;

    reg         clk;
    reg         reset_n;
    reg         ack;
    reg  [9:0]  index;
    wire [9:0]  index_next;
    wire        update;
    wire        load;

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
    begin
        repeat(6000)
        @(negedge clk);
        $stop;
    end

    always
    begin
        ack = 0;
        wait(load == 1);
        repeat(2)
        @(negedge clk);
        ack = 1;
        @(negedge clk);
        ack = 0;
    end

    always @(posedge clk)
        if(~reset_n) index <= 10'd1;
        else         index <= index_next;

    ca_controller_fsm inst_ca_controller_fsm
        (
            .clk        (clk),
            .reset_n    (reset_n),
            .ack        (ack),
            .index      (index),
            .index_next (index_next),
            .update     (update),
            .load       (load)
        );


endmodule
