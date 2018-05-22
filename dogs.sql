CREATE TABLE dogs (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES human(id)
);

CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER,

  FOREIGN KEY(house_id) REFERENCES human(id)
);

CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  houses (id, address)
VALUES
  (1, "65 Boulder Ridge Road"), (2, "11155 Roseland Road");

INSERT INTO
  humans (id, fname, lname, house_id)
VALUES
  (1, "Zack", "Leinwand", 1),
  (2, "Michael", "Maiolo", 1),
  (3, "Maya", "Rosemarin", 2),
  (4, "Alicia", "Underhill", NULL);

INSERT INTO
  dogs (id, name, owner_id)
VALUES
  (1, "Baxter", 1),
  (2, "Miss Emma Van Deusen", 2),
  (3, "Other Emma", 3),
  (4, "Maisy", 3),
  (5, "Stray Doggo", NULL);
