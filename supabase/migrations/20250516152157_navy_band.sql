/*
  # Initial Schema Setup for AI Application

  1. New Tables
    - `users` - Stores user profiles
      - `id` (uuid, primary key) - Unique identifier
      - `email` (text) - User's email address
      - `full_name` (text) - User's full name
      - `created_at` (timestamp) - When the user was created
      - `updated_at` (timestamp) - When the user was last updated
    
    - `ai_conversations` - Stores conversation history
      - `id` (uuid, primary key) - Unique identifier
      - `user_id` (uuid) - Reference to users table
      - `title` (text) - Conversation title
      - `created_at` (timestamp) - When the conversation was created
      - `updated_at` (timestamp) - When the conversation was last updated

    - `messages` - Stores individual messages in conversations
      - `id` (uuid, primary key) - Unique identifier
      - `conversation_id` (uuid) - Reference to ai_conversations table
      - `content` (text) - Message content
      - `role` (text) - Message role (user/assistant)
      - `created_at` (timestamp) - When the message was created

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users to manage their own data
*/

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY DEFAULT auth.uid(),
  email text UNIQUE NOT NULL,
  full_name text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create ai_conversations table
CREATE TABLE IF NOT EXISTS ai_conversations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  title text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create messages table
CREATE TABLE IF NOT EXISTS messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id uuid REFERENCES ai_conversations(id) ON DELETE CASCADE NOT NULL,
  content text NOT NULL,
  role text NOT NULL CHECK (role IN ('user', 'assistant')),
  created_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Create policies for users table
CREATE POLICY "Users can read own profile"
  ON users
  FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON users
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id);

-- Create policies for ai_conversations table
CREATE POLICY "Users can CRUD own conversations"
  ON ai_conversations
  FOR ALL
  TO authenticated
  USING (auth.uid() = user_id);

-- Create policies for messages table
CREATE POLICY "Users can CRUD messages in their conversations"
  ON messages
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM ai_conversations
      WHERE ai_conversations.id = messages.conversation_id
      AND ai_conversations.user_id = auth.uid()
    )
  );