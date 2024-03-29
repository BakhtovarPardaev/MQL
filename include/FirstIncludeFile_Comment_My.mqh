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
long Open_Buy_Pos(string symbol,double lot, double open_price, uint stop_loss, uint take_profit, uint magic, string comment, int slipage)
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
               
               //И возвращаем во внешнюю функцию уникальный идентификатор сделки
               return pos_ticket;
            }
         }
      }
   }
   
   //Если по результатам работы функции сделка не открыта, во внешнюю функцию возвращается
   //значение -1, которое считается бесполезным
   return -1;
}
//+------------------------------------------------------------------+
//Открытие позиции на Селл, или установка отложенного ордера на Селл
//Если параметр open_price = 0 - открывается позиция, если больше нуля - устанавливается
//отложенный ордер. Тип ордера зависит от положения точки open_price относительно текущей цены Бид
//symbol - имя торгового инструмента , lot - объем входа , уровень установки отложенного ордера
//stop_loss - величина стоп-приказа типа Стоп Лосс в пунктах. Не используется при открытии позиции и при значении 0(нуль)
//take_profit - величина стоп-приказа типа Тейк Профит в пунктах. Не используется при открытии позиции и при значении 0(нуль)
//magic - идентификатор торгового робота , comment - комментарий , slipage - допустимое отклонение от запраиваемой цены
long Open_Sell_Pos(string symbol,double lot, double open_price, uint stop_loss, uint take_profit, uint magic, string comment, int slipage)
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
enum Direction {
                  direction_buy, 
                  direction_sell 
               };
//+------------------------------------------------------------------+
//Вариант перегрузки функции CountPositions с учетом
//направления искомых позиций
//За направление отвечает переменная direction
//которая имеет тип перечисления Direction, оъявленного шагом ранее
int CountPositions(int magic , string symbol , Direction direction)
{
   int count = 0;
   
   
   //Отдельная переменная для контроля направления позиции
   //При присвоении значения переменной type явное приведение типов оязательно
   //во избежание ошибок
   ENUM_POSITION_TYPE type;
   if(direction == direction_buy) type = (ENUM_POSITION_TYPE)POSITION_TYPE_BUY;
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