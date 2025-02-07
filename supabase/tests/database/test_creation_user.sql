-- Load pgTAP functions
SET search_path TO pgtap, public;

-- Begin the test: 
-- Ensure that creating a user records an entry in both the auth.users and public.profiles tables with the same UUID
BEGIN;

-- Plan for 4 tests
SELECT plan(4);

-- Test 1:  Insert a new user into the auth.users table and retrieves the UUID.
INSERT INTO auth.users (id, email, raw_user_meta_data)
VALUES (uuid_generate_v4(), 'test@example.com', '{"full_name": "Test User", "avatar_url": "http://example.com/avatar.png"}')
RETURNING id INTO STRICT user_id;

-- Test 2: Verify that the auth.users table exists and the user entry was created.
SELECT has_table('auth', 'users', 'auth.users table exists');
SELECT has_row('auth.users', 'id = user_id', 'User entry created');

-- Test 3: Verify that the public.profiles table exists and the profile entry was created with the same UUID.
SELECT has_table('public', 'profiles', 'public.profiles table exists');
SELECT has_row('public.profiles', 'id = user_id', 'Profile entry created');

-- Finish the test
SELECT * FROM finish();

-- End the test
ROLLBACK;