package body Sentinel_Ledger_Core
  with SPARK_Mode => On
is

   procedure Apply_Event
     (State : in out System_State;
      Event : Event_Record)
   is
   begin
      State.Sequence := State.Sequence + 1;
      State.Seen (Event.Id) := True;
   end Apply_Event;

end Sentinel_Ledger_Core;