# Sentinel Ledger

A small tamper-evident event ledger built in **SPARK/Ada** to explore how software invariants can be mechanically verified rather than only tested.

```mermaid
flowchart LR
    E[Event] --> A{Apply_Event}
    A -->|valid| S[Advance sequence]
    S --> H[Advance SHA3-256 chain]
    H --> B[Append to history]
    A -->|duplicate| R[Reject]
    A -->|wrong sequence| R
    A -->|capacity reached| R
    R --> U[State unchanged]

    classDef input fill:#EAF2FF,stroke:#6B8FD6,color:#1E2A3A,stroke-width:1.5px;
    classDef decision fill:#FFF4D6,stroke:#D6A94A,color:#3A2D12,stroke-width:1.5px;
    classDef success fill:#E8F5EC,stroke:#67A97A,color:#193522,stroke-width:1.5px;
    classDef reject fill:#FCECEC,stroke:#C97A7A,color:#4A2020,stroke-width:1.5px;
    classDef neutral fill:#F3F4F6,stroke:#9CA3AF,color:#252A31,stroke-width:1.5px;

    class E input;
    class A decision;
    class S,H,B success;
    class R reject;
    class U neutral;
```

## Verified properties

GNATprove checks that:

- accepted events advance the sequence exactly once and update the SHA3-256 chain
- duplicate, out-of-order, and over-capacity events are rejected
- rejected events leave the complete ledger state unchanged
- accepted events append to a bounded history of 256 entries without altering earlier entries

**Slice 5:** all **182 proof checks** passed.

## Build and prove

```sh
alr build
alr run
alr gnatprove --mode=prove --level=2 --report=all --no-subprojects
```

## Scope

This is a compact high-assurance systems prototype, not a production blockchain or distributed ledger. The append-only guarantee applies to `Apply_Event`; the state is not yet encapsulated, persisted, or independently checked against the recorded hash chain.
