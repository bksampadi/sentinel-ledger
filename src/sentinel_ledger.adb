with Ada.Text_IO; use Ada.Text_IO;
with Sentinel_Ledger_Core; use Sentinel_Ledger_Core;

procedure Sentinel_Ledger is
   State  : System_State;
   Result : Apply_Result;

   Grant_Admin_Payload : constant Payload_Digest :=
     [0 => 16#A1#, others => 0];

   Delete_User_Payload : constant Payload_Digest :=
     [0 => 16#B2#, others => 0];

   First_Event : constant Event_Record :=
     (Id                => 1,
      Expected_Sequence => 1,
      Payload           => Grant_Admin_Payload);

   Out_Of_Order_Event : constant Event_Record :=
     (Id                => 2,
      Expected_Sequence => 3,
      Payload           => Delete_User_Payload);
begin
   Apply_Event (State, First_Event, Result);

   Put_Line
     ("First event: " & Apply_Result'Image (Result));

   Apply_Event (State, First_Event, Result);

   Put_Line
     ("Replay: " & Apply_Result'Image (Result));

   Apply_Event (State, Out_Of_Order_Event, Result);

   Put_Line
     ("Wrong sequence: " & Apply_Result'Image (Result));

   Put_Line
     ("Final sequence:"
      & Sequence_Number'Image (State.Sequence));
end Sentinel_Ledger;