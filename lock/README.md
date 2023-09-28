# Transaction Isolation level

|                  | Dirty reads | Non repeatable reads | Phantom reads |
| ---------------- | :---------: | :------------------: | :-----------: |
| READ UNCOMMITTED |      P      |          P           |       P       |
| READ COMMITTED   |      I      |          P           |       P       |
| REPEATABLE READS |      I      |          I           |       P       |
| SERIALIZABLE     |      I      |          I           |       I       |

**`P` stands for `Possible to happen`, `I` stands for `Impossible to happen`**

**Leftmost colum shows `Transaction isolation levels`, the rest of columns show `Read phenomena`**

1. Dirty reads

A dirty read (aka uncommitted dependency) occurs when a transaction retrieves a row that has been `updated` by another transaction that **`is not yet committed`**.

2. Non repeatable reads

A non-repeatable read occurs when a transaction retrieves a row twice and that row is `updated` by another transaction that **`is committed in between`**.

3. Phantom reads

A phantom read occurs when a transaction retrieves a set of rows twice and **`new rows are inserted into or removed from`** that set by another transaction that is committed in between.

- Default isolation levels in each database engine

  - READ COMMITTED

    PostgreSQL, Oracle, SQL Server

  - REPEATABLE READS

    MySQL

  - SERIALIZABLE

    SQLite

# Table level locks

https://www.postgresql.org/docs/current/explicit-locking.html#LOCKING-TABLES

|                        | ACCESS SHARE | ROW SHARE | ROW EXCLUSIVE | SHARE UPDATE EXCLUSIVE | SHARE | SHARE ROW EXCLUSIVE | EXCLUSIVE | ACCESS EXCLUSIVE |
| ---------------------- | :----------: | :-------: | :-----------: | :--------------------: | :---: | :-----------------: | :-------: | :--------------: |
| ACCESS SHARE           |              |           |               |                        |       |                     |           |        X         |
| ROW SHARE              |              |           |               |                        |       |                     |     X     |        X         |
| ROW EXCLUSIVE          |              |           |               |                        |   X   |          X          |     X     |        X         |
| SHARE UPDATE EXCLUSIVE |              |           |               |           X            |   X   |          X          |     X     |        X         |
| SHARE                  |              |           |       X       |           X            |       |          X          |     X     |        X         |
| SHARE ROW EXCLUSIVE    |              |           |       X       |           X            |   X   |          X          |     X     |        X         |
| EXCLUSIVE              |              |     X     |       X       |           X            |   X   |          X          |     X     |        X         |
| ACCESS EXCLUSIVE       |      X       |     X     |       X       |           X            |   X   |          X          |     X     |        X         |

**Leftmost colum shows `Requested lock mode`, the rest of columns show `Current Lock mode`**

**`X` means current lock will block the requested lock**

- ACCESS SHARE

  - The `SELECT` command acquires a lock of this mode on referenced tables. **`In general, any query that only reads a table and does not modify it will acquire this lock mode.`**

- ROW SHARE

  - Conflicts with the `EXCLUSIVE` and `ACCESS EXCLUSIVE` lock modes.
  - The `SELECT` command acquires a lock of this mode on all tables on which one of the `FOR UPDATE`, `FOR NO KEY UPDATE`,`FOR SHARE`, or `FOR KEY SHARE` options is specified (in addition to ACCESS SHARE locks on any other tables that are referenced without any explicit FOR ... locking option).

- ROW EXCLUSIVE

  - The commands `UPDATE`, `DELETE`, `INSERT`, and `MERGE` acquire this lock mode on the target table (in addition to ACCESS SHARE locks on any other referenced tables). **`In general, this lock mode will be acquired by any command that modifies data in a table.`**

- ACCESS EXCLUSIVE

  - Conflicts with lock of all modes shown above.
  - Acquired by `DROP TABLE`, `TRUNCATE`, `REINDEX`, `VACUUM FULL` and `REFRESH MATERIALIZED VIEW (without CONCURRENTLY)` commands.
    Many forms of `ALTER INDEX` and ` ALTER TABLE` also acquire a lock at this level. This is also the default lock mode for `LOCK TABLE` statements that do not specify a mode explicitly.
  - **Only `ACCESS EXCLUSIVE` lock blocks a `SELECT (without FOR UPDATE/SHARE)` statement**

# Row level locks

https://www.postgresql.org/docs/current/explicit-locking.html#LOCKING-ROWS

|                   | FOR KEY SHARE | FOR SHARE | FOR NO KEY UPDATE | FOR UPDATE |
| ----------------- | :-----------: | :-------: | :---------------: | :--------: |
| FOR KEY SHARE     |               |           |                   |     X      |
| FOR SHARE         |               |           |         X         |     X      |
| FOR NO KEY UPDATE |               |     X     |         X         |     X      |
| FOR UPDATE        |       X       |     X     |         X         |     X      |

**Leftmost colum shows `Requested lock mode`, the rest of columns show `Current Lock mode`**

**`X` means current lock will block the requested lock**

- FOR UPDATE

  - Acquired by `SELECT FOR UPDATE`, `DELETE` and `UPDATE` that modifies UNIQUE index rows

- FOR NO KEY UPDATE

  - Acquired by `SELECT FOR NO KEY UPDATE`, `DELETE` and `UPDATE` that does not modify UNIQUE index rows.

- FOR SHARE
  - A shared lock blocks other transactions from performing `UPDATE`, `DELETE`, `SELECT` `FOR UPDATE` or SELECT FOR NO KEY UPDATE on these rows, but it does not prevent them from performing SELECT FOR SHARE or SELECT FOR KEY SHARE.
