//-----------------------------------------------------------//
//-----------------------  Interface  -----------------------//
//-----------------------------------------------------------//

interface mem_interface #(
    parameter   ADDR_WIDTH  =  4,
    parameter   DATA_WIDTH  =  32
) (
   output logic                   clk_intf,
   output logic                   rstn_intf,
   output logic                   en_intf,
   output logic                   wen_intf,
   output logic [ADDR_WIDTH-1:0]  Addr_intf,
   output logic [DATA_WIDTH-1:0]  Data_in_intf,
   input  logic [DATA_WIDTH-1:0]  Data_out_intf,
   input  logic                   Valid_intf
);
endinterface