//-----------------------------------------------------------//
//--------------------  Subscriber Class  -------------------//
//-----------------------------------------------------------//
import ConfigParams_pkg::*;
import Classes_pkg::*;

class subscriber;
    
    // making instance from transcation class
    transaction tr_class;

    // Generic mailbox of type transaction 
    mailbox #(transaction) mailbox_subs;


//---------------------------------------------------//
//-------------------- Coverage ---------------------//
//---------------------------------------------------//

    
    covergroup cov_group;

        // coverpoint : rstn
        reset : coverpoint tr_class.rstn_tr{
            bins state_bins[]       =   {0,1};
            bins transition_bins[]  =   {(0=>1),(1=>0)};
        }
        
        // coverpoint : en
        Enable : coverpoint tr_class.en_tr{
            bins state_bins[]       =   {0,1};
            bins transition_bins[]  =   {(0=>1),(1=>0)}; 
        }

        // coverpoint : wen
        Write_Enable : coverpoint tr_class.wen_tr{
            bins state_bins[]       =   {0,1};
            bins transition_bins[]  =   {(0=>1),(1=>0)};
        }

        // coverpoint : Addr
        Address : coverpoint tr_class.Addr_tr{
            bins state_bins[]       =   {[0:15]};
        }
        
        // coverpoint : Data_in
        Input_Data : coverpoint tr_class.Data_in_tr{
            bins state_bins[]       =   {[0:$]};
        }

        // coverpoint : Data_out
        Output_Data : coverpoint tr_class.Data_out_tr{
            bins state_bins[]       =   {[0:$]};
        }

        // coverpoint : Valid
        Valid : coverpoint tr_class.Valid_tr{
            bins state_bins[]       =   {0,1};
            bins transition_bins[]  =   {(0=>1),(1=>0)};
        }




    endgroup





//---------------------------------------------------//
//------------------ Class Methods ------------------//
//---------------------------------------------------//

    // Constructor 
    function new(mailbox #(transaction) mailbox_mntr_subscriber);
        // make mailbox handle of Monitor and Subscriber class point to same mailbox
        mailbox_subs = mailbox_mntr_subscriber; 
        // reserve memory for transaction
        tr_class     =   new;
        // reserve memory for coverpoint
        cov_group   =   new;
    endfunction



    // get Transaction data to From Monitor to Subscriber
    task run();
        forever begin
            // Get data from Monitor
            mailbox_subs.get(tr_class);
            // sample covergroup function
            cov_group.sample(); 
        end
    endtask

    

    


endclass