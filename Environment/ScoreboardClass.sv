//-----------------------------------------------------------//
//--------------------  Scoreboard Class  -------------------//
//-----------------------------------------------------------//
import ConfigParams_pkg::*;
import Classes_pkg::*;

class scoreboard;
    
    // making instance from transcation class
    transaction tr_class;

    // Generic mailbox of type transaction 
    mailbox #(transaction) mailbox_sb;

    // Associative array to store data_out and Address from DUT incase of Read Operation
    logic golden_ref [*];

    // Counter for number of transactions
    int tr_count;

    // Number of Successful Transaction 
    int no_succ_tr;

    // Number of Failed Transaction 
    int no_fail_tr;



//---------------------------------------------------//
//------------------ Class Methods ------------------//
//---------------------------------------------------//

    // Constructor 
    function new(mailbox #(transaction) mailbox_mntr_scoreboard);
        // make mailbox handle of Monitor and Scoreboard class point to same mailbox
        mailbox_sb = mailbox_mntr_scoreboard; 
        // reserve memory for transaction
        tr_class     =   new;
        // clears transactions counters
        tr_count    =   0;
        no_succ_tr  =   0;
        no_fail_tr  =   0;
    endfunction



    // get Transaction data to From Monitor to Scoreboard
    task run();
        forever begin
            
            // Get data from Monitor
            mailbox_sb.get(tr_class);
            // increment transaction counter
            tr_count++;

            // reset activated
            if(tr_class.rstn_tr == 'b0) begin   
                if(tr_class.Data_out_tr == 'b0 && tr_class.Valid_tr == 'b0)  begin
                    $display("Transaction : %d, Reset Activated Correctly",tr_count);
                    no_succ_tr++;
                end  
                else begin
                    $error("Transaction : %d, Reset Asserted deactivation Failed",tr_count);
                    no_fail_tr++;
                end   
            end
            
            // reset deactivated
            else begin
                
                // Memory is disabled
                if(tr_class.en_tr == 'b0) begin
                    if(tr_class.Data_out_tr == 'b0 && tr_class.Valid_tr == 'b0)  begin
                        $display("Transaction : %d, Enable (en) deactivated Correctly",tr_count);
                        no_succ_tr++;
                    end  
                    else  begin
                        $error("Transaction : %d, Enable (en) deactivation Failed",tr_count);
                        no_fail_tr++;
                    end  
                end
                
                // Memory is Enabled
                else begin
                    
                    // Write Operation
                    if(tr_class.wen_tr == 'b1) begin
                        
                        if(tr_class.Data_out_tr == 'b0 && tr_class.Valid_tr == 'b0)  begin
                            $display("Transaction : %d, Write Operation Activated Correctly",tr_count);
                            no_succ_tr++;
                        end 
                        else begin
                            $error("Transaction : %d, Write Operation Activation Failed",tr_count);
                            no_fail_tr++;
                        end   
                
                        //  stores written data and address in associative array
                        golden_ref[tr_class.Addr_tr]   =   tr_class.Data_in_tr;    
                    end

                    // Read Operation
                    else begin
                        
                        if(tr_class.Data_out_tr == golden_ref[tr_class.Addr_tr] && tr_class.Valid_tr == 'b1)  begin
                            $display("Transaction : %d, Read Operation Activated Correctly",tr_count);
                            no_succ_tr++;
                        end  
                        else  begin
                            $error("Transaction : %d, Read Operation Activation Failed",tr_count);
                            no_fail_tr++;
                        end  
                    end

                end

            end        



        end

    endtask

    

    


endclass