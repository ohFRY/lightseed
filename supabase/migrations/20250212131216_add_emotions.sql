-- Drop existing saved_affirmations table and its policies
DROP TABLE IF EXISTS public.saved_affirmations CASCADE;

-- Timeline items table - central hub for all user content
CREATE TABLE public.timeline_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    -- Type represents the content category, not a table reference
    type TEXT NOT NULL CHECK (type IN ('affirmation', 'journal_entry', 'gratitude', 
        'morning_pages', 'emotion_log', 'activity_log', 'thought_awareness')),
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    metadata JSONB DEFAULT '{}'::jsonb
);

-- Create enums for emotion metadata
CREATE TYPE public.emotion_valence AS ENUM ('positive', 'negative', 'neutral');
CREATE TYPE public.arousal_level AS ENUM ('high', 'medium', 'low');

-- Create emotions table with metadata
CREATE TABLE public.emotions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    valence public.emotion_valence NOT NULL,
    arousal_level public.arousal_level NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Create categories table
CREATE TABLE public.emotion_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Create junction table for emotions and categories
CREATE TABLE public.emotion_categories_emotions (
    emotion_id UUID REFERENCES public.emotions(id) ON DELETE CASCADE,
    category_id UUID REFERENCES public.emotion_categories(id) ON DELETE CASCADE,
    PRIMARY KEY (emotion_id, category_id)
);

-- Create emotion logs table
CREATE TABLE public.emotion_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    timeline_item_id UUID REFERENCES public.timeline_items(id) ON DELETE CASCADE,
    emotion_id UUID REFERENCES public.emotions(id),
    intensity INTEGER CHECK (intensity BETWEEN 1 AND 10),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Add indexes for better performance
CREATE INDEX public.emotion_logs_timeline_item_id_idx ON public.emotion_logs(timeline_item_id);
CREATE INDEX public.emotion_logs_emotion_id_idx ON public.emotion_logs(emotion_id);
CREATE INDEX public.emotions_valence_idx ON public.emotions(valence);
CREATE INDEX public.emotions_arousal_idx ON public.emotions(arousal_level);
CREATE INDEX public.timeline_items_type_idx ON public.timeline_items(type);
CREATE INDEX public.timeline_items_user_id_type_idx ON public.timeline_items(user_id, type);

-- Add RLS policies
ALTER TABLE public.emotions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.emotion_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.emotion_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.emotion_categories_emotions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.timeline_items ENABLE ROW LEVEL SECURITY;

-- Everyone can read emotions and categories
CREATE POLICY "Emotions are viewable by everyone" 
    ON public.emotions FOR SELECT USING (true);

CREATE POLICY "Categories are viewable by everyone" 
    ON public.emotion_categories FOR SELECT USING (true);

-- Add policy for emotion_categories_emotions junction table
CREATE POLICY "Junction table is viewable by everyone" 
    ON public.emotion_categories_emotions FOR SELECT USING (true);

-- Users can only manage their own emotion logs
CREATE POLICY "Users can manage their own emotion logs" 
    ON public.emotion_logs 
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.timeline_items 
            WHERE public.timeline_items.id = public.emotion_logs.timeline_item_id 
            AND public.timeline_items.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can view their own timeline items" 
    ON public.timeline_items FOR SELECT 
    USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own timeline items" 
    ON public.timeline_items FOR INSERT 
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own timeline items" 
    ON public.timeline_items FOR DELETE 
    USING (auth.uid() = user_id);