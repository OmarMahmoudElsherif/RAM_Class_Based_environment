//-----------------------------------------------------------//
//----------------------  Driver Class  ---------------------//
//-----------------------------------------------------------//
import ConfigParams_pkg::*;
import Classes_pkg::*;

class Driver;
    
    // making instance from transcation class
    transaction tr_class;

    // Generic mailbox of type transaction 
    mailbox #(transaction) mailbox_drv ;

    // Instance of virtual interface
    virtual mem_interface vif_seq;


//---------------------------------------------------//
//------------------ Class Methods ------------------//
//---------------------------------------------------//

    // Constructor to access the driver mailbox
    function new(mailbox #(transaction) mailbox_seq,virtual mem_interface vif );
        mailbox_drv = mailbox_seq;  // make mailbox handle of driver and sequencer class point to same mailbox
        vif_seq     =   vif;
    endfunction

    // Send Transaction data to From Sequencer to Driver
    task run();
        forever begin
            // get data from mailbox, statement gets blocked mailbox is empty
            mailbox_drv.get(tr_class); 
            // send data to memory interface
            @(posedge vif_seq.clk_intf) begin
                vif_seq.rstn_intf       =     tr_class.rstn_tr;
                vif_seq.en_intf         =     tr_class.en_tr;
                vif_seq.wen_intf        =     tr_class.wen_tr;
                vif_seq.Addr_intf       =     tr_class.Addr_tr;
                vif_seq.Data_in_intf    =     tr_class.Data_in_tr;
            end
        end
    endtask

    

    


endclass