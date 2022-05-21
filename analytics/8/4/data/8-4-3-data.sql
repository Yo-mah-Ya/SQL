DROP TABLE IF EXISTS exam_scores;

CREATE TABLE exam_scores(
  name VARCHAR(255),
  subject VARCHAR(255),
  score INTEGER
);

INSERT INTO
  exam_scores
VALUES
  ('生徒A', 'English', 69),
  ('生徒B', 'English', 87),
  ('生徒C', 'English', 65),
  ('生徒D', 'English', 73),
  ('生徒E', 'English', 61),
  ('生徒A', 'math', 100),
  ('生徒B', 'math', 12),
  ('生徒C', 'math', 7),
  ('生徒D', 'math', 73),
  ('生徒E', 'math', 56);
