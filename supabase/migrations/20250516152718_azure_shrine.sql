/*
  # Travel Planning Application Schema

  1. New Tables
    - users (existing table, adding new columns)
    - trips (stores trip details)
    - destinations (stores destination information)
    - travelers (stores traveler details for each trip)
    - hotels (stores hotel bookings)
    - flights (stores flight bookings)
    - saved_trips (stores user's saved trips)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users to manage their own data
*/

-- Modify existing users table to add profile fields
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS phone_number text,
ADD COLUMN IF NOT EXISTS address text;

-- Create trips table
CREATE TABLE IF NOT EXISTS trips (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  title text NOT NULL,
  start_date date NOT NULL,
  end_date date NOT NULL,
  total_budget decimal(10,2) NOT NULL,
  status text DEFAULT 'draft' CHECK (status IN ('draft', 'planned', 'completed', 'cancelled')),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create destinations table
CREATE TABLE IF NOT EXISTS destinations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  trip_id uuid REFERENCES trips(id) ON DELETE CASCADE NOT NULL,
  city text NOT NULL,
  country text NOT NULL,
  arrival_date date NOT NULL,
  departure_date date NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create travelers table
CREATE TABLE IF NOT EXISTS travelers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  trip_id uuid REFERENCES trips(id) ON DELETE CASCADE NOT NULL,
  full_name text NOT NULL,
  email text,
  phone text,
  document_type text CHECK (document_type IN ('passport', 'id_card', 'driving_license')),
  document_number text,
  created_at timestamptz DEFAULT now()
);

-- Create hotels table
CREATE TABLE IF NOT EXISTS hotels (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  trip_id uuid REFERENCES trips(id) ON DELETE CASCADE NOT NULL,
  destination_id uuid REFERENCES destinations(id) ON DELETE CASCADE NOT NULL,
  hotel_name text NOT NULL,
  check_in_date date NOT NULL,
  check_out_date date NOT NULL,
  room_type text NOT NULL,
  price_per_night decimal(10,2) NOT NULL,
  booking_reference text,
  created_at timestamptz DEFAULT now()
);

-- Create flights table
CREATE TABLE IF NOT EXISTS flights (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  trip_id uuid REFERENCES trips(id) ON DELETE CASCADE NOT NULL,
  airline text NOT NULL,
  flight_number text NOT NULL,
  departure_city text NOT NULL,
  arrival_city text NOT NULL,
  departure_time timestamptz NOT NULL,
  arrival_time timestamptz NOT NULL,
  price decimal(10,2) NOT NULL,
  booking_reference text,
  created_at timestamptz DEFAULT now()
);

-- Create saved_trips table
CREATE TABLE IF NOT EXISTS saved_trips (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  trip_id uuid REFERENCES trips(id) ON DELETE CASCADE NOT NULL,
  created_at timestamptz DEFAULT now(),
  UNIQUE(user_id, trip_id)
);

-- Enable Row Level Security
ALTER TABLE trips ENABLE ROW LEVEL SECURITY;
ALTER TABLE destinations ENABLE ROW LEVEL SECURITY;
ALTER TABLE travelers ENABLE ROW LEVEL SECURITY;
ALTER TABLE hotels ENABLE ROW LEVEL SECURITY;
ALTER TABLE flights ENABLE ROW LEVEL SECURITY;
ALTER TABLE saved_trips ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can manage their own trips"
  ON trips
  FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage destinations for their trips"
  ON destinations
  FOR ALL
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM trips 
    WHERE trips.id = destinations.trip_id 
    AND trips.user_id = auth.uid()
  ));

CREATE POLICY "Users can manage travelers for their trips"
  ON travelers
  FOR ALL
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM trips 
    WHERE trips.id = travelers.trip_id 
    AND trips.user_id = auth.uid()
  ));

CREATE POLICY "Users can manage hotels for their trips"
  ON hotels
  FOR ALL
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM trips 
    WHERE trips.id = hotels.trip_id 
    AND trips.user_id = auth.uid()
  ));

CREATE POLICY "Users can manage flights for their trips"
  ON flights
  FOR ALL
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM trips 
    WHERE trips.id = flights.trip_id 
    AND trips.user_id = auth.uid()
  ));

CREATE POLICY "Users can manage their saved trips"
  ON saved_trips
  FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);