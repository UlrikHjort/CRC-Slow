with Crc; use Crc;
with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Interfaces; use Interfaces;


procedure CRC_Test is
   Message_Str : constant String := ("This is a test string 123 ABC");
   Message : Unsigned_8_Array_T (Message_Str'First .. Message_Str'Last);
   Ret : Unsigned_32 := 0;
   Name : CrC_Name_T :=CRC_16; --CRC_CCITT;
begin

   -- Copy Message String to byte buffer:
   for I in Message_Str'First .. Message_Str'Last loop
      Message(I) := Character'Pos (Message_Str(I));
   end loop;

     Name := CRC_CCITT;
     Ret := Calculate_Crc(Message, Name);
     Put_Line(Crc_Name_T'Image(Name) & " test:");
     Put_Line("Test String: " & Message_Str);
     Put_Line("Expected Result: " & "16#D6DC#");
     Put("Result : ");
     Put(Item => Positive(Ret) , Base => 16);
     New_Line;

     New_Line;
     Name := CRC_16;
     Ret := Calculate_Crc(Message, Name);
     Put_Line(Crc_Name_T'Image(Name) & " test:");
     Put_Line("Test String: " & Message_Str);
     Put_Line("Expected Result: " & "16#6F7E#");
     Put("Result : ");
     Put(Item => Positive(Ret) , Base => 16);
     New_Line;

     New_Line;
     Name := CRC_32;
     Ret := Calculate_Crc(Message, Name);
     Put_Line(Crc_Name_T'Image(Name) & " test:");
     Put_Line("Test String: " & Message_Str);
     Put_Line("Expected Result: " & "16#44BBA23#");
     Put("Result : ");
     Put(Item => Positive(Ret) , Base => 16);
     New_Line;



end CRC_Test;
