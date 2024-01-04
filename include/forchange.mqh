//+------------------------------------------------------------------+
//|                                                    forchange.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#include <Trade\Trade.mqh>

bool change_pos(ulong tick_pos, double new_sl, double new_tp)
{
  CTrade change;
  
  if(change.PositionModify(tick_pos, new_sl, new_tp)) 
  {
    Print("position has been changed");
    return true;
  }
  
    else 
  {
    Print("position has not changed");
    return false;
  }

}