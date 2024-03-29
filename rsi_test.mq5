//+------------------------------------------------------------------+
//|                                          RSI_Trading_Advisor.mq5 |
//|                                   |
//|                                         |
//+------------------------------------------------------------------+
#property version   "1.00"
#include <\Trade1.mqh>

input int RSI_Period = 14;
input int RSI_Level_Sell = 56;
input int RSI_Level_Buy = 40;
input double LotSize = 0.1;
input double StopLoss = 0; // В пунктах
input double TakeProfit = 0; // В пунктах
input int Slippage = 10;

input color BuyColor = Lime;
input color SellColor = Red;

input bool ShowInfo = true;
int magic_num = 1222;
int rsi;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
    rsi = iRSI(NULL, 0, RSI_Period, PRICE_CLOSE);
   
   if(rsi == INVALID_HANDLE)
     {
      //--- tell about the failure and output the error code 
      PrintFormat("Failed to create handle of the iRSI indicator for the symbol %s/%s, error code %d",
                  Symbol(),
                  EnumToString(Period()),
                  GetLastError());
      //--- the indicator is stopped early 
      return(INIT_FAILED);
     }
     
   if(ShowInfo)
     {
      Print("RSI Trading Advisor is initialized.");
      Print("RSI Period: ", RSI_Period);
      Print("RSI Level for Sell: ", RSI_Level_Sell);
      Print("RSI Level for Buy: ", RSI_Level_Buy);
      Print("Lot Size: ", LotSize);
      Print("Stop Loss: ", StopLoss, " pips");
      Print("Take Profit: ", TakeProfit, " pips");
     }
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(ShowInfo)
     {
      Print("RSI Trading Advisor is deinitialized.");
     }  
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
    
    //--- we work only at the time of the birth of new bar
   static datetime PrevBars=0;
   datetime time_0 = iTime(_Symbol,PERIOD_CURRENT,0);
   
   if(time_0==PrevBars)
      return;
   PrevBars=time_0;
//---
   double rsi_1 = iRSIGet(1);
   if(rsi_1 == EMPTY_VALUE)
      return;
//---   
   if(rsi_1 >= RSI_Level_Sell)
     {
       Print("go in in first if");
      // Закрываем открытую покупку
      PositionSelect(_Symbol);
      if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
        {
           Print("there should open pos 1");
           Open_Sell_pos(_Symbol, LotSize, magic_num);
        }
      // Открываем сделку на продажу
      if(PositionGetInteger(POSITION_TYPE) != POSITION_TYPE_SELL)
        {
           Print("there should open pos 2");
           Open_Sell_pos(_Symbol, LotSize, magic_num);
        }
     }
     
   else if(rsi_1 <= RSI_Level_Buy)
     {
       Print("go in in second if");
      PositionSelect(_Symbol);
      // Закрываем открытую продажу
      if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
        {
           Print("there should open pos 3");
           Open_Buy_pos(_Symbol, LotSize, magic_num);
        }
      // Открываем сделку на покупку
      if(PositionGetInteger(POSITION_TYPE) != POSITION_TYPE_BUY)
        { 
           Print("there should open pos 4");
           Open_Buy_pos(_Symbol, LotSize, magic_num);
        }
     }
  }
  
  
  
  double iRSIGet(const int index)
  {
   double RSI[1];
//--- reset error code 
   ResetLastError();
//--- fill a part of the iRSI array with values from the indicator buffer that has 0 index 
   if(CopyBuffer(rsi,0,index,1,RSI)<0)
     {
      //--- if the copying fails, tell the error code 
      PrintFormat("Failed to copy data from the iRSI indicator, error code %d",GetLastError());
      //--- quit with zero result - it means that the indicator is considered as not calculated 
      return(0.0);
     }
   return(RSI[0]);
  }