-- Drop existing tables if any (clean slate)
DROP TABLE IF EXISTS responses CASCADE;
DROP TABLE IF EXISTS attempts CASCADE;
DROP TABLE IF EXISTS questions CASCADE;
DROP TABLE IF EXISTS quizzes CASCADE;
DROP TABLE IF EXISTS profiles CASCADE;

-- Create profiles table
CREATE TABLE profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  department text NOT NULL,
  role text DEFAULT 'user' CHECK (role IN ('user', 'admin')),
  created_at timestamptz DEFAULT now(),
  UNIQUE(name, department)
);

-- Create quizzes table
CREATE TABLE quizzes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  date date,
  trainer text,
  description text,
  passing_score int DEFAULT 70,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

-- Create questions table
CREATE TABLE questions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  quiz_id uuid NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
  type text NOT NULL CHECK (type IN ('single', 'multiple', 'truefalse', 'fill')),
  question text NOT NULL,
  options jsonb,
  answer jsonb NOT NULL,
  explanation text,
  order_num int
);

-- Create attempts table
CREATE TABLE attempts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  quiz_id uuid NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
  score int NOT NULL,
  correct_count int NOT NULL,
  total int NOT NULL,
  completed_at timestamptz DEFAULT now()
);

-- Create responses table
CREATE TABLE responses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  attempt_id uuid NOT NULL REFERENCES attempts(id) ON DELETE CASCADE,
  question_id uuid NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  user_answer jsonb,
  is_correct boolean NOT NULL
);

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE responses ENABLE ROW LEVEL SECURITY;

-- Profiles policies: anyone can read and insert
CREATE POLICY "profiles_select" ON profiles FOR SELECT USING (true);
CREATE POLICY "profiles_insert" ON profiles FOR INSERT WITH CHECK (true);
CREATE POLICY "profiles_update" ON profiles FOR UPDATE USING (true);

-- Quizzes policies: anyone can read, admin can manage
CREATE POLICY "quizzes_select" ON quizzes FOR SELECT USING (true);
CREATE POLICY "quizzes_insert" ON quizzes FOR INSERT WITH CHECK (true);
CREATE POLICY "quizzes_update" ON quizzes FOR UPDATE USING (true);
CREATE POLICY "quizzes_delete" ON quizzes FOR DELETE USING (true);

-- Questions policies: anyone can read, admin can manage
CREATE POLICY "questions_select" ON questions FOR SELECT USING (true);
CREATE POLICY "questions_insert" ON questions FOR INSERT WITH CHECK (true);
CREATE POLICY "questions_update" ON questions FOR UPDATE USING (true);
CREATE POLICY "questions_delete" ON questions FOR DELETE USING (true);

-- Attempts policies: anyone can read and insert
CREATE POLICY "attempts_select" ON attempts FOR SELECT USING (true);
CREATE POLICY "attempts_insert" ON attempts FOR INSERT WITH CHECK (true);

-- Responses policies: anyone can read and insert
CREATE POLICY "responses_select" ON responses FOR SELECT USING (true);
CREATE POLICY "responses_insert" ON responses FOR INSERT WITH CHECK (true);
