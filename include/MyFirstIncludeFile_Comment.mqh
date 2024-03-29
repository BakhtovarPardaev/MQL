//+------------------------------------------------------------------+
//|                                           MyFirstIncludeFile.mqh |
//|                                                  dilettantcorner |
//|                                        dilettantcorner@gmail.com |
//+------------------------------------------------------------------+
#property copyright "dilettantcorner"
#property link      "dilettantcorner@gmail.com"

//Открытие позиции на Бай, или установка отложенного ордера на Бай
//Если параметр open_price = 0 - открывается позиция, если больше нуля - устанавливается
//отложенный ордер. Тип ордера зависит от положения точки open_price относительно текущей цены Аск
//symbol - имя торгового инструмента , lot - объем входа , уровень установки отложенного ордера
//stop_loss - величина стоп-приказа типа Стоп Лосс в пунктах. Не используется при открытии позиции и при значении 0(нуль)
//take_profit - величина стоп-приказа типа Тейк Профит в пунктах. Не используется при открытии позиции и при значении 0(нуль)
//magic - идентификатор торгового робота , comment - комментарий , slipage - допустимое отклонение от запраиваемой цены
/*long Open_Buy_Pos(string symbol,double lot, double open_price, uint stop_loss, uint take_profit, uint magic, string comment, int slipage)
{
   //Создание структур запроса и ответа для торгового сервера
   MqlTradeRequest reqwest;
   MqlTradeResult result;
   
   //Предварительное обнуление всех полей структур запроса и ответа
   ZeroMemory(reqwest);
   ZeroMemory(result);
   
   //Заполнение структуры запроса
   reqwest.symbol = symbol;
   
   //Сохраняем последнюю известную цену Аск для тороговых операций
   double current_ask = SymbolInfoDouble(reqwest.symbol,SYMBOL_ASK);
   
   //Открытие позиции
   if (open_price <= 0) 
   {
      //Поле запроса, отвечающее за тип операции
      reqwest.action = TRADE_ACTION_DEAL;
      
      //Поле запроса, отвечающее направление операции
      reqwest.type = ORDER_TYPE_BUY;
      
      //Поле запроса, по какой цене осуществляется вход
      reqwest.price = current_ask;
      
      //Поля СЛ и ТП. При открытии позиции не используются
      reqwest.sl = 0;
      reqwest.tp = 0;
   }
   else
   {
      //Установка отложенного ордера
      reqwest.action = TRADE_ACTION_PENDING;
      reqwest.price = open_price;
      
      //Служебное значение уровня Stop Level для проверки правильности установки стоп-приказов
      long stop_level = SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL);
      
      //Если стоп-приказ типа Стоп Лосс задействован
      if(stop_loss > 0)
      {
         //Проверка соответствия размера СЛ ограничению Stop Level
         if(stop_loss < stop_level) stop_loss = (uint)stop_level;
         
         //Установка уровня СЛ
         reqwest.sl = NormalizeDouble(reqwest.price - stop_loss * _Point,_Digits);
      }
      //Если стоп-приказ типа Тейк Профит задействован
      if(take_profit > 0)
      {
         //Проверка соответствия размера ТП ограничению Stop Level
         if(take_profit < stop_level) take_profit = (uint)stop_level;
         
         //Установка уровня ТП
         reqwest.tp = NormalizeDouble(reqwest.price + take_profit * _Point,_Digits);
      }
      //Указываем тип отложенного торгового приказа путем проверки
      //положения требуемой цены открытия относительно текущей цены Аск
      if (open_price > current_ask) reqwest.type = ORDER_TYPE_BUY_STOP;
      else reqwest.type = ORDER_TYPE_BUY_LIMIT;

   }
   //Установка объема будущей позиции или ордера
   reqwest.volume = lot;
   
   //Установка политики заполнения объема (на Forex используется только указанный)
   reqwest.type_filling = ORDER_FILLING_FOK;
   
   //Поле комментария. Если востребовано
   if(comment != NULL && comment != "") reqwest.comment = comment;
   
   //Поле идентификатора торгового эксперта. Если востребовано
   if(magic > 0) reqwest.magic = magic;
   
   //Поле возможного проскальзывания. Если востребовано
   if(slipage > 0) reqwest.deviation = slipage;
   
   //Отправка запроса на сервер. При неудаче повторям запрос при помощи цикла
   for(int i = 0;i < 10;i++)
   {
      //Функция отправки торгового запроса. Отправляется ранее
      //заполненная структура запроса и пустой "бланк" ответа для торгового сервера
      if(!OrderSend(reqwest,result))
      {
         //Если запрос отклонен - вывод в журнал сообщения об ошибке.
         //Идентификатор ошибки возвращает в виде заполненной структуры ответа торговго сервера.
         //в поле result.retcode
         Print("Позиция или ордер Селл не открыт. Ошибка №",result.retcode);
         
         //Время в милисекундах перед следующей попыткой
         Sleep(500);
      }
      else
      {
         //Если запрос исполнен торговым сервером анализируем структуру его ответа
         //Извлекаем из ответа сервера уникальный идентификатор сделки
         ulong deal_ticket = result.deal;
         
         //Если сделка не состоялась, но выставлен отложенный ордер идентификатор сделки
         //будет равен нулю. В этом случае выходим из цикла
         if(deal_ticket == 0) break;
         
         if(deal_ticket > 0)
         {
            //Если сделка состоялась 
            if(HistoryDealSelect(deal_ticket))
            {
               //Считываем уникальный идентификатор позиции, частью которой является сделка
               long pos_ticket = HistoryDealGetInteger(deal_ticket,DEAL_POSITION_ID);
               
               //И возвращаем во внешнюю функцию уникальный идентификатор позиции
               return pos_ticket;
            }
         }
      }
   }
   
   //Если по результатам работы функции сделка не открыта, во внешнюю функцию возвращается
   //значение 0, которое считается бесполезным
   return 0;
}*/
//+------------------------------------------------------------------+
//Разделяем механизмы отправки отложенных ордеров и открытия позиций
//В новом варианте функции открытия позиции нет пформальных параметров под цены открытия, стопа и тейка
long Open_Buy_Pos(string symbol,double lot, uint magic, string comment, int slipage)
{
   MqlTradeRequest reqwest;
   MqlTradeResult result;
   
   ZeroMemory(reqwest);
   ZeroMemory(result);
   
   //Поля торгового запроса, обязательные для открытия позиций
   //при всех режимах исполнения сделок
   reqwest.action = TRADE_ACTION_DEAL;
   reqwest.symbol = symbol;
   reqwest.type = ORDER_TYPE_BUY;
   reqwest.volume = lot;
   reqwest.type_filling = ORDER_FILLING_FOK;
   
   //Поля торгового запроса, обязательные в режимах исполнения сделок
   //Instant и Request. Можно не трогать в других режимах исполнения сделок
   //if(SymbolInfoInteger(reqwest.symbol,SYMBOL_TRADE_EXEMODE) == SYMBOL_TRADE_EXECUTION_INSTANT ||
   //   SymbolInfoInteger(reqwest.symbol,SYMBOL_TRADE_EXEMODE) == SYMBOL_TRADE_EXECUTION_REQUEST)
   //{
      double current_ask = SymbolInfoDouble(reqwest.symbol,SYMBOL_ASK);
      reqwest.price = current_ask;
      reqwest.sl = 0;
      reqwest.tp = 0;
      reqwest.deviation = slipage;
   //}
   
   //Не обязательные поля запроса
   if(comment != NULL && comment != "") reqwest.comment = comment;
   if(magic > 0) reqwest.magic = magic;
   
   
   for(int i = 0;i < 10;i++)
   {
      if(!OrderSend(reqwest,result))
      {
         Print("Позиция Бай не открыта. Ошибка №",result.retcode);
         Sleep(500);
      }
      else
      {
         ulong deal_ticket = result.deal;
         
         if(deal_ticket == 0) break;
         
         if(deal_ticket > 0)
         { 
            if(HistoryDealSelect(deal_ticket))
            {
               long pos_ticket = HistoryDealGetInteger(deal_ticket,DEAL_POSITION_ID);
               
               return pos_ticket;
            }
         }
      }
   }
   
   return 0;
}
//+------------------------------------------------------------------+
long Set_Buy_Order(string symbol,
                   double lot, 
                   double open_price, 
                   int stop_loss, 
                   int take_profit, 
                   datetime expiration_time, 
                   uint magic, 
                   string comment)
{
   MqlTradeRequest reqwest;
   MqlTradeResult result;
   
   ZeroMemory(reqwest);
   ZeroMemory(result);
   
   reqwest.action = TRADE_ACTION_PENDING;
   reqwest.symbol = symbol;
   reqwest.volume = lot;
   reqwest.type_filling = ORDER_FILLING_RETURN;
   
   int digits = (int)SymbolInfoInteger(reqwest.symbol,SYMBOL_DIGITS);
   reqwest.price = NormalizeDouble(open_price,digits);
   double current_ask = SymbolInfoDouble(reqwest.symbol,SYMBOL_ASK);
   if(reqwest.price > current_ask) reqwest.type = ORDER_TYPE_BUY_STOP;
   else reqwest.type = ORDER_TYPE_BUY_LIMIT;
   
   int stop_level = (int)SymbolInfoInteger(reqwest.symbol,SYMBOL_TRADE_STOPS_LEVEL);
   double point = SymbolInfoDouble(reqwest.symbol,SYMBOL_POINT);
   if(stop_loss > 0)
   {
      if(stop_loss < stop_level) stop_loss = stop_level;
      reqwest.sl = NormalizeDouble(reqwest.price - stop_loss * point,digits);
   }
   else reqwest.sl = 0;
   
   if(take_profit > 0)
   {
      if(take_profit < stop_level) take_profit = stop_level;
      reqwest.tp = NormalizeDouble(reqwest.price + take_profit * point,digits);
   }
   else reqwest.tp = 0;
   
   reqwest.type_time = ORDER_TIME_GTC;
   
   if(comment != NULL && comment != "") reqwest.comment = comment;
   if(magic > 0) reqwest.magic = magic;
   
   
   for(int i = 0;i < 10;i++)
   {
      if(!OrderSend(reqwest,result))
      {
         Print("Отложенный ордер Бай не установлен. Ошибка №",result.retcode);
         Sleep(500);
      }
      else
      {
         ulong order_ticket = result.order;
         
         if(order_ticket > 0) return (long)order_ticket;
      }
   }
   
   return 0;
}
//+------------------------------------------------------------------+
//Открытие позиции на Селл, или установка отложенного ордера на Селл
//Если параметр open_price = 0 - открывается позиция, если больше нуля - устанавливается
//отложенный ордер. Тип ордера зависит от положения точки open_price относительно текущей цены Бид
//symbol - имя торгового инструмента , lot - объем входа , уровень установки отложенного ордера
//stop_loss - величина стоп-приказа типа Стоп Лосс в пунктах. Не используется при открытии позиции и при значении 0(нуль)
//take_profit - величина стоп-приказа типа Тейк Профит в пунктах. Не используется при открытии позиции и при значении 0(нуль)
//magic - идентификатор торгового робота , comment - комментарий , slipage - допустимое отклонение от запраиваемой цены
/*long Open_Sell_Pos(string symbol,double lot, double open_price, uint stop_loss, uint take_profit, uint magic, string comment, int slipage)
{
   MqlTradeRequest reqwest;
   MqlTradeResult result;
   
   ZeroMemory(reqwest);
   ZeroMemory(result);
   
   reqwest.symbol = symbol;
   double current_bid = SymbolInfoDouble(reqwest.symbol,SYMBOL_BID);
   if (open_price <= 0) 
   {
      reqwest.action = TRADE_ACTION_DEAL;
      reqwest.type = ORDER_TYPE_SELL;
      reqwest.price = current_bid;
      reqwest.sl = 0;
      reqwest.tp = 0;
   }
   else
   {
      reqwest.action = TRADE_ACTION_PENDING;
      reqwest.price = open_price;
      long stop_level = SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL);
      if(stop_loss > 0)
      {
         if(stop_loss < stop_level) stop_loss = (uint)stop_level;
         reqwest.sl = NormalizeDouble(reqwest.price + stop_loss * _Point,_Digits);
      }
      if(take_profit > 0)
      {
         if(take_profit < stop_level) take_profit = (uint)stop_level;
         reqwest.tp = NormalizeDouble(reqwest.price - take_profit * _Point,_Digits);
      }
      if (open_price > current_bid) reqwest.type = ORDER_TYPE_SELL_LIMIT;
      else reqwest.type = ORDER_TYPE_SELL_STOP;


   }
   reqwest.volume = lot;
   reqwest.type_filling = ORDER_FILLING_FOK;
   if(comment != NULL && comment != "") reqwest.comment = comment;
   if(magic > 0) reqwest.magic = magic;
   if(slipage > 0) reqwest.deviation = slipage;
   
   for(int i = 0;i < 10;i++)
   {
      if(!OrderSend(reqwest,result))
      {
         Print("Позиция или ордер Селл не открыт. Ошибка №",result.retcode);
         Sleep(500);
      }
      else
      {
         ulong deal_ticket = result.deal;
         if(deal_ticket == 0) break;
         if(deal_ticket > 0)
         {
            if(HistoryDealSelect(deal_ticket))
            {
               long pos_ticket = HistoryDealGetInteger(deal_ticket,DEAL_POSITION_ID);
               return pos_ticket;
            }
         }
      }
   }
   
   return -1;
}*/
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
long Open_Sell_Pos(string symbol,double lot, uint magic, string comment, int slipage)
{
   MqlTradeRequest reqwest;
   MqlTradeResult result;
   
   ZeroMemory(reqwest);
   ZeroMemory(result);
   
   reqwest.action = TRADE_ACTION_DEAL;
   reqwest.symbol = symbol;
   reqwest.type = ORDER_TYPE_SELL;
   reqwest.volume = lot;
   reqwest.type_filling = ORDER_FILLING_FOK;
   

   //if(SymbolInfoInteger(reqwest.symbol,SYMBOL_TRADE_EXEMODE) == SYMBOL_TRADE_EXECUTION_INSTANT ||
   //   SymbolInfoInteger(reqwest.symbol,SYMBOL_TRADE_EXEMODE) == SYMBOL_TRADE_EXECUTION_REQUEST)
   //{
      double current_bid = SymbolInfoDouble(reqwest.symbol,SYMBOL_BID);
      reqwest.price = current_bid;
      reqwest.sl = 0;
      reqwest.tp = 0;
      reqwest.deviation = slipage;
   //}
   
   if(comment != NULL && comment != "") reqwest.comment = comment;
   if(magic > 0) reqwest.magic = magic;
   
   
   for(int i = 0;i < 10;i++)
   {
      if(!OrderSend(reqwest,result))
      {
         Print("Позиция Селл не открыта. Ошибка №",result.retcode);
         Sleep(500);
      }
      else
      {
         ulong deal_ticket = result.deal;
         
         if(deal_ticket == 0) break;
         
         if(deal_ticket > 0)
         { 
            if(HistoryDealSelect(deal_ticket))
            {
               long pos_ticket = HistoryDealGetInteger(deal_ticket,DEAL_POSITION_ID);
               
               return pos_ticket;
            }
         }
      }
   }
   
   return 0;
}
//+------------------------------------------------------------------+
long Set_Sell_Order(string symbol,
                   double lot, 
                   double open_price, 
                   int stop_loss, 
                   int take_profit, 
                   datetime expiration_time, 
                   uint magic, 
                   string comment)
{
   MqlTradeRequest reqwest;
   MqlTradeResult result;
   
   ZeroMemory(reqwest);
   ZeroMemory(result);
   
   reqwest.action = TRADE_ACTION_PENDING;
   reqwest.symbol = symbol;
   reqwest.volume = lot;
   reqwest.type_filling = ORDER_FILLING_RETURN;
   
   int digits = (int)SymbolInfoInteger(reqwest.symbol,SYMBOL_DIGITS);
   reqwest.price = NormalizeDouble(open_price,digits);
   double current_bid = SymbolInfoDouble(reqwest.symbol,SYMBOL_BID);
   if(reqwest.price < current_bid) reqwest.type = ORDER_TYPE_SELL_STOP;
   else reqwest.type = ORDER_TYPE_SELL_LIMIT;
   
   int stop_level = (int)SymbolInfoInteger(reqwest.symbol,SYMBOL_TRADE_STOPS_LEVEL);
   double point = SymbolInfoDouble(reqwest.symbol,SYMBOL_POINT);
   if(stop_loss > 0)
   {
      if(stop_loss < stop_level) stop_loss = stop_level;
      reqwest.sl = NormalizeDouble(reqwest.price + stop_loss * point,digits);
   }
   else reqwest.sl = 0;
   
   if(take_profit > 0)
   {
      if(take_profit < stop_level) take_profit = stop_level;
      reqwest.tp = NormalizeDouble(reqwest.price - take_profit * point,digits);
   }
   else reqwest.tp = 0;
   
   reqwest.type_time = ORDER_TIME_GTC;
   
   if(comment != NULL && comment != "") reqwest.comment = comment;
   if(magic > 0) reqwest.magic = magic;
   
   
   for(int i = 0;i < 10;i++)
   {
      if(!OrderSend(reqwest,result))
      {
         Print("Отложенный ордер Селл не установлен. Ошибка №",result.retcode);
         Sleep(500);
      }
      else
      {
         ulong order_ticket = result.order;
         
         if(order_ticket > 0) return (long)order_ticket;
      }
   }
   
   return 0;
}
//+------------------------------------------------------------------+
//Модификация открытой позиции
//position - уникальный идентификатор требуемой позиции
//SL - новый размер стоп-приказа Стоп Лосс в пунктах. Если 0(нуль) - остается прежним
//TP - новый размер стоп-приказа Тейк Профит в пунктах. Если 0(нуль) - остается прежним
bool Position_SLTP(ulong position,int SL,int TP)
{
   //Проверка на наличие открытой позиции с указанным идентификатором
   if(PositionSelectByTicket(position))
   {
      //Считываем необходимые свойства позиции
      double pos_op = PositionGetDouble(POSITION_PRICE_OPEN);
      string pos_symb = PositionGetString(POSITION_SYMBOL);
      ulong pos_mag = PositionGetInteger(POSITION_MAGIC);
      
      //Считываем напрвление позиции
      //Все типы позиций объявлены в терминале в виде перечисления ENUM_POSITION_TYPE
      //Если это значение присваивается отдельной переменной, его обязательно нужно привести к типу перечисления ENUM_POSITION_TYPE
      ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      
      //Считываем свойства торгового инструмента для дальнейих вычислений и проверок ограничения Frezze Level
      int symb_digits = (int)SymbolInfoInteger(pos_symb,SYMBOL_DIGITS);
      double symb_point = SymbolInfoDouble(pos_symb,SYMBOL_POINT);
      int freez_level = (int)SymbolInfoInteger(pos_symb,SYMBOL_TRADE_FREEZE_LEVEL);
      
      MqlTradeRequest reqwest;
      MqlTradeResult result;
   
      ZeroMemory(reqwest);
      ZeroMemory(result);
      
      if(pos_type == POSITION_TYPE_BUY)
      {
         if(SL > 0) 
         {
            //Если уровень Стоп Лосс подлежит изменению - новая его величина в пунктах не должна быть меньше ограничения Frezze Level
            if(SL < freez_level) SL = freez_level;
            
            reqwest.sl = NormalizeDouble(pos_op - SL * symb_point,symb_digits);
         }
         if(TP > 0)
         {
            //Если уровень Тейк Профит подлежит изменению - новая его величина в пунктах не должна быть меньше ограничения Frezze Level
            if(TP < freez_level) TP = freez_level;
            
            reqwest.tp = NormalizeDouble(pos_op + TP * symb_point,symb_digits);
         }
      }
      else
      {
         if(SL > 0)
         {
            if(SL < freez_level) SL = freez_level;
            reqwest.sl = NormalizeDouble(pos_op + SL * symb_point,symb_digits);
         }
         if(TP > 0)
         {
            if(TP < freez_level) TP = freez_level;
            reqwest.tp = NormalizeDouble(pos_op - TP * symb_point,symb_digits);
         }
      }
      //Необходимые данные для модификации позиции
      reqwest.position = position;
      reqwest.magic = pos_mag;
      reqwest.symbol = pos_symb;
      
      //Не забудьте указать требуемую операцию)
      reqwest.action = TRADE_ACTION_SLTP;
      
      //Отправка запроса на сервер. При неудаче повторям запрос при помощи цикла    
      for(int i = 0;i < 10;i++)
      {
         if(!OrderSend(reqwest,result))
         {
            Print("Позиция №",position," не была модифицирована. Ошибка№",result.retcode);
            Sleep(500);
         }
         //Если модификация позиции состоялась
         //функция возвращает Тру и завершает свою работу
         else return true;
      }
   }
   else Print("Позиция №",position," не найдена.");
   
   //Если результат выполнения функции не приводит к модификации позиции
   //функция возвращает Фэлс.
   return false;
}
//+------------------------------------------------------------------+
//Функция для подсчета кол-ва позиций робота на конкретном торговом инструменте
//Переменная magic отвечает за идентификацию позиции, как открытой этим роботом
//Переменная symbol указывает инструмент, на котором производится поиск позиций робота
int CountPositions(int magic , string symbol)
{
   //Переменная-счетчик позиций. Изначально считаем, что позиций нашего робота нет
   int count = 0;                                                          
   
   //Перебираем все имеющиеся на торговом счете позиции
   for(int i = 0;i < PositionsTotal();i++)
   {
      //Вытаскиваем тикет позиции с индексом i и сохраняем его
      //в переменной pos
      ulong pos = PositionGetTicket(i);
      
      //Если позиция с таким тикетом есть и её данные загружены в память
      if(PositionSelectByTicket(pos))
      {
         //Соответствующими функциями считываем нужные свойства позиции
         //и сохраняем их значения соответствующие переменные
         ulong pos_mag = PositionGetInteger(POSITION_MAGIC);
         string pos_symb = PositionGetString(POSITION_SYMBOL);
         
         //Если свойства позиции совпадают с контрольными значениями
         //увеличиваем значение переменной-счетчика на один
         if(pos_mag == magic && pos_symb == symbol) count++;
      }
   }
   
   //Функция позвращает итоговый результат в виде
   //итогового значения переменной-счетчика
   return count;
}
//+------------------------------------------------------------------+
//Перечисления для возможных вариантов направления искомой позиции
//Можно использовать в самых разных функциях, где подобное уместно
//Главное - оъявить перечисления ДО оъявления нужных функций
/*enum Direction {
                  direction_buy, 
                  direction_sell 
               };*/
