--  2020-01-26 adbr

--  Filtr tekstowy do poprawiania kalendarza wygenerowanego przez
--  calgen:
--  - usuwa gwiazdki w nagłówkach dni będących poniedziałkiem,
--  - usuwa numer tygodnia dla dni nie będących poniedziałkiem
--
--  Zamienia:
--      *** 2019-01-07 Pon [w02] *
--      *** 2019-01-08 Wto [w02]
--      *** 2019-01-09 Śro [w02]
--      *** 2019-01-10 Czw [w02]
--      *** 2019-01-11 Pią [w02]
--      *** 2019-01-12 Sob [w02]
--      *** 2019-01-13 Nie [w02]
--  na:
--      *** 2019-01-07 Pon [w02]
--      *** 2019-01-08 Wto
--      *** 2019-01-09 Śro
--      *** 2019-01-10 Czw
--      *** 2019-01-11 Pią
--      *** 2019-01-12 Sob
--      *** 2019-01-13 Nie
--
--  Sposób użycia:
--  ./calfix < calendar-old.org > calendar-new.org

pragma Wide_Character_Encoding (UTF8);

with Ada.Wide_Text_IO;
use Ada.Wide_Text_IO;

with Ada.Strings.Wide_Fixed;
use Ada.Strings.Wide_Fixed;

procedure Calfix is

   function Is_Day_Line (Line : Wide_String) return Boolean;
   --  Funkcja sprawdza czy string Line jest nagłówkiem dnia - czyli,
   --  czy zaczyna się sekwencją "*** ".

   function Fix_Day_Line (Line : Wide_String) return Wide_String;
   --  Funkcja zmienia wiersz kalendarza w następujący sposób:
   --  "*** 2020-02-10 Pon [w07] *" -> "*** 2020-02-10 Pon [w07]"
   --  "*** 2020-02-11 Wto [w07]"   -> "*** 2020-02-11 Wto"
   --   12345678901234567890123456
   --  czyli dla poniedziałku (początek nowego tygodnia) usuwa
   --  gwiazdkę, a dla pozostałych dni usuwa numer tygodnia - numer
   --  tygodnia będzie występował tylko w poniedziałek.

   -----------------
   -- Is_Day_Line --
   -----------------

   function Is_Day_Line (Line : Wide_String) return Boolean is
      Prefix : constant Wide_String := "*** "; --  Day headline prefix
   begin
      if Index (Line, Prefix) = 1 then
         return True;
      else
         return False;
      end if;
   end Is_Day_Line;

   ------------------
   -- Fix_Day_Line --
   ------------------

   function Fix_Day_Line (Line : Wide_String) return Wide_String is
   begin
      if Index (Line, "Pon") > 0 then
         return Delete (Line, 25, Line'Last); -- Poniedziałek
      else
         return Delete (Line, 19, Line'Last); -- Inny dzień tygodnia
      end if;
   end Fix_Day_Line;

--  Start of processing for Calfix

begin
   while not End_Of_File loop
      declare
         Line : constant Wide_String := Get_Line;
      begin
         if Is_Day_Line (Line) then
            Put_Line (Fix_Day_Line (Line));
         else
            Put_Line (Line);
         end if;
      end;
   end loop;
end Calfix;
