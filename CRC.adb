-------------------------------------------------------------------------------
--                                                                           --
--                                  CRC                                      --
--                                                                           --
--                                CRC.adb                                    --
--                                                                           --
--                                  BODY                                     --
--                                                                           --
--                   Copyright (C) 1998 Ulrik Hørlyk Hjort                   --
--                                                                           --
--  CRC is free software;  you can  redistribute it  and/or modify it under  --
--  terms of the  GNU General Public License as published  by the Free Soft- --
--  ware  Foundation;  either version 2,  or (at your option) any later ver- --
--  sion.  CRC is distributed in the hope that it will be useful, but WITH-  --
--  OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
--  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License --
--  for  more details.  You should have  received  a copy of the GNU General --
--  Public License  distributed with Yolk.  If not, write  to  the  Free     --
--  Software Foundation,  51  Franklin  Street,  Fifth  Floor, Boston,       --
--  MA 02110 - 1301, USA.                                                    --
--                                                                           --
-------------------------------------------------------------------------------
with Ada.Unchecked_Conversion;

package body CRC is

   function Natural_To_Unsigned_8 is new
     Ada.Unchecked_Conversion (Source => Natural, Target => Unsigned_8);

   function Unsigned_32_To_Unsigned_8 is new
     Ada.Unchecked_Conversion (Source => Unsigned_32, Target => Unsigned_8);


   --------------------------------------------------------------------
   -- Reflect the Data value => Swap bit8 with bit0, bit with bit1 etc.
   -- Returns the reflected value.
   --------------------------------------------------------------------
   function Reflect(Data : in Unsigned_32; Bits : in Unsigned_8) return Unsigned_32 is
      Data_Tmp : Unsigned_32 := Data;
      Reflection : Unsigned_32 := 16#00000000#;

   begin
      for bit in 0 .. Bits-1 loop

         if (Data_Tmp and 16#01#) /= 0 then
            Reflection := Reflection or Shift_Left(1,Natural((Bits-1) - Bit));
         end if;
         Data_Tmp := Shift_Right(Data_Tmp,1);
      end loop;

      return Reflection;
   end Reflect;


   --------------------------------------------------------------------------------------
   -- Calculate the CRC value for the Message with the CRC polynomial given in Name.
   -- Returns the calculated CRC value.
   --------------------------------------------------------------------------------------
   function Calculate_Crc(Message : in Unsigned_8_Array_T; Name : in Crc_Name_T := CRC_CCITT) return Unsigned_32 is
      Remainder   : Unsigned_32                        := Crc_Name(Name).Initial_Remainder;
      Width       : constant Natural                   := Crc_Name(Name).Width;
      Msb         : constant Unsigned_32               := Shift_Left(1,Width-1);
      Reflect_Val : Unsigned_32                        := 0;
      Return_Val  : Unsigned_32                        := 0;


   begin
      for I in 1 .. Message'Length loop
         if Crc_Name(Name).Reflect_Data then
            Reflect_Val := Reflect(Unsigned_32(Message(I)),8);
        else
            Reflect_Val := Unsigned_32(Message(I));
         end if;
          Remainder := (Remainder xor Shift_Left(Reflect_Val, (Width -8)))  and Crc_Name(Name).Mask;


         -- Bitwise Modulo-2 division
         for Bit in 1 .. 8 loop
            if (Remainder and Msb) /= 0 then
               Remainder := (Shift_Left(Remainder,1) xor Crc_Name(Name).Polynomial);
            else
               Remainder := Shift_Left(Remainder,1);
            end if;
         Remainder := Remainder and CrC_Name(Name).Mask;
         end loop;



      if Crc_Name(Name).Reflect_Remainder then
         Return_Val := Reflect(Remainder,Natural_To_Unsigned_8(Width));
      else
         Return_Val := Remainder;
      end if;
      Remainder := Remainder and CrC_Name(Name).Mask;
            end loop;
      return (Return_Val xor Crc_Name(Name).Final_Xor_Value);
   end Calculate_Crc;
end CRC;