//+------------------------------------------------------------------+
//Вариант перегрузки функции CountPositions с учетом
//направления искомых позиций
//За направление отвечает переменная direction
//которая имеет тип перечисления Direction, оъявленного шагом ранее
int CountPositions(int magic , string symbol , bool direction_is_buy)
{
   int count = 0;
   
   
   //Отдельная переменная для контроля направления позиции
   //При присвоении значения переменной type явное приведение типов оязательно
   //во избежание ошибок
   ENUM_POSITION_TYPE type;
   if(direction_is_buy) type = (ENUM_POSITION_TYPE)POSITION_TYPE_BUY;
   else type = (ENUM_POSITION_TYPE)POSITION_TYPE_SELL;
   
   for(int i = 0;i < PositionsTotal();i++)
   {
      ulong pos = PositionGetTicket(i);
      if(PositionSelectByTicket(pos))
      {
         ulong pos_mag = PositionGetInteger(POSITION_MAGIC);
         string pos_symb = PositionGetString(POSITION_SYMBOL);
         
         //Считываем направление выбранной позиции. Тоже с явным приведением типов
         ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         
         if(pos_mag == magic && pos_symb == symbol && pos_type == type) count++;
      }
   }
   
   return count;
}
//+------------------------------------------------------------------+
//Вариант перегрузки функции CountPositions без учета торгового инструмента
//Считает все позиции, открытые указанным роботом на тоговом счете
//Дабы не делать лишней работы, просто закомментированы неиспользуемые элементы
int CountPositions(int magic /*, string symbol*/)
{
   int count = 0;
   
   for(int i = 0;i < PositionsTotal();i++)
   {
      ulong pos = PositionGetTicket(i);
      if(PositionSelectByTicket(pos))
      {
         ulong pos_mag = PositionGetInteger(POSITION_MAGIC);
         //string pos_symb = PositionGetString(POSITION_SYMBOL);
         
         if(pos_mag == magic /*&& pos_symb == symbol*/) count++;
      }
   }
   
   return count;
}
//+------------------------------------------------------------------+
//Вариант перегрузки функции CountPositions без учета принадлежности к роботам
//Считает все позиции, открытые на указанном тоговом инструменте
//Дабы не делать лишней работы, просто закомментированы неиспользуемые элементы
int CountPositions(/*int magic ,*/ string symbol)
{
   int count = 0;
   
   for(int i = 0;i < PositionsTotal();i++)
   {
      ulong pos = PositionGetTicket(i);
      if(PositionSelectByTicket(pos))
      {
         //ulong pos_mag = PositionGetInteger(POSITION_MAGIC);
         string pos_symb = PositionGetString(POSITION_SYMBOL);
         
         if(/*pos_mag == magic &&*/ pos_symb == symbol) count++;
      }
   }
   
   return count;
}
//+------------------------------------------------------------------+
//Функция возвращает расстояние в пунктах между ценовыми уровнями priceA и priceB
//Параметр symbol соощает имя торгового инструмента, по ценам которого осуществляется рассчет
int PriceDistance(double priceA , double priceB , string symbol)
{
   return (int)(MathAbs(priceA - priceB) / SymbolInfoDouble(symbol,SYMBOL_POINT));
}
//+------------------------------------------------------------------+
//Функция считает приыль по открытой позиции

