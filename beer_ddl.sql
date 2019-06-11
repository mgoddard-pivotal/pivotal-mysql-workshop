DROP TABLE IF EXISTS beer;
CREATE TABLE beer
(
  idx INT
  , beer_abv FLOAT
  , beer_id INT
  , brewer_id INT
  , beer_name VARCHAR(64)
  , beer_style VARCHAR(64)
  , appearance FLOAT
  , aroma FLOAT
  , overall FLOAT
  , palate FLOAT
  , taste FLOAT
  , review_text TEXT
  , time_struct TEXT
  , time_unix DATETIME -- INT
  , user_age_sec INT
  , user_birthday_raw VARCHAR(32)
  , user_birthdayUnix INT
  , user_gender VARCHAR(8)
  , user_profileName VARCHAR(32)
);


