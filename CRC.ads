-------------------------------------------------------------------------------
--                                                                           --
--                                  CRC                                      --
--                                                                           --
--                                CRC.ads                                    --
--                                                                           --
--                                  BODY                                     --
--                                                                           --
--                   Copyright (C) 1998 Ulrik Hørlyk Hjort                   --
--                                                                           --
--  CRC is free software;  you can  redistribute it  and/or modify it under  --
--  terms of the  GNU General Public License as published  by the Free Soft- --
--  ware  Foundation;  either version 2,  or (at your option) any later ver- --
--  sion. CRC is distributed in the hope that it will be useful, but WITH-   --
--  OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
--  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License --
--  for  more details.  You should have  received  a copy of the GNU General --
--  Public License  distributed with Yolk.  If not, write  to  the  Free     --
--  Software Foundation,  51  Franklin  Street,  Fifth  Floor, Boston,       --
--  MA 02110 - 1301, USA.                                                    --
--                                                                           --
-------------------------------------------------------------------------------

with Interfaces; use Interfaces;

package CRC is

   type Unsigned_8_Array_T is array (Positive range <>) of Unsigned_8;
   type Unsigned_16_Array_T is array (Positive range <>) of Unsigned_16;

   type CRC_Name_T is (CRC_CCITT, CRC_16, CRC_32);

   Current_Name : CRC_Name_T := CRC_CCITT;


   type CRC_Type is
      record
         Name              : CRC_Name_T;
         Polynomial        : Unsigned_32;
         Initial_Remainder : Unsigned_32;
         Final_Xor_Value   : Unsigned_32;
         Mask              : Unsigned_32;
         Width             : Natural;
         Reflect_Data      : Boolean;
         Reflect_Remainder : Boolean;
      end record;


   -- CRC CCITT : X^16 + X^12 + X^5 + 1
   Crc_CCITT_R : constant Crc_Type := (Name => CRC_CCITT,
                                     Polynomial => 16#00001021#,
                                     Initial_Remainder => 16#0000FFFF#,
                                     Final_Xor_Value => 16#00000000#,
                                     Mask => 16#0000FFFF#,
                                     Width => 16#10#,
                                     Reflect_Data => False,
                                     Reflect_Remainder => False);


   -- CRC_16 :X^16 + X^15 + X^2 + 1
   Crc_16_R : constant Crc_Type :=  (Name => CRC_16,
                                     Polynomial => 16#00008005#,
                                     Initial_Remainder => 16#00000000#,
                                     Final_Xor_Value => 16#00000000#,
                                     Mask => 16#0000FFFF#,
                                     Width => 16#10#,
                                     Reflect_Data => True,
                                     Reflect_Remainder => True);


   -- CRC_32 : X^32 + X^26 + X^23 + X^22 + X^16 + X^12 + X^11 + X^10 + X^8 + X^7 + X^5 + X^4 + X^2 + X + 1
   Crc_32_R : constant Crc_Type :=  (Name => CRC_32,
                                     Polynomial => 16#04C11DB7#,
                                     Initial_Remainder => 16#FFFFFFFF#,
                                     Final_Xor_Value => 16#FFFFFFFF#,
                                     Mask => 16#FFFFFFFF#,
                                     Width => 16#20#,
                                     Reflect_Data => True,
                                     Reflect_Remainder => True);

   type CRC_Types_Array_T is array (CRC_Name_T range <>) of CRC_Type;

   Crc_Name : constant CRC_Types_Array_T(CRC_Name_T'First .. CRC_Name_T'Last) := (Crc_CCITT_R, Crc_16_R, Crc_32_R);


   --------------------------------------------------------------------------------------
   -- Calculate the CRC value for the Message with the CRC polynomial given in Name.
   -- Returns the calculated CRC value.
   --------------------------------------------------------------------------------------
   function Calculate_Crc(Message : in Unsigned_8_Array_T; Name : in Crc_Name_T := CRC_CCITT) return Unsigned_32;
end CRC;
