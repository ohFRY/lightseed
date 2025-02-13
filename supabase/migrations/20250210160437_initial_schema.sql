-- Clean up existing objects
DROP POLICY IF EXISTS "Users can view their own saved affirmations" ON public.saved_affirmations;
DROP POLICY IF EXISTS "Users can update own profile." ON public.profiles;
DROP POLICY IF EXISTS "Users can insert their own saved affirmations" ON public.saved_affirmations;
DROP POLICY IF EXISTS "Users can insert their own profile." ON public.profiles;
DROP POLICY IF EXISTS "Users can delete their own saved affirmations" ON public.saved_affirmations;
DROP POLICY IF EXISTS "Public profiles are viewable by everyone." ON public.profiles;
DROP POLICY IF EXISTS "Health checks are readable by everyone" ON public.health_checks;

-- Drop existing constraints
ALTER TABLE IF EXISTS ONLY public.saved_affirmations DROP CONSTRAINT IF EXISTS saved_affirmations_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.profiles DROP CONSTRAINT IF EXISTS profiles_id_fkey;
ALTER TABLE IF EXISTS ONLY public.saved_affirmations DROP CONSTRAINT IF EXISTS saved_affirmations_user_id_affirmation_id_key;
ALTER TABLE IF EXISTS ONLY public.saved_affirmations DROP CONSTRAINT IF EXISTS saved_affirmations_pkey;
ALTER TABLE IF EXISTS ONLY public.profiles DROP CONSTRAINT IF EXISTS profiles_username_key;
ALTER TABLE IF EXISTS ONLY public.profiles DROP CONSTRAINT IF EXISTS profiles_pkey;
ALTER TABLE IF EXISTS ONLY public.health_checks DROP CONSTRAINT IF EXISTS health_checks_pkey;

-- Drop existing tables
DROP TABLE IF EXISTS public.saved_affirmations;
DROP TABLE IF EXISTS public.profiles;
DROP TABLE IF EXISTS public.health_checks;
DROP FUNCTION IF EXISTS public.handle_new_user();

-- Create function to handle new users
CREATE FUNCTION public.handle_new_user() 
RETURNS trigger
LANGUAGE plpgsql SECURITY DEFINER AS $$
begin
  insert into public.profiles (id, full_name, avatar_url)
  values (new.id, new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'avatar_url');
  return new;
end;
$$;

-- Create health_checks table
CREATE TABLE public.health_checks (
    id bigint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    timestamp timestamp with time zone DEFAULT now(),
    status boolean DEFAULT true NOT NULL
);

-- Create profiles table
CREATE TABLE public.profiles (
    id uuid NOT NULL PRIMARY KEY,
    updated_at timestamp with time zone,
    username text,
    full_name text,
    avatar_url text,
    CONSTRAINT username_length CHECK ((char_length(username) >= 3)),
    CONSTRAINT profiles_username_key UNIQUE (username),
    CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE
);

-- Create saved_affirmations table
CREATE TABLE public.saved_affirmations (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id uuid NOT NULL,
    affirmation_id integer NOT NULL,
    content text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    saved_at timestamp with time zone DEFAULT now(),
    CONSTRAINT saved_affirmations_user_id_affirmation_id_key UNIQUE (user_id, affirmation_id),
    CONSTRAINT saved_affirmations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);

-- Enable RLS
ALTER TABLE public.health_checks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.saved_affirmations ENABLE ROW LEVEL SECURITY;

-- Create policies for health_checks
CREATE POLICY "Health checks are readable by everyone" ON public.health_checks FOR SELECT USING (true);

-- Create policies for profiles
CREATE POLICY "Public profiles are viewable by everyone." ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Users can insert their own profile." ON public.profiles FOR INSERT WITH CHECK ((auth.uid() = id));
CREATE POLICY "Users can update own profile." ON public.profiles FOR UPDATE USING ((auth.uid() = id));

-- Create policies for saved_affirmations
CREATE POLICY "Users can view their own saved affirmations" ON public.saved_affirmations FOR SELECT USING ((auth.uid() = user_id));
CREATE POLICY "Users can insert their own saved affirmations" ON public.saved_affirmations FOR INSERT WITH CHECK ((auth.uid() = user_id));
CREATE POLICY "Users can delete their own saved affirmations" ON public.saved_affirmations FOR DELETE USING ((auth.uid() = user_id));