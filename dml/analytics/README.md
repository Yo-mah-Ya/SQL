1. docker image build

```sh
./do.sh build
```

2. docker container run

```sh
./do.sh run
```

3. `CREATE DATABASE IF NOT EXISTS` and `CREATE TABLE`

```
./do.sh ddl 4.analyze-sales/1/ddl.sh
```

4. `login to Postgres terminal`

```sh
./do.sh login
```

5. execute query

```sql
\i 4.analyze-sales/1/1.sql
```
