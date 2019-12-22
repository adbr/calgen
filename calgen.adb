--  2019-12-16 adbr

--  Program calgen drukuje na stdout kalendarz na dany rok.
--
--  Sposób użycia: calgen [-h] [year1 [year2]]
--
--  Jeśli nie podano argumentu to calgen drukuje kalendarz na
--  aktualny rok. Jeśli podano year1 to drukuje kalendarz na rok
--  year1. Jeśli podano year1 i year2 to drukuje kalendarz na lata od
--  year1 do year2 (bez year2). Opcja -h powoduje wypisanie krótkiego
--  opisu programu.
--
--  Kalendarz ma postać:
--
--      * 2019
--      ** 2019-01 Styczeń
--      *** 2019-01-01 Wto [w01]
--      *** 2019-01-02 Śro [w01]
--      *** 2019-01-03 Czw [w01]
--      *** 2019-01-04 Pią [w01]
--      *** 2019-01-05 Sob [w01]
--      *** 2019-01-06 Nie [w01]
--      *** 2019-01-07 Pon [w02] *
--
--  Gwiazdką (*) jest oznaczony początek nowego tygodnia.

pragma Wide_Character_Encoding (UTF8);

with Ada.Calendar;
with Ada.Calendar.Arithmetic;
with Ada.Command_Line;
with Ada.Wide_Wide_Text_IO;
with Ada.Integer_Wide_Wide_Text_IO;
with Ada.Strings;
with Ada.Strings.Wide_Wide_Fixed;
with GNAT.Calendar;

