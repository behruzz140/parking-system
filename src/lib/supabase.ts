import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

export interface ParkingSession {
  id: string
  license_plate: string
  entry_time: string
  exit_time: string | null
  amount_paid: number
  status: 'inside' | 'exited'
  created_at: string
}
