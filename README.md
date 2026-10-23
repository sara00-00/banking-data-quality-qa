\# Banking Data Quality \& Reconciliation QA



<div align="center">



\*\*A SQL-based data quality and account balance reconciliation project using SQLite\*\*



!\[Database](https://img.shields.io/badge/Database-SQLite-003B57?style=flat-square\&logo=sqlite\&logoColor=white)

!\[Language](https://img.shields.io/badge/Language-SQL-4479A1?style=flat-square\&logo=mysql\&logoColor=white)



</div>



\---



\## 📌 Project Overview



This project uses a sample banking database to practice data quality testing with SQL. It focuses on checking selected data fields and relationships, identifying potential anomalies, and comparing recorded account balances with balances calculated from transaction records.



> \*\*Dataset note:\*\* This is a sample dataset for educational and portfolio use. It is not production banking data.



\## 🎯 Objectives



\- Check required customer fields for missing or blank values.

\- Identify duplicate customer emails, account numbers, and card numbers.

\- Validate selected relationships between accounts, customers, branches, and transactions.

\- Check transaction amounts and summarize transaction types.

\- Identify standing orders with past next-run dates.

\- Compare recorded account balances with calculated balances.

\- Document observed results and findings that need review.



\## 🧰 Tools \& Dataset



| Item | Details |

|---|---|

| Database | SQLite |

| SQL tool | DB Browser for SQLite |

| Query language | SQL |

| Tables | 33 |

| Total records | 2,521 |

| Execution results | CSV |



\## 🧪 Testing Scope



The SQL script contains 12 query sections across the following areas:



| Test ID | Test area | What it checks |

|---|---|---|

| `DQ-DB-001` | Data profiling | Record counts in selected tables |

| `DQ-CUST-001` | Completeness | Missing or blank customer email and name fields |

| `DQ-CUST-004` | Uniqueness | Duplicate customer emails after trimming and case normalization |

| `DQ-REL-001` | Referential integrity | Accounts linked to nonexistent customers |

| `DQ-REL-003` | Referential integrity | Accounts linked to nonexistent branches |

| `DQ-ACC-003` | Uniqueness | Duplicate account numbers |

| `DQ-TXN-002` | Referential integrity | Transactions linked to nonexistent accounts |

| `DQ-TXN-003` | Validity | Null, zero, or negative transaction amounts |

| `DQ-TXN-001` | Data profiling | Transaction types and amount ranges |

| `DQ-CARD-003` | Uniqueness | Count of duplicate card-number groups |

| `DQ-SO-006` | Date review | Standing orders with past next-run dates |

| `DQ-REC-001` | Reconciliation | Account balance differences greater than `0.01` |



\## 📊 Execution Summary



| Status | Count | Meaning |

|---|---:|---|

| ✅ `PASS` | 8 | No issue found for the specific rule tested |

| 🔎 `REVIEW` | 2 | Finding requires further investigation |

| 📈 `PROFILE` | 2 | Descriptive summary; not a pass/fail test |

| \*\*Total\*\* | \*\*12\*\* | \*\*Query sections executed\*\* |



\### Results by Test



| Test ID | Observed result | Status |

|---|---|---|

| `DQ-DB-001` | 1,187 records across the 8 selected tables | `PROFILE` |

| `DQ-CUST-001` | No records returned | `PASS` |

| `DQ-CUST-004` | No duplicate customer emails found | `PASS` |

| `DQ-REL-001` | No accounts linked to nonexistent customers found | `PASS` |

| `DQ-REL-003` | No accounts linked to nonexistent branches found | `PASS` |

| `DQ-ACC-003` | No duplicate account numbers found | `PASS` |

| `DQ-TXN-002` | No transactions linked to nonexistent accounts found | `PASS` |

| `DQ-TXN-003` | No null, zero, or negative transaction amounts found | `PASS` |

| `DQ-TXN-001` | 1,000 transactions across four transaction types | `PROFILE` |

| `DQ-CARD-003` | 5 duplicate card-number groups found | `REVIEW` |

| `DQ-SO-006` | 10 standing orders with past next-run dates found | `REVIEW` |

| `DQ-REC-001` | No balance mismatches found across 20 accounts | `PASS` |



\### Transaction Type Profile



| Type | Count | Minimum amount | Maximum amount |

|---|---:|---:|---:|

| Deposit | 426 | 5.00 | 4,966.43 |

| Fee | 45 | 0.07 | 48.94 |

| Interest | 36 | 0.07 | 49.37 |

| Withdrawal | 493 | 1.25 | 1,238.31 |

| \*\*Total\*\* | \*\*1,000\*\* | — | — |



\## 🔍 Findings to Review



The executed queries identified two areas that need further investigation:



1\. \*\*Duplicate card numbers:\*\* Five duplicate groups were found. Review whether repeated card numbers are permitted by the data model and business rules.

2\. \*\*Past standing-order dates:\*\* Ten records had `next\_run\_date` values before the date returned by SQLite's `DATE('now')`. Confirm whether these schedules are overdue or expected in this sample dataset.



These findings are marked `REVIEW`, not confirmed defects, because the available data does not establish the intended business rules.



Other findings explored earlier—such as repeated department names, repeated ATM location descriptions, and portfolio-name variations—are not covered by the current 12 query sections and are therefore excluded from the execution summary.



\## 💳 Account Balance Reconciliation



The reconciliation query compares each recorded account balance with a balance calculated from its transactions.



\### Calculation Rule



```text

Deposits + Interest - Withdrawals - Fees

```



\*\*Observed result:\*\* No mismatches were returned for the 20 accounts using a tolerance of `0.01`.



\### Assumptions



\- Opening balance is zero.

\- Transaction history is complete.

\- Deposits and interest increase balances.

\- Withdrawals and fees decrease balances.



These assumptions have not been verified against official business requirements, so the result should be interpreted within that scope.



A separate test previously used a simulated balance difference to check whether the SQL logic could identify a mismatch. The original database was not modified.



\## 🏷️ Result Status Definitions



| Status | Meaning |

|---|---|

| `PASS` | No violation was found for the specific rule tested |

| `REVIEW` | A finding needs investigation or business-rule confirmation |

| `FAIL` | The test detected a violation of the rule being checked |

| `PROFILE` | A descriptive summary rather than a pass/fail test |



A `PASS` result applies only to the specific check performed. It does not mean the entire database is free of data quality issues.



\## 📁 Suggested Repository Structure



```text

banking-data-quality-qa/

├── sql/

│   └── data\_quality\_tests.sql

├── results/

│   └── test\_execution\_results\_actual.csv

├── docs/

│   └── findings-and-limitations.md

└── README.md

```



Adjust the filenames above to match the files actually included in the repository.



\## ⚠️ Limitations



\- The current checks cover selected tables and rules, not all 33 tables.

\- Some validation rules depend on assumptions and need business confirmation.

\- Potential duplicates are not automatically confirmed defects.

\- Date checks depend on the formats supported by the query and the date returned by SQLite.

\- Reconciliation depends on the opening-balance and transaction-history assumptions.

\- Do not publish sensitive values such as raw card numbers, CVVs, or PIN hashes.



\## ✅ Conclusion



This project gave me practical experience using SQL to check data quality, validate selected table relationships, investigate potential issues, and compare account balances with transaction records.



The results are based on a sample dataset and the validation rules documented in this project.

