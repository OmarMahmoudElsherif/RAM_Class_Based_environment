//-----------------------------------------------------------//
//-------------------  Transaction Class  -------------------//
//-----------------------------------------------------------//
import ConfigParams_pkg::*;


class transaction;
    // Internal automatic variables
    
    // DUT inputs
    rand    logic                   rstn_tr;
    rand    logic                   en_tr;
    rand    logic                   wen_tr;
    randc   logic [ADDR_WIDTH-1:0]  Addr_tr;
    rand    logic [DATA_WIDTH-1:0]  Data_in_tr;
    // DUT Outputs
            logic [DATA_WIDTH-1:0]  Data_out_tr;
            logic                   Valid_tr;


//---------------------------------------------------//
//------------------- Constraints -------------------//
//---------------------------------------------------//


/*------- Constraints of : rstn_tr -------*/ 
    
    bit reset_zero_flag;

    // Constructor to initialize the tracking variable
    function new();
        reset_zero_flag = 0;  // Initially, rstn_tr has not been '0'
    endfunction

    // Constraint: rstn_tr should be '0' only once, and '1' afterwards
    constraint rstn_tr_constr {
        if (reset_zero_flag == 1) rstn_tr == 1;  // After '0', always '1'
        else rstn_tr inside {0, 1};              // Allow '0' or '1' the first time
    }

    // Post-randomization function to update the flag after randomization
    function void post_randomize();
        if (rstn_tr == 0) begin
            reset_zero_flag = 1;  // Set flag if rstn_tr is '0'
        end
    endfunction



/*------- Constraints of : en_tr -------*/ 

    // Constraint: en_tr should be '1' (Enabled) more than '0' (Disabled) 
    constraint en_tr_constr {
          en_tr dist {0:=10, 1:=90};   // Prob(0) = 10 % , Prob(1) = 90 %
    }


/*------- Constraints of : wen_tr -------*/ 

    // Constraint: wen_tr should be '1' (Write Operation) more than '0' (Read Operation) 
    constraint wen_tr_constr {
           wen_tr dist {0:=50, 1:=50};   // Prob(0) = 50 % , Prob(1) = 50 %
    }



/*------- Constraints of : Addr_tr -------*/ 

    // Constraint: Addr_tr should spans the whole addresses of memory, that's why it is defined as rand(c)
    constraint Addr_tr_constr {
        Addr_tr inside { [0:2**ADDR_WIDTH-1]};
    }



/*------- Constraints of : Data_in_tr -------*/ 

    // Constraint: Data_in_tr should be any valid data written in memory, so it doesnot have a certain type of constraint
    constraint Data_in_tr_constr {
        // Add your Constraint if any
    }




endclass