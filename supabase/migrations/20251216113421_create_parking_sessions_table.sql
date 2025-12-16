/*
  # Create parking sessions table

  1. New Tables
    - `parking_sessions`
      - `id` (uuid, primary key) - Unique identifier for each session
      - `license_plate` (text) - Car license plate number (e.g., "10Q922CB")
      - `entry_time` (timestamptz) - Time when car entered parking
      - `exit_time` (timestamptz, nullable) - Time when car exited parking
      - `amount_paid` (integer) - Amount paid in sum
      - `status` (text) - Status: "inside" or "exited"
      - `created_at` (timestamptz) - Record creation timestamp

  2. Security
    - Enable RLS on `parking_sessions` table
    - Add policy for public read access (demo app)
    - Add policy for public insert access (demo app)
    - Add policy for public update access (demo app)
*/

CREATE TABLE IF NOT EXISTS parking_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  license_plate text NOT NULL,
  entry_time timestamptz DEFAULT now() NOT NULL,
  exit_time timestamptz,
  amount_paid integer DEFAULT 0,
  status text DEFAULT 'inside' NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE parking_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view parking sessions"
  ON parking_sessions
  FOR SELECT
  TO anon
  USING (true);

CREATE POLICY "Anyone can insert parking sessions"
  ON parking_sessions
  FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Anyone can update parking sessions"
  ON parking_sessions
  FOR UPDATE
  TO anon
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Anyone can delete parking sessions"
  ON parking_sessions
  FOR DELETE
  TO anon
  USING (true);