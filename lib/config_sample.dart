const String baseUrl = 'YOUR_APPS_SCRIPT_DEPLOYED_WEBAPP_FROM_GOOGLESPREADSHEET_URL_HERE';

const bool isLocal = true;

const supabaseUrl = isLocal
    ? "http://localhost:54321"
    : "https://your-cloud-supabase-url.supabase.co";

const supabaseAnonKey = isLocal
    ? "your-local-anon-key"
    : "your-cloud-anon-key";