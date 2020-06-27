module ca_core #
(
    parameter ACTIVE_CELL = 128
)
(
  input  wire          clk, 
  input  wire          reset_n, 
  output wire [ACTIVE_CELL-1:0]  ca
);

    localparam TOTAL_CELL  = ACTIVE_CELL + 2;
    localparam INDEX_WIDTH = $clog2(TOTAL_CELL);

    logic [(TOTAL_CELL -1): 0] caState;

    logic [(INDEX_WIDTH-1):0] index;
    localparam [(INDEX_WIDTH-1):0] const1 = {{(INDEX_WIDTH-1){1'b0}}, 1'b1};

    wire  [7:0] func;
    wire  [2:0] in;

    always @(posedge clk)
      if(~reset_n)                 index <= const1;
      else if (index < TOTAL_CELL) index <= index + const1;
      else                         index <= const1;

    always @(posedge clk)
        if(~reset_n)    caState        <= (130'b1 << 65);
        else            caState[index] <= func[in];

    assign in = {caState[index + 1], caState[index], caState[index - 1]};
  
    assign func = 8'd182;

    assign ca = caState[TOTAL_CELL-2:1];
endmodule
