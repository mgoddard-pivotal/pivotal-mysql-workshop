-- Example of a partitioned table in MySQL
-- Ref. https://dev.mysql.com/doc/refman/5.5/en/partitioning-range.html
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
  id INT NOT NULL,
  firstname VARCHAR(25) NOT NULL,
  lastname VARCHAR(25) NOT NULL,
  username VARCHAR(16) NOT NULL,
  email VARCHAR(35),
  joined DATE NOT NULL,
  -- PRIMARY KEY (id) /* This won't work. */
  PRIMARY KEY (id, joined) /* The partition columns are required in the PK. */
)
PARTITION BY RANGE COLUMNS (joined)
(
    PARTITION p0 VALUES LESS THAN ('1960-01-01'),
    PARTITION p1 VALUES LESS THAN ('1970-01-01'),
    PARTITION p2 VALUES LESS THAN ('1980-01-01'),
    PARTITION p3 VALUES LESS THAN ('1990-01-01'),
    PARTITION p4 VALUES LESS THAN MAXVALUE
);

-- Add a row
INSERT INTO members VALUES (1, 'Joe', 'Jones', 'jjones', 'jj@acme.com', '1986-07-19');

-- Check the "partitions" column, to see which ones are scanned
EXPLAIN SELECT * FROM members WHERE joined < '1989-01-01';

-- Add a constraint and recheck the "partitions" column of the explain plan
EXPLAIN SELECT * FROM members WHERE joined < '1989-01-01' AND joined > '1980-01-01';

