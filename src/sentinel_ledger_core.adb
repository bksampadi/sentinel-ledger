package body Sentinel_Ledger_Core
  with SPARK_Mode => On
is

   function Chain_Digest_For
     (Previous : Chain_Digest;
      Event    : Event_Record) return Chain_Digest
   is
      Data   : SHA3.Byte_Array (0 .. 68) := [others => 0];
      Digest : Chain_Digest;
   begin
      --  Domain separator for Sentinel Ledger chain entries.
      Data (0) := 16#53#;

      --  Previous 256-bit chain digest.
      Data (1 .. 32) := Previous;

      --  Event ID encoded as unsigned big-endian 16-bit value.
      Data (33) := SHA3.U8 (Event.Id / 256);
      Data (34) := SHA3.U8 (Event.Id mod 256);

      --  Expected sequence encoded as unsigned big-endian 16-bit value.
      Data (35) := SHA3.U8 (Event.Expected_Sequence / 256);
      Data (36) := SHA3.U8 (Event.Expected_Sequence mod 256);

      --  Commit to the action payload digest.
      Data (37 .. 68) := Event.Payload;

      SHA3.SHA3_256 (Data, Digest);

      return Digest;
   end Chain_Digest_For;

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
         State.Digest :=
           Chain_Digest_For
             (Previous => State.Digest,
              Event    => Event);

         State.Sequence := State.Sequence + 1;
         State.Seen (Event.Id) := True;
         Result := Applied;
      end if;
   end Apply_Event;

end Sentinel_Ledger_Core;