CREATE TABLE section (
    id INTEGER NOT NULL PRIMARY KEY,
    name TEXT NOT NULL,
    dummy TEXT NOT NULL,
    created DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE rows (
    id INTEGER NOT NULL PRIMARY KEY,
    section_id INTEGER NOT NULL REFERENCES section(id),
    random_float REAL,
    count_updates INTEGER NOT NULL DEFAULT 0,
    dummy TEXT NOT NULL,
    created DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated DATETIME DEFAULT CURRENT_TIMESTAMP
);

