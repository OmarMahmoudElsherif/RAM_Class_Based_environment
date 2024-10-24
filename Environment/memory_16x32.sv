/////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////// Module ports list, declaration, and data type ///////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
module memory_16x32 #(
    parameter 	ADDR_WIDTH  =	4,
    parameter   DATA_WIDTH  =   32 
) (
///////////////////// Inputs /////////////////////
    input   wire    logic                        clk,
    input   wire    logic                        rstn,
    input   wire    logic                        en,
    input   wire    logic                        wen,
    input   wire    logic    [ADDR_WIDTH-1:0]    Addr,
    input   wire    logic    [DATA_WIDTH-1:0]    Data_in,

//////////////////// Outputs /////////////////////
    output  wire    logic    [DATA_WIDTH-1:0]    Data_out,
    output  wire    logic                        Valid
);

//////////////////////////////////////////////////////////////
/////////////////////  local Parameters  /////////////////////
//////////////////////////////////////////////////////////////

localparam MEM_DEPTH = 2**ADDR_WIDTH;


//////////////////////////////////////////////////////////////
///////////////////  Internal  Elements  /////////////////////
//////////////////////////////////////////////////////////////

// memory 16x32
reg [DATA_WIDTH-1:0]    Memory  [MEM_DEPTH-1:0];

// iterator
integer i;

//////////////////////////////////////////////////////////////
//////////////////////  Write Operation   ////////////////////
//////////////////////////////////////////////////////////////

always_ff @( posedge clk, negedge rstn ) begin
    // Asynchronous reset
    if(!rstn) begin
        for(i=0; i<MEM_DEPTH; i=i+1) begin
            Memory[i]   <=    'b0;
        end
    end
    // memory enabled and write operation
    else if (en && wen) begin
            Memory[Addr]    <=  Data_in;
    end
    
end



//////////////////////////////////////////////////////////////
///////////////////////  Read Operation   ////////////////////
//////////////////////////////////////////////////////////////

assign Data_out = ( en & !wen ) ? Memory[Addr] : 'b0;
assign Valid    = ( en & !wen & rstn) ? 1'b1 : 1'b0;




endmodule