-- Initial released schema (app 0.1, drift schemaVersion 1).
-- Kept in the repository so the v1 -> v2 migration can be verified against the
-- exact DDL that shipped to devices.

CREATE TABLE stations (
  id TEXT NOT NULL,
  name TEXT NOT NULL,
  note TEXT,
  created_at INTEGER NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE calibrations (
  id TEXT NOT NULL,
  station_id TEXT NOT NULL REFERENCES stations (id),
  version INTEGER NOT NULL,
  line_a_x1 REAL NOT NULL,
  line_a_y1 REAL NOT NULL,
  line_a_x2 REAL NOT NULL,
  line_a_y2 REAL NOT NULL,
  line_b_x1 REAL NOT NULL,
  line_b_y1 REAL NOT NULL,
  line_b_x2 REAL NOT NULL,
  line_b_y2 REAL NOT NULL,
  distance_m REAL NOT NULL,
  reference_image_path TEXT,
  is_active INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE sessions (
  id TEXT NOT NULL,
  station_id TEXT NOT NULL REFERENCES stations (id),
  calibration_id TEXT REFERENCES calibrations (id),
  started_at INTEGER NOT NULL,
  ended_at INTEGER,
  note TEXT,
  PRIMARY KEY (id)
);

CREATE TABLE events (
  id TEXT NOT NULL,
  session_id TEXT NOT NULL REFERENCES sessions (id),
  calibration_id TEXT REFERENCES calibrations (id),
  counted_at INTEGER NOT NULL,
  speed_measured_at INTEGER,
  vehicle_class INTEGER NOT NULL,
  direction INTEGER NOT NULL,
  speed_kmh REAL,
  confidence REAL NOT NULL,
  PRIMARY KEY (id)
);

CREATE INDEX events_counted_at ON events (counted_at);
CREATE INDEX events_session_id ON events (session_id);
