`timescale 1ns / 1ps


module HazardDtection(
   //input IF_instruction,
    input clk,
    input bne,
    input branch,
    input jump,
    input ID_MemRead,
    input ID_RegWrite,
    input EX_MemRead,
    input [4:0] EX_Rt,
    input [4:0] ID_Rt,
    input [4:0] ID_Rd,
    input [4:0] IF_Rs,
    input [4:0] IF_Rt,
    output IF_Write,
    output PC_Write
    //output Controlsrc
    );
	 
 reg PCtem;
       // reg Controltem;
        reg IFIDtem;
   
        initial begin
            PCtem<=1;
            //Controltem<=0;
            IFIDtem<=1;
        end
        
        
        always@(posedge clk)
        begin
        //load use hazard:lw $2,0($1);and $4,$2,$5  
        if (ID_MemRead && ((ID_Rt==IF_Rs) | (ID_Rt==IF_Rt))&&(branch==0)&&(jump==0)&&(bne==0))
        begin
            PCtem<=0;
          //  Controltem<=1;
            IFIDtem<=0;
        end
        //lw and not ajacent beq
        else if ((bne||branch) && EX_MemRead &&((EX_Rt==IF_Rs) | (EX_Rt==IF_Rt))&&(jump==0))
        begin
            PCtem<=0;
           // Controltem<=1;
            IFIDtem<=0;
        end
        //I/lw and adjacent beq
        else if((bne||branch) && ID_RegWrite&&  ((ID_Rt==IF_Rs&& IF_Rs!=0)|(ID_Rt==IF_Rt&& IF_Rt!=0))&&(jump==0))
        begin
            PCtem<=0;
           //Controltem=1;
            IFIDtem<=0;
        end
        // r-type and adjacent beq
        else if((bne||branch) && ID_RegWrite && ((ID_Rd==IF_Rs&&IF_Rs!=0)|(ID_Rd==IF_Rt&& IF_Rt!=0))&&(jump==0))
           begin
               PCtem<=0;
               //Controltem=1;
               IFIDtem<=0;
           end
        /*else if (jump)
        begin
            PCtem=1;
            Controltem=0;
            IFIDtem=1;
        end*/
        
        else
        begin
            PCtem<=1;
            IFIDtem<=1;
           //Controltem<=0;
        end
        
        
        
        end
        
        
        assign IF_Write=IFIDtem;
        assign PC_Write=PCtem;
        //assign Controlsrc=Controltem;
        
	 	 
	 	 
	 
endmodule
