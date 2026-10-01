package Sentinel_Ledger_Core
  with SPARK_Mode => On
is
   Max_Events : constant := 256;

   subtype Event_Id is Positive range 1 .. Max_Events;
   subtype Sequence_Number is Natural range 0 .. Max_Events;

   type Seen_Array is array (Event_Id) of Boolean;

   type System_State is record
      Sequence : Sequence_Number := 0;
      Seen     : Seen_Array := [others => False];
   end record;

   type Event_Record is record
      Id                : Event_Id;
      Expected_Sequence : Sequence_Number;
   end record;

   type Apply_Result is
     (Applied,
      Duplicate,
      Out_Of_Order,
      Capacity_Reached);

   procedure Apply_Event
     (State  : in out System_State;
      Event  : Event_Record;
      Result : out Apply_Result)
   with
     Contract_Cases =>
       (State.Sequence = Sequence_Number'Last =>
          Result = Capacity_Reached
          and then State = State'Old,

        State.Sequence < Sequence_Number'Last
        and then State.Seen (Event.Id) =>
          Result = Duplicate
          and then State = State'Old,

        State.Sequence < Sequence_Number'Last
        and then not State.Seen (Event.Id)
        and then Event.Expected_Sequence /= State.Sequence + 1 =>
          Result = Out_Of_Order
          and then State = State'Old,

        others =>
          Result = Applied
          and then State.Sequence = State'Old.Sequence + 1
          and then
            State.Seen =
              (State.Seen'Old with delta Event.Id => True));

end Sentinel_Ledger_Core;