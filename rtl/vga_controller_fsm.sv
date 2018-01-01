module vga_controller_fsm(clk, reset_n, load, key, col, row, ack, load_mem);

    input  wire         clk;
    input  wire         reset_n;
    input  wire         load;
    input  wire         key;

    output reg  [4:0]   col;
    output reg  [7:0]   row;
    output reg          ack;
    output reg          load_mem;

    enum reg [2:0] {IDLE,
                    COPY,
                    INCR,
                    ACK,
                    WAIT} state_reg, state_next;
    reg [4:0] col_next;
    reg [7:0] row_next;

    always @(posedge clk)
        if(~reset_n)        state_reg <= IDLE;
        else                state_reg <= state_next;

    always @(posedge clk)
        if(~reset_n)        col <= 5'd0;
        else                col <= col_next;

    always @(posedge clk)
        if(~reset_n)        row <= 8'h00;
        else                row <= row_next;

    always @*
    begin
        col_next = col;
        row_next = row;
        state_next = state_reg;
        load_mem = 0;
        ack = 0;
        case(state_reg)
            IDLE:
            begin
                if(~load)   state_next = IDLE;
                else        state_next = COPY;
            end
            COPY:
            begin
                col_next = col + 5'd1;
                load_mem = 1;
                if(col < 5'd31)     state_next = COPY;
                else                state_next = INCR;
            end
            INCR:
            begin
                row_next = row + 8'd1;
                if(row < 8'd255)    state_next = ACK;
                else                state_next = WAIT;
            end
            WAIT:
            begin
                if(key) state_next = WAIT;
                else    state_next = ACK;
            end
            ACK:
            begin
                ack = 1;
                state_next = IDLE;
            end
        endcase
    end
endmodule
