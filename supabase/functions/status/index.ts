
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'

serve(async (req) => {
  const { isHealthy } = await checkDatabaseHealth()
  
  // Broadcast status to all connected clients
  const broadcast = {
    online: isHealthy,
    timestamp: new Date().toISOString()
  }

  return new Response(
    JSON.stringify(broadcast),
    { headers: { 'Content-Type': 'application/json' } },
  )
})

async function checkDatabaseHealth() {
  try {
    // Simple health check query
    const { data, error } = await supabase
      .from('health_checks')
      .select('count')
      .limit(1)
    
    return { isHealthy: !error }
  } catch (e) {
    return { isHealthy: false }
  }
}