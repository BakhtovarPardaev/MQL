//+------------------------------------------------------------------+
//|                                            FirstRobot_Tester.mq5 |
//|                                                  dilettantcorner |
//|                                        dilettantcorner@gmail.com |
//+------------------------------------------------------------------+
#property copyright "dilettantcorner"
#property link      "dilettantcorner@gmail.com"
#property version   "1.00"
#include  <MyFirstIncludeFile_Comment.mqh>

/*Структура настроек для символов*/
struct SymbSettings
{
   string            symbol;
   int               SignalCandels;
   double            inLot;
   double            TargetProfit;
   double            OutComission;
   bool              UseStohFiltr;
   int               handle;
   datetime          t;
   ENUM_TIMEFRAMES   tf;
};



sinput int Magic_num = 665;
input int inFiltr = 50;
sinput int Slipage = 10;
/*Расписываем настройки для каждого символа
не важно, будет ли задействован в реале, или нет*/
input string symbol0 = "EURUSD";
input int SignalCandels0 = 4;
input double inLot0 = 0.01;
input double TargetProfit0 = 1.0;
input double OutComission0 = 0.04;
input bool UseStohFiltr0 = true;
input ENUM_TIMEFRAMES tf0 = PERIOD_H1;

input string symbol1 = "GBPUSD";
input int SignalCandels1 = 3;
input double inLot1 = 0.03;
input double TargetProfit1 = 3.0;
input double OutComission1 = 0.0;
input bool UseStohFiltr1 = true;
input ENUM_TIMEFRAMES tf1 = PERIOD_H4;

input string symbol2 = "USDJPY";
input int SignalCandels2 = 6;
input double inLot2 = 0.2;
input double TargetProfit2 = 10.0;
input double OutComission2 = 2.22;
input bool UseStohFiltr2 = false;
input ENUM_TIMEFRAMES tf2 = PERIOD_M30;
/*Итоговый массив с настройками по всем торгуемым символам*/
SymbSettings SYMBOLS[3];

double start_balance;         //////////FOR TESTER
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
//---
///////////////////////////// FOR TESTER///////////////////////////////////////////
   if(!MQLInfoInteger(MQL_TESTER) && !MQLInfoInteger(MQL_OPTIMIZATION) && !MQLInfoInteger(MQL_VISUAL_MODE))
     {
      Alert("Недопустимый режим работы программы");
      return INIT_PARAMETERS_INCORRECT;
     }

   start_balance = AccountInfoDouble(ACCOUNT_BALANCE);

