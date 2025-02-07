BEGIN;

SELECT plan(20);

-- Table structure tests
SELECT has_table('public', 'saved_affirmations', 'Table saved_affirmations should exist');
SELECT has_column('saved_affirmations', 'id', 'Should have id column');
SELECT has_column('saved_affirmations', 'user_id', 'Should have user_id column');
SELECT has_column('saved_affirmations', 'affirmation_id', 'Should have affirmation_id column');
SELECT has_column('saved_affirmations', 'content', 'Should have content column');
SELECT has_column('saved_affirmations', 'created_at', 'Should have created_at column');
SELECT has_column('saved_affirmations', 'saved_at', 'Should have saved_at column');

-- Column types and constraints
SELECT col_type_is('saved_affirmations', 'id', 'bigint', 'id should be bigint');
SELECT col_type_is('saved_affirmations', 'user_id', 'uuid', 'user_id should be uuid');
SELECT col_type_is('saved_affirmations', 'affirmation_id', 'integer', 'affirmation_id should be integer');
SELECT col_type_is('saved_affirmations', 'content', 'text', 'content should be text');
SELECT col_type_is('saved_affirmations', 'created_at', 'timestamp with time zone', 'created_at should be timestamptz');
SELECT col_type_is('saved_affirmations', 'saved_at', 'timestamp with time zone', 'saved_at should be timestamptz');

-- Constraints
SELECT col_is_pk('saved_affirmations', 'id', 'id should be primary key');
SELECT col_is_unique('saved_affirmations', ARRAY['user_id', 'affirmation_id'], 'user_id and affirmation_id should be unique together');
SELECT col_not_null('saved_affirmations', 'user_id', 'user_id should not be null');
SELECT col_not_null('saved_affirmations', 'affirmation_id', 'affirmation_id should not be null');
SELECT col_not_null('saved_affirmations', 'content', 'content should not be null');

-- RLS Policy tests
DO $$
DECLARE
    test_user_id uuid;
    another_user_id uuid;
    test_affirmation_id integer;
BEGIN
    -- Create test users
    INSERT INTO auth.users (id, email) VALUES 
        (gen_random_uuid(), 'test1@example.com') 
    RETURNING id INTO test_user_id;
    
    INSERT INTO auth.users (id, email) VALUES 
        (gen_random_uuid(), 'test2@example.com') 
    RETURNING id INTO another_user_id;

    -- Set auth context to first test user
    SET LOCAL ROLE authenticated;
    SET LOCAL "request.jwt.claim.sub" TO test_user_id::text;

    -- Test INSERT policy
    test_affirmation_id := 1;
    INSERT INTO saved_affirmations (user_id, affirmation_id, content)
    VALUES (test_user_id, test_affirmation_id, 'Test affirmation');

    ASSERT EXISTS (
        SELECT 1 FROM saved_affirmations 
        WHERE user_id = test_user_id AND affirmation_id = test_affirmation_id
    ), 'User should be able to insert their own saved affirmation';

    -- Test SELECT policy
    ASSERT (
        SELECT count(*) FROM saved_affirmations WHERE user_id = test_user_id
    ) = 1, 'User should be able to see their own saved affirmation';

    ASSERT (
        SELECT count(*) FROM saved_affirmations WHERE user_id = another_user_id
    ) = 0, 'User should not be able to see other users saved affirmations';

    -- Test DELETE policy
    DELETE FROM saved_affirmations 
    WHERE user_id = test_user_id AND affirmation_id = test_affirmation_id;

    ASSERT NOT EXISTS (
        SELECT 1 FROM saved_affirmations 
        WHERE user_id = test_user_id AND affirmation_id = test_affirmation_id
    ), 'User should be able to delete their own saved affirmation';

END $$;

SELECT pass('RLS policies work as expected');

SELECT * FROM finish();
ROLLBACK;