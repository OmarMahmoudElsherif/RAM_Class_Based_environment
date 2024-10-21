//-----------------------------------------------------------//
//----------------------  Driver Class  ---------------------//
//-----------------------------------------------------------//
import ConfigParams_pkg::*;
import Classes_pkg::*;

class monitor;
    
    // making instance from transcation class
    transaction tr_class;

    // Generic mailbox of type transaction 
    mailbox #(transaction) mailbox_mntr_to_sb;
    mailbox #(transaction) mailbox_mntr_to_sub;

    // Instance of virtual interface
    virtual mem_interface vif_mntr;


//---------------------------------------------------//
//------------------ Class Methods ------------------//
//---------------------------------------------------//

    // Constructor 
    function new(mailbox #(transaction) mailbox_scoreboard,mailbox #(transaction) mailbox_subscriber,virtual mem_interface vif );
        // // reserve memory for "Subscriber - Monitor" mailbox 
        // mailbox_mntr_to_sb =  new;     // unbounded mailbox
        // // reserve memory for  "Scoreboard - Monitor" mailbox 
        // mailbox_mntr_to_sub =  new;     // unbounded mailbox
        // make mailbox handle of Monitor and Subscriber class point to same mailbox
        mailbox_mntr_to_sb  = mailbox_subscriber;
        mailbox_mntr_to_sub = mailbox_scoreboard; 
        // make virtual interface of Monitor and Memory(DUT) point to same interface
        vif_mntr     =   vif;
        // reserve memory for transaction
        tr_class     =   new;
    endfunction

    // Send Transaction data to From Sequencer to Driver
    task run();
        forever begin
            
            @(negedge vif_mntr.clk_intf);   // @(posedge vif_mntr.clk_intf);
                
            tr_class.rstn_tr        =   vif_mntr.rstn_intf;
            tr_class.en_tr          =   vif_mntr.en_intf; 
            tr_class.Data_out_tr    =   vif_mntr.Data_out_intf;
            tr_class.Valid_tr       =   vif_mntr.Valid_intf;
            tr_class.wen_tr         =   vif_mntr.wen_intf;
            tr_class.Addr_tr        =   vif_mntr.Addr_intf;
            tr_class.Data_in_tr     =   vif_mntr.Data_in_intf;

            // Send data to scoreboard
            mailbox_mntr_to_sb.put(tr_class);
            // Send data to subscriber 
            mailbox_mntr_to_sub.put(tr_class); 
            

        end
    endtask

    

    


endclass