with Ada.Text_IO; use Ada.Text_IO;
with Sentinel_Ledger_Core; use Sentinel_Ledger_Core;

procedure Sentinel_Ledger is
   State  : System_State;
   Result : Apply_Result;

   First_Event : constant Event_Record :=
     (Id                => 1,
      Expected_Sequence => 1);

   Out_Of_Order_Event : constant Event_Record :=
     (Id                => 2,
      Expected_Sequence => 3);
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