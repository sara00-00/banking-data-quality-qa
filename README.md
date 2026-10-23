# Banking Data Quality & Reconciliation QA

**A SQL-based data quality and account balance reconciliation project using SQLite**

![SQLite](https://img.shields.io/badge/Database-SQLite-003B57?style=flat-square&logo=sqlite&logoColor=white)
![SQL](https://img.shields.io/badge/Language-SQL-4479A1?style=flat-square)

---

## 📌 Project Overview

This project uses a sample banking database to practice data quality testing with SQL. It focuses on validating selected data fields and relationships, identifying potential anomalies, and reconciling recorded account balances with calculated balances.

> **Dataset note:** This is a sample dataset for educational and portfolio use. It is not production banking data.

## 🎯 Objectives

- Check customer data completeness.
- Identify duplicate customer emails, account numbers, and card numbers.
- Validate relationships between accounts, customers, branches, and transactions.
- Validate transaction amounts and profile transaction types.
- Identify standing orders with past next-run dates.
- Reconcile recorded account balances against transaction history.
- Document findings and limitations.

## 🧰 Tools & Dataset

| Item | Details |
|---|---|
| Database | SQLite |
| SQL tool | DB Browser for SQLite |
| Query language | SQL |
| Tables | 33 |
| Total records | 2,521 |
| SQL query sections | 12 |

## 📊 Execution Summary

| Status | Count | Meaning |
|---|---:|---|
| PASS | 8 | No issue found for the specific rule tested |
| REVIEW | 2 | Finding requires further investigation |
| PROFILE | 2 | Descriptive summary, not a pass/fail test |
| **Total** | **12** | **Query sections executed** |

## 🔍 Key Findings

- **Duplicate card numbers:** 5 duplicate groups were found and require business-rule confirmation.
- **Past standing-order dates:** 10 records had next-run dates earlier than SQLite's current date and require investigation.
- These findings are marked `REVIEW`, not confirmed defects.

## 💳 Account Balance Reconciliation

The query compared recorded balances against balances calculated from transaction records.

**Calculation rule:**

`Deposits + Interest - Withdrawals - Fees`

**Observed result:** No mismatches were returned across 20 accounts using a tolerance of `0.01`.

This result assumes a zero opening balance, complete transaction history, and the stated transaction-sign rules. These assumptions have not been verified against official business requirements.

## ⚠️ Limitations

- The checks cover selected tables and rules, not the entire database.
- Potential duplicates are not automatically confirmed defects.
- Date validation depends on the date returned by SQLite and the stored date format.
- Reconciliation results depend on the stated assumptions.
- The dataset is for educational and portfolio use only.

## ✅ Conclusion

This project provided practical experience using SQL to validate data quality, check selected table relationships, investigate potential anomalies, and reconcile account balances using a sample banking dataset.
