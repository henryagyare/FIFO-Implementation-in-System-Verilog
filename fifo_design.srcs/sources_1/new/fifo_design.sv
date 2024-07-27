`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 07/12/2024 01:06:05 PM
    // Design Name: 
    // Module Name: fifo_design
    // Project Name: 
    // Target Devices: 
    // Tool Versions: 
    // Description: 
    // 
    // Dependencies: 
    // 
    // Revision:
    // Revision 0.01 - File Created
    // Additional Comments:
    // 
//////////////////////////////////////////////////////////////////////////////////


module fifo_design #(
    parameter fifo_depth = 4,
    parameter fifo_width = 4)
    (
    input logic clock1, write_enable, read_enable, reset, clock2,
    input logic [3:0] write_data,
    output logic empty, full,
    output logic [3:0] read_data
    );

    // logic [3:0] fifo_queue [3:0];
    logic [fifo_width - 1 : 0] fifo_queue [fifo_depth - 1 : 0];
    logic [1:0] head, tail;

    //  Full and Empty Flags
    always_comb 
        begin
            if (head == tail)
               begin
                    empty = 1'b1;
                    full = 1'b0;
               end
            else 
                if (((tail == 0) && (head == fifo_depth - 1)) || (tail == (head + 1)))
                   begin
                        full = 1'b1;
                        empty = 1'b0;
                   end
                else
                    begin
                        empty = 1'b0;
                        full = 1'b0;
                    end
        end

    always_ff @(posedge clock1 ) 
        begin : head_assignments
            if (!reset)
                begin
                    head <= 0;
                end
            else 
                begin
                    if (write_enable == 1 && full == 0)
                        begin
                            head <= head + 1;                
                        end
                end
        end        

    always_ff @(posedge clock2) 
        begin : tail_assignments
            if (!reset)
                begin
                    tail <= 0;
                end            
            else
                begin
                    if (read_enable == 1 && empty == 0)
                        begin
                            tail <= tail + 1;
                        end
                end
        end

    always_ff @( posedge clock1 ) 
        begin : writing_data
            if (reset == 1 && write_enable == 1 && full == 0)
                begin
                    fifo_queue[head] <= write_data;
                end
        end

    always_ff @( posedge clock2 ) 
        begin : reading_data
            if (reset == 1 && read_enable == 1 && empty == 0)
                begin
                    read_data <= fifo_queue[tail];            
                end
        end



    // always_ff @( posedge clock) 
    //     begin
    //         if (!reset)
    //             begin
    //                 tail <= '0;
    //                 // head <= '0;
    //                 // full <= '0;
    //                 // empty <= '0;
    //             end
    //         else
    //         // Wrting to buffer operation
    //             if (write_enable)
    //                 begin
    //                     if (!read_enable)
    //                         if (!full)
    //                             begin
    //                                 fifo_queue[head] <= write_data;
    //                                 // head <= head + 1;
    //                             //    empty <= 1'b0;
    //                             end
    //                 end
    //             else
    //             // Reading from Buffer operation
    //                 begin
    //                     if (read_enable)
    //                         if (!empty)
    //                            begin
    //                                 read_data <= fifo_queue[tail];
    //                                 // tail <= tail + 1;
    //                             end
    //                 end
    //     end

endmodule
