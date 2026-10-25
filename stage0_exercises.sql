-- Stage 0 exercises: journal-entry red-flag queries
-- Dataset: synthetic ledger created by 00_stage0_setup.sql
-- Each query flags items for review. Flags are not findings of fraud.

-- ============================================================
-- Test 1: Entries and value per account
-- Purpose: profile where the money sits
-- What stands out: The consulting fees holds 35% (7) of entries amounting to Rs. 9,85,850 out of which 2 entries are just below the 2,00,000 approval limit & 1 at exactly at the limit.
-- ============================================================

   SELECT a.account_name, COUNT(j.amount), SUM(j.amount) 
   FROM journal_entries j 
   JOIN accounts a ON j.account_id = a.account_id 
   GROUP BY a.account_id, a.account_name
   ORDER BY SUM(j.amount) DESC;


-- ============================================================
-- Test 2: Entries and value per preparer
-- Purpose: spot concentration of postings by one user
-- What stands out: Ravi has posted 7 entries covering 48% of the total amount (Rs. 15,74,590.20) including duplicate pair, two of the near- limit entries and one posted on weekend.
-- ============================================================

   SELECT u.user_name, COUNT(j.amount), SUM(j.amount) 
   FROM journal_entries j 
   JOIN users u ON j.prepared_by = u.user_id
   GROUP BY u.user_id, u.user_name 
   ORDER BY SUM(j.amount) DESC;


-- ============================================================
-- Test 3: Self-approved entries (preparer = approver)
-- Red flag: maker-checker control bypassed
-- Legitimate causes: an emergency situation to record entries, absence of approver, temporary rights granted
-- Evidence to gather: check control mechanisms, check the logs if checker has been changed
-- ============================================================

   SELECT j.je_id, u.user_name, j.amount
   FROM journal_entries j
   JOIN users u ON u.user_id = j.prepared_by
   WHERE j.prepared_by = j.approved_by
   ORDER BY j.je_id;


-- ============================================================
-- Test 4: Weekend postings
-- Red flag: entries posted outside normal working days
-- Legitimate causes: half-year end closure postings, 
-- Evidence to gather: log records, attendance records to ascertain who were present, access right logs
-- ============================================================

   SELECT j.je_id, j.posting_date, j.amount, u.user_name
   FROM journal_entries j 
   JOIN users u ON j.prepared_by = u.user_id 
   WHERE EXTRACT (DOW from j.posting_date) IN (0,6)
   ORDER BY posting_date;


-- ============================================================
-- Test 5: Possible duplicate postings
-- Red flag: same account, amount and date posted more than once
-- Legitimate causes: two different invoices raised, splitting of payments, fixed recurring charges
-- Evidence to gather: bank ledgers, payment proofs
-- ============================================================

   SELECT j.account_id,
       j.amount,
       j.posting_date,
       COUNT(*)                          AS occurrences,
       STRING_AGG(j.je_id::text, ', ' ORDER BY j.je_id) AS je_ids
   FROM journal_entries j
   GROUP BY j.account_id, j.amount, j.posting_date
   HAVING COUNT(*) > 1
   ORDER BY occurrences DESC, j.posting_date;
