module ca_controller_fsm(clk, reset_n, ack, index, index_next, update, load);

        input  wire         clk;
        input  wire         reset_n;
        input  wire         ack;
        input  wire [9:0]   index;

        output reg  [9:0]   index_next;
        output reg          update;
        output reg          load;

        parameter N = 640;

        enum reg [2:0] {START, CALC, INCR, UPDATE, LOAD} state_reg, state_next;

        always @(posedge clk)
            if(~reset_n)    state_reg <= START;
            else            state_reg <= state_next;

        always @*
        begin
            index_next = index;
            update = 0;
            load = 0;
            state_next = state_reg;
            case(state_reg)
                START:
                begin
                    index_next = 1;
                    state_next = CALC;
                end
                CALC:
                begin
                    if(index < N)    state_next = INCR;
                    else                state_next = UPDATE;
                end
                INCR:
                begin
                    index_next = index + 1;
                    state_next = CALC;
                end
                UPDATE:
                begin
                    update = 1;
                    state_next = LOAD;
                end
                LOAD:
                begin
                    load = 1;
                    if(~ack)        state_next = LOAD;
                    else            state_next = START;
                end
            endcase
        end
endmodule
