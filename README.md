# Forensics SQL Lab

A PostgreSQL project to build journal-entry fraud tests, written from a
forensic accounting perspective.

**Status: in progress.** Stage 0 (environment and first tests) is complete.
The detection library, scoring and evaluation are planned and not yet built.

## What exists today
- `00_stage0_setup.sql`: a small synthetic general ledger (20 entries, 5 users)
  with planted red flags. All data is synthetic.
- `stage0_exercises.sql`: queries I wrote to flag self-approved entries,
  weekend postings and possible duplicate postings, each with the red flag,
  legitimate explanations and follow-up evidence.

## Planned
- Further journal-entry tests (entries just below approval limits, round amounts)
- An alerts table and entity-level scoring
- Evaluation against injected fraud scenarios

## How to run
1. Create a PostgreSQL database named `fraud_lab`.
2. Run `00_stage0_setup.sql`, then the queries in `stage0_exercises.sql`.

## Notes
Flagged items are indicators for review, not findings of fraud.
