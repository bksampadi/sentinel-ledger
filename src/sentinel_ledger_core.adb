package body Sentinel_Ledger_Core
  with SPARK_Mode => On
is

   procedure Apply_Event
     (State  : in out System_State;
      Event  : Event_Record;
      Result : out Apply_Result)
   is
   begin
      if State.Sequence = Sequence_Number'Last then
         Result := Capacity_Reached;

      elsif State.Seen (Event.Id) then
         Result := Duplicate;

      elsif Event.Expected_Sequence /= State.Sequence + 1 then
         Result := Out_Of_Order;

      else
         State.Sequence := State.Sequence + 1;
         State.Seen (Event.Id) := True;
         Result := Applied;
      end if;
   end Apply_Event;

end Sentinel_Ledger_Core;