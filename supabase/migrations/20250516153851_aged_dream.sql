/*
  # Admin Management System Schema

  1. New Tables
    - `admin_users`: Store admin user information with role-based access
    - `admin_logs`: Track all admin activities
    - `admin_permissions`: Define granular permissions per role
    - `profiles`: Extended user profile information
    - `badges`: Achievement badges for users
    - `user_badges`: Many-to-many relationship for user badges

  2. Security
    - Enable RLS on all tables
    - Add policies for admin access
    - Secure password handling
    - Role-based access control

  3. Relationships
    - Admin logs linked to admin users
    - User profiles linked to auth.users
    - User badges linked to users and badges
*/

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Admin Users Table
CREATE TABLE IF NOT EXISTS admin_users (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  email text UNIQUE NOT NULL,
  password text NOT NULL,
  name text NOT NULL,
  role text NOT NULL CHECK (role IN ('super_admin', 'content_manager', 'support')),
  created_at timestamptz DEFAULT now(),
  last_login timestamptz
);

-- Admin Activity Logs
CREATE TABLE IF NOT EXISTS admin_logs (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  admin_id uuid REFERENCES admin_users(id),
  action text NOT NULL,
  entity_type text NOT NULL,
  entity_id uuid,
  details jsonb,
  ip_address text,
  created_at timestamptz DEFAULT now()
);

-- Admin Permissions
CREATE TABLE IF NOT EXISTS admin_permissions (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  role text NOT NULL,
  resource text NOT NULL,
  action text NOT NULL,
  UNIQUE(role, resource, action)
);

-- User Profiles
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id),
  name text,
  avatar_url text,
  bio text,
  preferences jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Badges
CREATE TABLE IF NOT EXISTS badges (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text NOT NULL,
  icon text NOT NULL,
  description text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- User Badges (Many-to-Many)
CREATE TABLE IF NOT EXISTS user_badges (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid REFERENCES auth.users(id) NOT NULL,
  badge_id uuid REFERENCES badges(id) NOT NULL,
  earned_at timestamptz DEFAULT now(),
  UNIQUE(user_id, badge_id)
);

-- Enable Row Level Security
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_badges ENABLE ROW LEVEL SECURITY;

-- Admin Users Policies
CREATE POLICY "Super admins can manage admin users"
  ON admin_users
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users au
      WHERE au.id = auth.uid()
      AND au.role = 'super_admin'
    )
  );

-- Admin Logs Policies
CREATE POLICY "Admins can view logs"
  ON admin_logs
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users au
      WHERE au.id = auth.uid()
    )
  );

-- Profiles Policies
CREATE POLICY "Users can view own profile"
  ON profiles
  FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Badges Policies
CREATE POLICY "Anyone can view badges"
  ON badges
  FOR SELECT
  TO authenticated
  USING (true);

-- User Badges Policies
CREATE POLICY "Users can view own badges"
  ON user_badges
  FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

-- Insert default admin permissions
INSERT INTO admin_permissions (role, resource, action) VALUES
  ('super_admin', 'admin_users', 'create'),
  ('super_admin', 'admin_users', 'read'),
  ('super_admin', 'admin_users', 'update'),
  ('super_admin', 'admin_users', 'delete'),
  ('content_manager', 'badges', 'create'),
  ('content_manager', 'badges', 'read'),
  ('content_manager', 'badges', 'update'),
  ('support', 'profiles', 'read'),
  ('support', 'user_badges', 'read');