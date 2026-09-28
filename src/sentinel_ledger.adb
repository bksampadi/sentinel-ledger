with Ada.Text_IO; use Ada.Text_IO;
with Sentinel_Ledger_Core; use Sentinel_Ledger_Core;

procedure Sentinel_Ledger is
   State : System_State;

   Event : constant Event_Record :=
     (Id                => 1,
      Expected_Sequence => 1);
begin
   Apply_Event (State, Event);

   Put_Line
     ("Applied event. Ledger sequence:"
      & Sequence_Number'Image (State.Sequence));
end Sentinel_Ledger;