procedure Calgen is

   use Ada.Calendar;
   use Ada.Calendar.Arithmetic;
   use Ada.Command_Line;
   use Ada.Wide_Wide_Text_IO;
   use Ada.Integer_Wide_Wide_Text_IO;
   use Ada.Strings;
   use Ada.Strings.Wide_Wide_Fixed;
   use GNAT.Calendar;

   procedure Print_Date_Item (Date : Time);
   --  Drukuje na stdout nagłówek dla dnia określonego w Date w
   --  postać: "*** 2019-12-21 Sob [w51]". Na początku roku drukuje
   --  dodatkowo nagłówek roku w postaci: "* 2019", a na początku
   --  miesiąca nagłówek miesiąca w postaci: "** 2019-01". Początek
   --  tygodnia jest zaznaczony gwiazdką "*" na końcu wiersza.
   --  Czyli dla pierwszego styczna wydrukuje:
   --  * 2019
   --  ** 2019-01 Styczeń
   --  *** 2019-01-01 Wto [w01]

   function Current_Year return Year_Number;
   --  Zwraca numer aktualnego roku.

   procedure Print_Usage;
   --  Drukuje na stdout sposób użycia programu.

   procedure Print_Help;
   --  Drukuje na stdout opis programu.

   ---------------------
   -- Print_Date_Item --
   ---------------------

   procedure Print_Date_Item (Date : Time) is
      Year        : constant Year_Number := Ada.Calendar.Year (Date);
      Month       : constant Month_Number := Ada.Calendar.Month (Date);
      Day         : constant Day_Number := Ada.Calendar.Day (Date);
      Day_Of_Week : constant Day_Name := GNAT.Calendar.Day_Of_Week (Date);
      Week        : constant Week_In_Year_Number :=
        GNAT.Calendar.Week_In_Year (Date);

      procedure Print_Year_Headline (Year : Year_Number);
      --  Drukuje na stdout nagłówek roku w postaci:
      --  "* 2019".

      procedure Print_Month_Headline
        (Year  : Year_Number;
         Month : Month_Number);
      --  Drukuje na stdout nagłówek miesiąca w postaci:
      --  "** 2019-01 Styczeń".

      procedure Print_Day_Headline
        (Year        : Year_Number;
         Month       : Month_Number;
         Day         : Day_Number;
         Day_Of_Week : Day_Name;
         Week        : Week_In_Year_Number);
      --  Drukuje na stdout nagłówek dnia w postaci:
      --  "*** 2019-01-01 Wto [w01]".

      -------------------------
      -- Print_Year_Headline --
      -------------------------

      procedure Print_Year_Headline (Year : Year_Number) is
      begin
         Put ("* ");
         Put (Year, 0);
         New_Line;
      end Print_Year_Headline;

      --------------------------
      -- Print_Month_Headline --
      --------------------------

      procedure Print_Month_Headline
        (Year  : Year_Number;
         Month : Month_Number) is

         function Month_Name_String
           (Month : Month_Number) return Wide_Wide_String;
         --  Zwraca nazwę miesiąca w języku Polskim.

         -----------------------
         -- Month_Name_String --
         -----------------------

         function Month_Name_String
           (Month : Month_Number) return Wide_Wide_String
         is
            Names : constant array (Month_Number) of
              Wide_Wide_String (1 .. 11) :=
              (1  => "Styczeń    ",
               2  => "Luty       ",
               3  => "Marzec     ",
               4  => "Kwiecień   ",
               5  => "Maj        ",
               6  => "Czerwiec   ",
               7  => "Lipiec     ",
               8  => "Sierpień   ",
               9  => "Wrzesień   ",
               10 => "Październik",
               11 => "Listopad   ",
               12 => "Grudzień   ");
         begin
            return Trim (Names (Month), Right);
         end Month_Name_String;

      --  Start of processing for Print_Month_Headline

      begin
         Put ("** ");
         Put (Year, 0);
         Put ("-");
         if Month < 10 then
            Put ("0");
         end if;
         Put (Month, 0);
         Put (" ");
         Put (Month_Name_String (Month));
         New_Line;
      end Print_Month_Headline;

      ------------------------
      -- Print_Day_Headline --
      ------------------------

      procedure Print_Day_Headline
        (Year        : Year_Number;
         Month       : Month_Number;
         Day         : Day_Number;
         Day_Of_Week : Day_Name;
         Week        : Week_In_Year_Number) is

         function Day_Of_Week_String
           (Day : Day_Name) return Wide_Wide_String;
         --  Zwraca skróconą nazwę dnia tygodnia w języku Polskim.

         ------------------------
         -- Day_Of_Week_String --
         ------------------------

         function Day_Of_Week_String
           (Day : Day_Name) return Wide_Wide_String
         is
            Names : constant array (Day_Name) of
              Wide_Wide_String (1 .. 3) :=
              (Monday    => "Pon",
               Tuesday   => "Wto",
               Wednesday => "Śro",
               Thursday  => "Czw",
               Friday    => "Pią",
               Saturday  => "Sob",
               Sunday    => "Nie");
         begin
            return Names (Day);
         end Day_Of_Week_String;

      --  Start of processing for Print_Day_Headline

      begin
         Put ("***");

         --  Rok

         Put (" ");
         Put (Year, 0);

         --  Miesiąc

         Put ("-");
         if Month < 10 then
            Put ("0");
         end if;
         Put (Month, 0);

         --  Dzień

         Put ("-");
         if Day < 10 then
            Put ("0");
         end if;
         Put (Day, 0);

         --  Dzień tygodnia

         Put (" ");
         Put (Day_Of_Week_String (Day_Of_Week));

         --  Numer tygodnia

         Put (" [w");
         if Week < 10 then
            Put ("0");
         end if;
         Put (Week, 0);
         Put ("]");

         --  Zaznaczenie nowego tygodnia

         if Day_Of_Week = Monday then
            Put (" *");
         end if;

         New_Line;
      end Print_Day_Headline;

   --  Start of processing for Print_Date_Item

   begin
      --  Początek roku

      if Month = 1 and Day = 1 then
         Print_Year_Headline (Year);
      end if;

      --  Początek miesiąca

      if Day = 1 then
         Print_Month_Headline (Year, Month);
      end if;

      --  Dzień

      Print_Day_Headline (Year, Month, Day, Day_Of_Week, Week);
   end Print_Date_Item;

   ------------------
   -- Current_Year --
   ------------------

   function Current_Year return Year_Number is
      Date : Time;
      Year : Year_Number;
   begin
      Date := Clock;
      Year := Ada.Calendar.Year (Date);
      return Year;
   end Current_Year;

   -----------------
   -- Print_Usage --
   -----------------

   procedure Print_Usage is
   begin
      Put_Line ("Usage: calgen [-h] [year1 [year2]]");
   end Print_Usage;

   ----------------
   -- Print_Help --
   ----------------

   procedure Print_Help is
      procedure P (Item : Wide_Wide_String) renames
         Ada.Wide_Wide_Text_IO.Put_Line;
   begin
      P ("Program calgen drukuje na stdout kalendarz na dany rok.");
      P ("");
      P ("Sposób użycia: calgen [-h] [year1 [year2]]");
      P ("");
      P ("Jeśli nie podano argumentu to calgen drukuje kalendarz na");
      P ("aktualny rok. Jeśli podano year1 to drukuje kalendarz na rok");
      P ("year1. Jeśli podano year1 i year2 to drukuje kalendarz na lata od");
      P ("year1 do year2 (bez year2). Opcja -h powoduje wypisanie krótkiego");
      P ("opisu programu.");
      P ("");
      P ("Kalendarz ma postać:");
      P ("");
      P ("    * 2019");
      P ("    ** 2019-01 Styczeń");
      P ("    *** 2019-01-01 Wto [w01]");
      P ("    *** 2019-01-02 Śro [w01]");
      P ("    *** 2019-01-03 Czw [w01]");
      P ("    *** 2019-01-04 Pią [w01]");
      P ("    *** 2019-01-05 Sob [w01]");
      P ("    *** 2019-01-06 Nie [w01]");
      P ("    *** 2019-01-07 Pon [w02] *");
      P ("");
      P ("Gwiazdką (*) jest oznaczony początek nowego tygodnia.");
   end Print_Help;

   --  Local variables

   Year1 : Year_Number;
   Year2 : Year_Number;
   Date1 : Time;
   Date2 : Time;
   One_Day : constant Day_Count := 1;

--  Start of processing for Calgen

begin
   --  Obsługa opcji -h

   if Argument_Count > 0 and then Argument (1) = "-h" then
      Print_Help;
      return;
   end if;

   --  Obsługa argumentów programów

   case Argument_Count is
      when 0 =>
         Year1 := Current_Year;
         Year2 := Year1 + 1;
      when 1 =>
         Year1 := Year_Number'Value (Argument (1));
         Year2 := Year1 + 1;
      when 2 =>
         Year1 := Year_Number'Value (Argument (1));
         Year2 := Year_Number'Value (Argument (2));
      when others =>
         Print_Usage;
         return;
   end case;

   --  Iterowanie po kolejnych dniach i wydruk daty

   Date1 := Time_Of (Year => Year1, Month => 1, Day => 1);
   Date2 := Time_Of (Year => Year2, Month => 1, Day => 1);
   while Date1 < Date2 loop
      Print_Date_Item (Date1);
      Date1 := Date1 + One_Day;
   end loop;
end Calgen;
