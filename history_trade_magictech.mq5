//+------------------------------------------------------------------+
//|                                          Historico_magictech.mq5 |
//|                                                     by JJ        |
//|                               http://www.jandersonfferreira.info |
//+------------------------------------------------------------------+
#property copyright "by JJ"
#property link      "http://www.jandersonfferreira.info"
#property version   "1.00"
#property  description "The script adds deals history (using the graphic objects) on the chart"
#include <Files\FileTxt.mqh>
MqlTick last_tick;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

int OnInit(){
   EventSetTimer(10);
   return 0;
}

void OnDeinit(const int reason){
   EventKillTimer();
}

void OnTimer()  {
//---
   CFileTxt txtFile;
   string linTxt; 
   string sDirection, txt;
   int indexDeals, typeDeal, flagClose, magic_id;
   ulong tic =0;ulong deal_ticket; 
   double volums = 0;double open_price;double p2;
   datetime open_time; datetime t2;
   long pos_id;
   color colir;
   ENUM_OBJECT type_obj = OBJ_ARROW;   
     
   HistorySelect(0,TimeCurrent());    
   int totDeals=HistoryDealsTotal();
   txtFile.Open("history_data.csv", FILE_TXT|FILE_WRITE);
   txtFile.WriteString("DEAL_ID;MAGIC_NUMBER;DATE;ASSET;DIRECTION;SIZE;PROFIT;\n");
   for(indexDeals=0;indexDeals<totDeals;indexDeals++)    {
     flagClose  = 0;
     tic        = HistoryDealGetTicket(indexDeals);
     volums     = HistoryDealGetDouble(tic,DEAL_VOLUME);
     open_time  = (datetime) HistoryDealGetInteger(tic,DEAL_TIME);
     open_price = HistoryDealGetDouble(tic, DEAL_PRICE);
     magic_id   = HistoryDealGetInteger(tic, DEAL_MAGIC);
     pos_id     = HistoryDealGetInteger(tic, DEAL_POSITION_ID);
     //typeDeal   = HistoryDealGetInteger(tic, ENUM_DEAL_TYPE);
     sDirection="";
     if(HistoryDealGetInteger(tic,DEAL_TYPE) == DEAL_TYPE_BUY ) { sDirection = "B";}
     else if(HistoryDealGetInteger(tic,DEAL_TYPE) == DEAL_TYPE_SELL ){ sDirection = "S";}
     
     if( sDirection!="" &&   HistoryDealGetInteger(tic,DEAL_ENTRY)==DEAL_ENTRY_IN){

     linTxt = HistoryDealGetInteger(tic,DEAL_POSITION_ID)+";"+ open_time+";"+magic_id+";"+sDirection+";"+ HistoryDealGetString(tic, DEAL_SYMBOL) + ";" + DoubleToString(volums,2)+";";

        for(int ii=indexDeals;ii<totDeals;ii++)     {
            deal_ticket=HistoryDealGetTicket(ii);
            if( HistoryDealGetInteger(deal_ticket, DEAL_POSITION_ID) == pos_id && HistoryDealGetInteger(deal_ticket,DEAL_ENTRY) == DEAL_ENTRY_OUT )    { 
               linTxt= linTxt + HistoryDealGetDouble(deal_ticket,DEAL_PROFIT);
               flagClose=1;
            }     
        }
         if (flagClose==1) txtFile.WriteString(linTxt + "\n");
      }
   }
   txtFile.Close();
  }
