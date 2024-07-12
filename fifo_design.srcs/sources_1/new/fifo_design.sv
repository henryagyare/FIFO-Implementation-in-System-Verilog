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


module fifo_design(
    input logic clock, write_enable, read_enable, reset,
    output logic empty, full,
    input logic [3:0] write_data,
    output logic [3:0] read_data
    );

    logic [3:0] fifo_queue [7:0];
    logic [2:0] head, tail;

    // initial 
    // begin
    //     head = 3'b000;
    //     tail = 3'b000;
    //     full = 0;
    //     empty = 0;
    // end

    always_ff @( posedge clock) 
    begin : linear_fifo
        if (!reset)
            begin
                tail <= '0;
                head <= '0;
                full <= '0;
                empty <= '0;

                for (int i = 0; i < 8; i++)
                    fifo_queue[i][3:0] <= 4'bXXXX;
            end
        else
            if (write_enable)
                if (!read_enable)
                    begin 
                        fifo_queue[head][3:0] <= write_data;
                        head <= head + 1;
                        empty <= 1'b0;
                    end
                else
                    head <= head;
            else
                if (read_enable)
                    begin
                        read_data <= fifo_queue[tail][3:0];
                        tail <= tail + 1;
                    end
                else 
                    tail <= tail;
            //  Full and Empty Flags
            if (head == tail)
                begin
                    empty <= 1'b1;
                    full <= 1'b0;
                end
            else 
                if (tail == (head + 1))
                    begin
                        full <= 1'b1;
                        empty <= 1'b0;
                    end
    end

endmodule
