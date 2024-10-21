//-----------------------------------------------------------//
//--------------------  Sequencer Class  --------------------//
//-----------------------------------------------------------//
import ConfigParams_pkg::*;
import Classes_pkg::*;

class Sequencer;
    
    // making instance from transcation class
    transaction tr_class;

    // Generic mailbox of type transaction 
    mailbox #(transaction) mailbox_seq ;

    // counter for number of transactions required
    int no_trans;

//---------------------------------------------------//
//------------------ Class Methods ------------------//
//---------------------------------------------------//

    // Constructor to access the driver mailbox
    function new(mailbox #(transaction) mailbox_drv);
        // reserve memory for mailbox
        // mailbox_seq =  new;     // unbounded mailbox
        mailbox_seq = mailbox_drv;  // make mailbox handle of driver and sequencer class point to same mailbox
        // reserve memory for transaction
        tr_class = new;
    endfunction

    // Send Transaction data to From Sequencer to Driver
    task run();
        // generate transaction for a required finite number of transactions
        repeat(no_trans) begin
            void'(tr_class.randomize());
            mailbox_seq.put(tr_class);    
        end
        
    endtask

    

    


endclass