//Параметр position отвечает за тикет позиции, приыль которой считаем

//Параметр out_comission задает комиссию за один стандартный лот сдлеки. Служит для корректного подсчета комисси при закрытии позиции
//если равен нулю - или комиссии нет, или она не взымается с закрывающих сделок

//Параметр subtotals отвечает за подсчет изменения баланса торгового счета, с учетом изменений, происходивших с позицией. При значении
//TRUE считаем, при значении FALSE - не считаем
double Profit(ulong position, double out_comission, bool subtotals)
{
   //Переменная под общее значение прибыли позиции
   double total_profit = 0;
   
   //Переменные под значения прибыли, свопа и комиссии для позиции в рынке
   double profit = 0, swap = 0, comission = 0;
   
   //Переменная под объем рыночной позиции. Нужна для корректного подсчета комиссии при закрытии позиции
   double volume = 0;
   
   //Считываем нужные свойства позиции иприсваиваем их значения соответствующим переменным
   if(PositionSelectByTicket(position))
   {
      profit = PositionGetDouble(POSITION_PROFIT);
      swap = PositionGetDouble(POSITION_SWAP);
      volume = PositionGetDouble(POSITION_VOLUME);
   }
   
   //Проходимся по всем сделкам, которые как-то влияли на позицию
   //В том числе, считаем комисси по этим сделкам
   //Соответствующие значения увеличиваем нарастающим итогом
   if(HistorySelectByPosition(position))
   {
      for(int i = 0;i < HistoryDealsTotal();i++)
      {
         ulong deal = HistoryDealGetTicket(i);
         
         //Если промежуточные итоги работы комиссии на неттинговом счете нужны,
         //соответствующие переменные участвуют в расчетах
         if(subtotals)
         {
            profit += HistoryDealGetDouble(deal,DEAL_PROFIT);
            swap += HistoryDealGetDouble(deal,DEAL_SWAP);
         }
         comission += HistoryDealGetDouble(deal,DEAL_COMMISSION);
      }
   }
   
   //Окончательный подсчет прибыли
   total_profit = (profit + swap + comission) - out_comission * volume;
   
   return NormalizeDouble(total_profit,2);
}
//+---------------------------------------------------------------+
//Функция закытия позиции с рынка
//position указывает на позицию, которую требуется закрыть
//slipage допустимое проскальзывание от текущей рыночной котировки в пунктах
bool Close_Position(ulong position, int slipage)
{
   //Проверка на наличие указанной позиции на торговом счете
   if(PositionSelectByTicket(position))                                                      
   {
      //Получам нужные далее значения свойств закрываемой позиции
      string pos_symb = PositionGetString(POSITION_SYMBOL);                                  //Имя торгового инструмента, на котором открыта позиция
      ulong pos_mag = PositionGetInteger(POSITION_MAGIC);                                    //Идентификатор робота, открывшего позицию
      double pos_volume = PositionGetDouble(POSITION_VOLUME);                                //Объем позиции
      
      ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);   //Направление позиции
      
      //Формируем торговый приказ
      MqlTradeRequest reqwest;
      MqlTradeResult result;
   
      ZeroMemory(reqwest);
      ZeroMemory(result);
      
      if(pos_type == POSITION_TYPE_BUY)                              //Если закрываеая позиция на Покупку
      {
         reqwest.price = SymbolInfoDouble(pos_symb,SYMBOL_BID);      //Она должа закрываться по цене Бид
         reqwest.type = ORDER_TYPE_SELL;                             //Операциией, противоположной направлению открытой позиции
      }
      else
      {
         reqwest.price = SymbolInfoDouble(pos_symb,SYMBOL_ASK);
         reqwest.type = ORDER_TYPE_BUY;
      }
      
      //Поля, обязательные для операции закрытия позиции, не зависящи от её напрвления
      reqwest.position = position;
      reqwest.magic = pos_mag;
      reqwest.symbol = pos_symb;
      reqwest.volume = pos_volume;
      reqwest.deviation = slipage;
      reqwest.action = TRADE_ACTION_DEAL;
      
      //Отправка торгового запроса на сервер с контролем результата   
      for(int i = 0;i < 10;i++)
      {
         if(!OrderSend(reqwest,result))
         {
            Print("Позиция №",position," не была закрыта. Ошибка№",result.retcode);
            Sleep(500);
         }
         else return true;
      }
   }
   else Print("Позиция №",position," не найдена.");
   
   return false;
}
//+------------------------------------------------------------------+
//Функция для сбора тикетов позиций, отфильтрованных по Мэджику и Символу
//в отдельный массив PosArray. Массив получаем по ссылке
void GetPositionsTickets(int magic , string symbol , ulong &PosArray[])
{
   //переменная для хранения текущего индекса в массиве
   int index = 0;
   
   //перебираем позиции по одной для фильтрации нужных
   for(int i = 0;i < PositionsTotal();i++)
   {
      //сохраняем тикет очередной позиции
      ulong pos = PositionGetTicket(i);
      //кешируем свойства позиции
      if(PositionSelectByTicket(pos))
      {
         ulong pos_mag = PositionGetInteger(POSITION_MAGIC);
         string pos_symb = PositionGetString(POSITION_SYMBOL);
         
         //если нужные свойства позиции удовлетворяют критериям отбора
         if(pos_mag == magic && pos_symb == symbol)
         {
            //сохраняем тикет позиции в указанный элемент массива
            PosArray[index] = pos;
            //переходим к следующему элементу в массиве
            index++;
            //если индексы в массиве закончились - прерываем дальнейший перебор позиций
            //это значит, что все нужные позиции уже найдены
            if(index >= ArraySize(PosArray)) break;
         }
      }
   }
}
//+------------------------------------------------------------------+
//Функция нормализации объема входа в рынок
//в соответствии с ограничениями брокера
//volume - планируемый объем (Лот)
//symbol - имя торгового инструмента, по которому планируется вход в рынок
double LotNormalize(double volume, string symbol)
{
   //сохраняем минимально возможный лот
   double lotMin = SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);
   //сохраняем максимально возможный лот
   double lotMax = SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX);
   //сохраняем минимальный шаг изменения лота
   double lotStep = SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP);
   
   //если требуемый лот меньше минимально допустимого - устанавливаем минимально допустимый
   if(volume < lotMin) return NormalizeDouble(lotMin,2);
   //если требуемый лот больше максимально допустимого - устанавливаем максимально допустимый
   else if(volume > lotMax) return NormalizeDouble(lotMax,2);
   //если ни то, ни другое
   else
   {
      //смотрим, сколько полных раз поместится минимально допустимый шаг изменения лота в требуемом
      //остаток отбрасываем
      int i_volume = (int)(volume / lotStep);
      //вычисляем новый лот в соответсвии с минимально допустимым шагом его изменения
      volume = i_volume * lotStep;
   }
   
   //возвращаем полученный результат
   return NormalizeDouble(volume,2);
}
//+------------------------------------------------------------------+
//Функция расчета объема сделки, в зависимости от суммы максимально допустимого убытка по одной сделке
//Убыток указывается в % от суммы, которую задает сам пользователь перед вызовом функции
//Переменная symbol указывает имя торгового инструмента для расчетов
//Переменная type отвечает за направление сделки. Внимание!!! допустимы только значения type = ORDER_TYPE_BUY или type = ORDER_TYPE_SELL
//Переменные entry и exit указывают на предполагаемые уровни входа и выхода из позиции
//Переменная Foundation говорит функции, от какой суммы будет расчитан максимально допустимый убыток
//Переменная risk сообщает функции, каким % от значения Foundation будем рисковать
double LotSize(string symbol, ENUM_ORDER_TYPE type, double entry, double exit, double Foundation, double risk)
{
   //Сохраняем максимально и минимально возможные объемы входа, установленные брокером
   double lotMin = SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);
   double lotMax = SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX);
   //И минимальный шаг изменения объема, также заданный брокером
   double lotStep = SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP);
   
   //Сначала проверяем, проходит ли минимально возможный объем сделки в допустимую сумму рисков
   double lot = lotMin;
   
   //Рассчитывааем риск в валюте депозита
   double currencyRisk = (Foundation / 100) * risk;
   //обязательно округляем в меньшую сторону
   currencyRisk = floor(currencyRisk * 100) / 100;
   //И показываем пользователю в журнале
   Print("Risk in money = ",currencyRisk);
   
   //Служебная переменная для хранения промежутчных результатов потенциальной прибыли в сделке
   double profit = 0;
   
   //Рассчитываем прибыль по сделке с минимально допустимым значением объема
   //при помощи функции из базовой реализации MQL5
   //Функция сохраняет расчетный результат следки в переменной profit
   //Переменная exit дрлжна соответсвовать будущему значению стоп-лосс
   if(OrderCalcProfit(type,symbol,lot,entry,exit,profit))
   {
      //Если потенциалный убыток не превышает ранее полученной значение рисков в валюте депозита
      if(MathAbs(profit) <= currencyRisk)
      {
         //Сохраняем значение убытка в беззнаковом виде
         profit = MathAbs(profit);
         //Смотрим сколько полных минимально допустимых объемов сделки умещается в полученном значении 
         lot = (currencyRisk / profit) * lotMin;
         //Округляем результат до ближайшего целого снизу и считаем,
         //сколько раз в нужную сумму влазит минимально допустимый шаг изменения объема
         lot = floor(lot / lotStep) * lotStep;
         //Если превысили максимально возможное значение объема - корректируем результат
         if(lot > lotMax) lot = lotMax;
      }
      else
      {
         //Если при мениально допустимом объеме превысили допустимый риск в деньгах
         //Сообщаем об этом в журнал
         Print("Риски превышают максимально доступное значение");
         //И прекращаем дальнейшие расчеты, вернув из функцции нулевое значение объема
         //(брокер не пропустит)
         return 0;
      }
   }
   
   //Проверяем, не превышает ли потенциальный убыток с новым значением объема максимально допустимый риск на сделку
   //Для этого последовательно, начиная с полученного ранее значения объема, вызываем функцию OrderCalcProfit
   //с новым значением объема сделки. Если результат превышает допустимый - уменьшаем объем на один шаг.
   for(double i = lot;i >= lotMin;i -= lotStep)
   {
      //Функция OrderCalcProfit вызывается уже с новым значением объема
      if(OrderCalcProfit(type,symbol,lot,entry,exit,profit))
      {
         //Если риски в норме
         if(MathAbs(profit) <= currencyRisk)
         {
            //сохраняем полученное значение объема
            lot = i;
            //и прекращаем перебор
            break;
         }
      }
   }
   
   //Возвращаем из функции нормальзованное значение объема будущей сделки
   return NormalizeDouble(lot,2);
}
//+------------------------------------------------------------------+
//Функция нормализации котировки для брокеров, у которых минимальный шаг изменения котировки
//отличается от минимального пункта этой котировки. Проверка на несоответсвие осуществляется ДО вызова функции
//Переменная value - исходное значение котировки
//Переменная symbol - имя торгового инструмента
double QoutNormalize(double value, string symbol)
{
   //Сохраняем значения минимального пункта котировки нужного торг. инструмента
   double point = SymbolInfoDouble(symbol,SYMBOL_POINT);
   //Сохраняем значение мин. шага изменения этой котировки
   double tick_size = SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_SIZE);
   //Сохраняем значение точности котировки в её десятичной части
   int digits = (int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);
   
   //Приводим значение искомой котировки к виду целого числа.
   //При котировке 1.005 и значении point = 0.001 получаем 1005
   int iValue = (int)(value / point);
   //Приводим значение минимально возможного шага изменения котировки к целому числу
   //При tick_size = 0.002 и point = 0.001 получаем 2
   int step = (int)(tick_size / point);
   
   //Далее функция смотрит, сколько чисел в правой части котировки неоходимо корректировать
   //Это необходимо для правильной остановки выполнения функции и "отсечения" от значения iValue
   //нужного количества порядков справа
   
   //Переменная для "отсечения" порядков справа
   int max_step;
   //Если минимальный шаг изменения цены котировки меньше 10, значит нужно работать только с
   //самым крайним порядком значения iValue
   if(step < 10) max_step = 10;
   //Если минимальный шаг изменения цены котировки больше 10, но при этом меньше 100,
   //значит нужно работать уже с двумя крайними порядками значения iValue
   else if(step >= 10 && step < 100) max_step = 100;
   //и т.д. до пяти порядков значения iValue
   //Что соответсвует значению point = 0.00001
   //Или точности котировки в пять знаков
   else if(step >= 100 && step < 1000) max_step = 1000;
   else if(step >= 1000 && step < 10000) max_step = 10000;
   else max_step = 100000;
   
   //"Отсекаем" нужное кол-во чисел справа от значения iValue
   //и сохраняем эти числа в отдельную переменную
   int lost_value = iValue % max_step;
   
   //Если lost_value делится без остатка на значение step
   //Значит, переданная в функцию котировка корректна и далее можно ничего не делать
   if(lost_value % step == 0)
   {
      //Возвращаем изначальную котировку, приведя её к виду вещественного числа
      //(для безопасности при считывании вещественных чисел из памяти)
      return (NormalizeDouble(iValue * point,digits));
   }
   
   //Если нужны дальнейшие преоразования...
   
   //Усекаем значение iValue на нужное кол-во порядков справа
   iValue /= max_step;
   
   //Ищем ближайшее корректное значение к переданной в функцию котировке
   //с учетом минимального шага изменения котировки. В виде целых чисел.
   //Оперируем не всей котировкой, а только той её частью, котрая подлежит нормализации
   
   //При старте цикла, переменная i является минимально возможным значением котировки в крайнем правом порядке
   for(int i = step;i < max_step;i += step)
   {
      //Если "отсеченное" правое значение котировки меньше значения i, значит ближайшее корректное значение
      //крайнего правого порядка котировки равно i. Если нет - идем дальше
      if(lost_value < i)
      {
         //Присваиваем это значение в lost_value и прерываем цикл
         lost_value = i;
         break;
      }
      //Если следуюий шаг изменения котировки справа приводит к увеличению на 1 порядка слева от "отсеченной" части котировки
      else if(i + step >= max_step)
      {
         //Увеличиваем на 1 "усеченную" котировку
         iValue++;
         //"Отсеченное" выставляем в нуль. Т.к. увеличился порядок слева
         lost_value = 0;
         //И выходим из цикла
         break;
      }
   }
   
   //Возвращаем котировке вид вещественного числа
   //Возвращаем "усеченной" котировке ровно то кол-во знаков справа, которое "отсекли" от него ранее
   //И прибавляем полученное на предыдущем этапе число, которое должно быть в правом порядке
   iValue = iValue * max_step + lost_value;
   //И превращаем целое число в котировку
   value = iValue * point;
   
   //Возвращаем из функции полученное значение value
   return NormalizeDouble(value,digits);
   
   /* З.Ы.
   Увы, но я не математик. И прекрасно понимаю, что описание функции получилось безграмотным. Но по другому сформулировать не смог.
   Если у вас есть идеи, как оформить комментарии к этой функции грамотно - напишите, пожалуйста, где-нибудь на канале в комментах,
   или в группе в Телеге. Все ссылки есть на канале под каждым видео и в описании канала.
   Заранее спасибо! */
}