//////////////////////////END FOR TESTER///////////////////////////////////////////
   /*Инициализация пользовательского ввода.
   Назначение настроек на свои места*/
   SetSymbols();
   /*Проверка на то, нужно ли вообще хоть что-то делать*/
   int symb_count = CountSymbols();
   if(symb_count == 0)
     {
      Print("Символы для тетстирования отсутствуют. Инициализация прервана.");
      return INIT_FAILED;
     }
   Print("Тестируется ",symb_count," символа из ",ArraySize(SYMBOLS),"-x.");

   Print("Инициализация эксперта прошла успешно");
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//---
//Comment("");
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   for(int symb = 0; symb < ArraySize(SYMBOLS); symb++)
     {
      if(SYMBOLS[symb].symbol == "") continue;
      string symbol = SYMBOLS[symb].symbol;
      ENUM_TIMEFRAMES tf = (ENUM_TIMEFRAMES)SYMBOLS[symb].tf;

      if(SYMBOLS[symb].t == iTime(symbol,tf,0)) continue;
      int SignalCandels = SYMBOLS[symb].SignalCandels;
      double inLot = LotNormalize(SYMBOLS[symb].inLot,symbol);
      bool UseStohFiltr = SYMBOLS[symb].UseStohFiltr;
      double TargetProfit = SYMBOLS[symb].TargetProfit;
      double OutComission = SYMBOLS[symb].OutComission;
      int StohHandle = SYMBOLS[symb].handle;

      //if(SYMBOLS[symb].t != iTime(symbol,tf,0))
      //{
//---
      SYMBOLS[symb].t = iTime(symbol,tf,0);

      if (CountPositions(Magic_num,symbol) > 0)
        {
         ulong Positions[];
         int size = CountPositions(Magic_num,symbol);
         ArrayResize(Positions,size);
         GetPositionsTickets(Magic_num,symbol,Positions);

         for(int z = 0; z < ArraySize(Positions); z++)
           {
            ulong positon = Positions[z];
            datetime pos_op_time = 0;
            double pos_sl = 0, pos_tp = 0;
            if(PositionSelectByTicket(positon))
              {
               pos_op_time = (datetime)PositionGetInteger(POSITION_TIME);
               pos_sl = PositionGetDouble(POSITION_SL);
               pos_tp = PositionGetDouble(POSITION_TP);
              }

            if(pos_op_time < SYMBOLS[symb].t)
              {
               double profit = Profit(positon,OutComission,true);
               if(profit >= TargetProfit)
                 {
                  if(!Close_Position(positon,Slipage))
                    {
                     SYMBOLS[symb].t = 0;
                     continue;
                    }
                  else continue;
                 }
              }

            if(pos_sl == 0 || pos_tp == 0)
              {
               int index = 0;
               int total_bars = iBars(symbol,tf);
               if(total_bars <= 0)
                 {
                  SYMBOLS[symb].t = 0;
                  continue;
                 }

               for(int i = 0; i < total_bars; i++)
                 {
                  if(pos_op_time < iTime(symbol,tf,i)) continue;
                  else
                    {
                     index = i + 1;
                     break;
                    }
                 }

               int end_index = index + (SignalCandels - 1);

               int sl = 0, tp = 0;
               double pos_open_price = PositionGetDouble(POSITION_PRICE_OPEN);
               ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

               SetStopLevels(symbol,tf,positon,index,end_index,sl,tp);

               if(pos_type == POSITION_TYPE_BUY)
                 {
                  double close_price = SymbolInfoDouble(symbol,SYMBOL_BID);
                  if((close_price < pos_open_price && PriceDistance(pos_open_price,close_price,symbol) >= sl) ||
                        (close_price > pos_open_price && PriceDistance(pos_open_price,close_price,symbol) >= tp))
                    {
                     if(!Close_Position(positon,Slipage))
                       {
                        SYMBOLS[symb].t = 0;
                        continue;
                       }
                     else continue;
                    }
                 }
               else
                 {
                  double close_price = SymbolInfoDouble(symbol,SYMBOL_ASK);
                  if((close_price > pos_open_price && PriceDistance(pos_open_price,close_price,symbol) >= sl) ||
                        (close_price < pos_open_price && PriceDistance(pos_open_price,close_price,symbol) >= tp))
                    {
                     if(!Close_Position(positon,Slipage))
                       {
                        SYMBOLS[symb].t = 0;
                        continue;
                       }
                     else continue;
                    }
                 }

               if(!Position_SLTP(positon,sl,tp))
                 {
                  SYMBOLS[symb].t = 0;
                  continue;
                 }
              }
           }
        }

////////////////////FOR TESTER///////////////////////////
      double cur_balance = AccountInfoDouble(ACCOUNT_BALANCE);
      if(cur_balance > start_balance) TesterWithdrawal(MathAbs(cur_balance - start_balance));
/////////////////END FOR TESTER//////////////////////////

      if (CountPositions(Magic_num,symbol) == 0)
        {
         char signalFlag = 0;       //0 - No Signal ; 1 - BUY ; 2 - SELL
         for(int i = 1; i <= SignalCandels; i++)
           {
            if(i == 1)
              {
               if(iOpen(symbol,tf,i) > iClose(symbol,tf,i)) signalFlag = 1;
               else if(iOpen(symbol,tf,i) < iClose(symbol,tf,i)) signalFlag = 2;
               else
                 {
                  signalFlag = 0;
                  break;
                 }
              }
            else
              {
               if(signalFlag == 1)
                 {
                  if(iOpen(symbol,tf,i) > iClose(symbol,tf,i)) continue;
                  else
                    {
                     signalFlag = 0;
                     break;
                    }
                 }
               else if(signalFlag == 2)
                 {
                  if(iOpen(symbol,tf,i) < iClose(symbol,tf,i)) continue;
                  else
                    {
                     signalFlag = 0;
                     break;
                    }
                 }
              }
           }

         if(signalFlag > 0 && UseStohFiltr)
           {
            int calculated = BarsCalculated(StohHandle);
            if(calculated < SignalCandels + 1)
              {
               Print("Стохастику мало свечей!!! Ошикба ",GetLastError());
               return;
              }

            double StohArray[];
            int size = SignalCandels + 1;
            ArrayResize(StohArray,size);
            CopyBuffer(StohHandle,MAIN_LINE,0,size,StohArray);
            ArraySetAsSeries(StohArray,true);

            bool isFiltr = false;

            for(int i = 1; i < ArraySize(StohArray); i++)
              {
               if(signalFlag == 1 && StohArray[i] <= 20)
                 {
                  isFiltr = true;
                  break;
                 }

               if(signalFlag == 2 && StohArray[i] >= 80)
                 {
                  isFiltr = true;
                  break;
                 }
              }

            if(!isFiltr) signalFlag = 0;
           }

         if(signalFlag > 0)
           {
            if(signalFlag == 1)
              {
               ulong positon = Open_Buy_Pos(symbol,inLot,Magic_num,NULL,Slipage);
               if(positon <= 0)
                 {
                  SYMBOLS[symb].t = 0;
                  continue;
                 }
               else
                 {
                  int stop = 0, take = 0;
                  SetStopLevels(symbol,tf,positon,1,3,stop,take);

                  if(!Position_SLTP(positon,stop,take))
                    {
                     SYMBOLS[symb].t = 0;
                     continue;
                    }
                 }
              }
            else if(signalFlag == 2)
              {
               ulong positon = Open_Sell_Pos(symbol,inLot,Magic_num,NULL,Slipage);
               if(positon <= 0)
                 {
                  SYMBOLS[symb].t = 0;
                  continue;
                 }
               else
                 {
                  int stop = 0, take = 0;
                  SetStopLevels(symbol,tf,positon,1,3,stop,take);

                  if(!Position_SLTP(positon,stop,take))
                    {
                     SYMBOLS[symb].t = 0;
                     continue;
                    }
                 }
              }
           }
        }
//---
      //}
     }
}
//        ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
//+------------------------------------------------------------------+
void SetStopLevels(string symbol, ENUM_TIMEFRAMES tf, ulong position, int start_index, int end_index, int &sl, int &tp)
{
   double entry = 0, exit = 0;
   ENUM_POSITION_TYPE type = 0;
   if(PositionSelectByTicket(position))
     {
      entry = PositionGetDouble(POSITION_PRICE_OPEN);
      type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
     }

   if(type == POSITION_TYPE_BUY)
     {
      exit = iLow(symbol,tf,iLowest(symbol,tf,MODE_LOW,end_index,start_index));
      sl = PriceDistance(entry,exit,symbol);
      sl += inFiltr;
     }
   else
     {
      exit = iHigh(symbol,tf,iHighest(symbol,tf,MODE_HIGH,end_index,start_index));
      sl = PriceDistance(entry,exit,symbol);
      sl += inFiltr;
     }

   exit = iOpen(symbol,tf,end_index);
   tp = PriceDistance(entry,exit,symbol);
}
//+------------------------------------------------------------------+
//Занесение в переменные имён торговых инсрументов
//В случае ошшибки в имя торгового инструмента присваивается
//пустая строка
void SetSymbols()
{
//ZeroMemory(SYMBOLS);
   for(int i = 0; i < ArraySize(SYMBOLS); i++)
     {
      SYMBOLS[i].symbol = "";
     }

   for(int i = 0; i < SymbolsTotal(false); i++)
     {
      if(symbol0 == SymbolName(i,false))
        {
         if(SymbolSelect(symbol0,true)) SYMBOLS[0].symbol = symbol0;
        }
     }

   for(int i = 0; i < SymbolsTotal(false); i++)
     {
      if(symbol1 == SymbolName(i,false))
        {
         if(SymbolSelect(symbol1,true)) SYMBOLS[1].symbol = symbol1;
        }
     }

   for(int i = 0; i < SymbolsTotal(false); i++)
     {
      if(symbol2 == SymbolName(i,false))
        {
         if(SymbolSelect(symbol2,true)) SYMBOLS[2].symbol = symbol2;
        }
     }

   /*bool isCustom;
   if(SymbolExist(symbol0,isCustom))
   {
      if(SymbolSelect(symbol0,true)) SYMBOLS[0].symbol = symbol0;
   }*/

   if(CountSymbols() == 0) return;

   for(int i = 0; i < ArraySize(SYMBOLS); i++)
     {
      if(SYMBOLS[i].symbol == "") continue;
      for(int z = i + 1; z < ArraySize(SYMBOLS); z++)
        {
         if(SYMBOLS[i].symbol == SYMBOLS[z].symbol) SYMBOLS[z].symbol = "";
        }
     }

   SetSymbolSettings();
}

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//Организация остальных настроек символов,
//в зависимости от наличия торгового инструмента
void SetSymbolSettings()
{
   if(SYMBOLS[0].symbol != "")
     {
      SYMBOLS[0].SignalCandels = SignalCandels0;
      SYMBOLS[0].inLot = inLot0;
      SYMBOLS[0].OutComission = OutComission0;
      SYMBOLS[0].TargetProfit = TargetProfit0;
      SYMBOLS[0].t = 0;
      SYMBOLS[0].UseStohFiltr = UseStohFiltr0;
      SYMBOLS[0].tf = tf0;
     }

   if(SYMBOLS[1].symbol != "")
     {
      SYMBOLS[1].SignalCandels = SignalCandels1;
      SYMBOLS[1].inLot = inLot1;
      SYMBOLS[1].OutComission = OutComission1;
      SYMBOLS[1].TargetProfit = TargetProfit1;
      SYMBOLS[1].t = 0;
      SYMBOLS[1].UseStohFiltr = UseStohFiltr1;
      SYMBOLS[1].tf = tf1;
     }

   if(SYMBOLS[2].symbol != "")
     {
      SYMBOLS[2].SignalCandels = SignalCandels2;
      SYMBOLS[2].inLot = inLot2;
      SYMBOLS[2].OutComission = OutComission2;
      SYMBOLS[2].TargetProfit = TargetProfit2;
      SYMBOLS[2].t = 0;
      SYMBOLS[2].UseStohFiltr = UseStohFiltr2;
      SYMBOLS[2].tf = tf2;
     }

   SetHandls();
}

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//Хеширование индикатора. И варианты на случай неудачи
void SetHandls()
{
   for(int i = 0; i < ArraySize(SYMBOLS); i++)
     {
      if(SYMBOLS[i].symbol != "" && SYMBOLS[i].UseStohFiltr == true)
        {
         SYMBOLS[i].handle = iStochastic(SYMBOLS[i].symbol,SYMBOLS[i].tf,5,3,3,MODE_SMA,STO_CLOSECLOSE);
         if(SYMBOLS[i].handle == INVALID_HANDLE)
           {
            Print("Ошибка формирования хендла Стохастика по символу ",SYMBOLS[i].symbol,". Символ не участвует в тестировании.");
            SYMBOLS[i].symbol = "";
           }
         /*{
            Print("Ошибка формирования хендла Стохастика по символу ",SYMBOLS[i].symbol,". Индикаторный фильтр отключен.");
            SYMBOLS[i].handle = false;
         }*/
         /*{
            Print("Ошибка формирования хендла Стохастика по символу ",SYMBOLS[i].symbol,". Тест прерван!");
            for(int z = 0;z < ArraySize(SYMBOLS);z++)
            {
               SYMBOLS[z].symbol = "";
            }
            return;
         }*/
        }
     }
}

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//Подсчет кол-ва задействованных символов
int CountSymbols()
{
   int count = 0;

   for(int i = 0; i < ArraySize(SYMBOLS); i++)
     {
      if(SYMBOLS[i].symbol != "") count++;
     }

   return count;
}
//+------------------------------------------------------------------+
