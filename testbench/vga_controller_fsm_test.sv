module vga_controller_fsm_test;

    reg         clk;
    reg         reset_n;
    reg         load;
    reg         key;

    wire [4:0]  col;
    wire [7:0]  row;
    wire        ack;
    wire        load_mem;

    reg  [511:0] current_ca;

    wire [12:0]  addr_b;
    wire [15:0]  in_b;

    vga_buffer inst_vga_buffer
        (
            .clk    (clk),
            .addr_a (0),
            .addr_b (addr_b),
            .load_a (0),
            .in_a   (0),
            .in_b   (in_b),
            .load_b (load_mem)
            // .out_a  (out_a),
            // .out_b  (out_b)
        );

    vga_controller_fsm inst_vga_controller_fsm
        (
            .clk      (clk),
            .reset_n  (reset_n),
            .load     (load),
            .key      (key),
            .col      (col),
            .row      (row),
            .ack      (ack),
            .load_mem (load_mem)
        );

    bit [15:0] mem [0:31];
    bit [15:0] random_word;

    initial
    begin
        for(int i = 0; i < 32; i++)
        begin
            random_word = $random();
            current_ca[511-16*i] = random_word[15];
            current_ca[510-16*i] = random_word[14];
            current_ca[509-16*i] = random_word[13];
            current_ca[508-16*i] = random_word[12];
            current_ca[507-16*i] = random_word[11];
            current_ca[506-16*i] = random_word[10];
            current_ca[505-16*i] = random_word[09];
            current_ca[504-16*i] = random_word[08];
            current_ca[503-16*i] = random_word[07];
            current_ca[502-16*i] = random_word[06];
            current_ca[501-16*i] = random_word[05];
            current_ca[500-16*i] = random_word[04];
            current_ca[499-16*i] = random_word[03];
            current_ca[498-16*i] = random_word[02];
            current_ca[497-16*i] = random_word[01];
            current_ca[496-16*i] = random_word[00];
            mem[i] = random_word[15:0];
        end
    end

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

    always
    begin
        load = 0;
        repeat(5) @(negedge clk);
        load = 1;
        wait(ack == 1);
        repeat(2)  @(negedge clk);
        // $stop;
    end

    initial
    begin
        wait(addr_b == '1);
        repeat(10) @(negedge clk);
        $stop;
    end


    initial key = 1;

    assign in_b = {current_ca[511 - {col, 4'h0}],
                   current_ca[510 - {col, 4'h0}],
                   current_ca[509 - {col, 4'h0}],
                   current_ca[508 - {col, 4'h0}],
                   current_ca[507 - {col, 4'h0}],
                   current_ca[506 - {col, 4'h0}],
                   current_ca[505 - {col, 4'h0}],
                   current_ca[504 - {col, 4'h0}],
                   current_ca[503 - {col, 4'h0}],
                   current_ca[502 - {col, 4'h0}],
                   current_ca[501 - {col, 4'h0}],
                   current_ca[500 - {col, 4'h0}],
                   current_ca[499 - {col, 4'h0}],
                   current_ca[498 - {col, 4'h0}],
                   current_ca[497 - {col, 4'h0}],
                   current_ca[496 - {col, 4'h0}]};

    assign addr_b = {row, col};

endmodule
