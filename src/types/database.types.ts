export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      users: {
        Row: {
          id: string
          email: string
          full_name: string | null
          phone_number: string | null
          address: string | null
          created_at: string | null
          updated_at: string | null
        }
        Insert: {
          id?: string
          email: string
          full_name?: string | null
          phone_number?: string | null
          address?: string | null
          created_at?: string | null
          updated_at?: string | null
        }
        Update: {
          id?: string
          email?: string
          full_name?: string | null
          phone_number?: string | null
          address?: string | null
          created_at?: string | null
          updated_at?: string | null
        }
      }
      trips: {
        Row: {
          id: string
          user_id: string
          title: string
          start_date: string
          end_date: string
          total_budget: number
          status: string
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          title: string
          start_date: string
          end_date: string
          total_budget: number
          status?: string
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          title?: string
          start_date?: string
          end_date?: string
          total_budget?: number
          status?: string
          created_at?: string
          updated_at?: string
        }
      }
      destinations: {
        Row: {
          id: string
          trip_id: string
          city: string
          country: string
          arrival_date: string
          departure_date: string
          created_at: string
        }
        Insert: {
          id?: string
          trip_id: string
          city: string
          country: string
          arrival_date: string
          departure_date: string
          created_at?: string
        }
        Update: {
          id?: string
          trip_id?: string
          city?: string
          country?: string
          arrival_date?: string
          departure_date?: string
          created_at?: string
        }
      }
      travelers: {
        Row: {
          id: string
          trip_id: string
          full_name: string
          email: string | null
          phone: string | null
          document_type: string | null
          document_number: string | null
          created_at: string
        }
        Insert: {
          id?: string
          trip_id: string
          full_name: string
          email?: string | null
          phone?: string | null
          document_type?: string | null
          document_number?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          trip_id?: string
          full_name?: string
          email?: string | null
          phone?: string | null
          document_type?: string | null
          document_number?: string | null
          created_at?: string
        }
      }
      hotels: {
        Row: {
          id: string
          trip_id: string
          destination_id: string
          hotel_name: string
          check_in_date: string
          check_out_date: string
          room_type: string
          price_per_night: number
          booking_reference: string | null
          created_at: string
        }
        Insert: {
          id?: string
          trip_id: string
          destination_id: string
          hotel_name: string
          check_in_date: string
          check_out_date: string
          room_type: string
          price_per_night: number
          booking_reference?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          trip_id?: string
          destination_id?: string
          hotel_name?: string
          check_in_date?: string
          check_out_date?: string
          room_type?: string
          price_per_night?: number
          booking_reference?: string | null
          created_at?: string
        }
      }
      flights: {
        Row: {
          id: string
          trip_id: string
          airline: string
          flight_number: string
          departure_city: string
          arrival_city: string
          departure_time: string
          arrival_time: string
          price: number
          booking_reference: string | null
          created_at: string
        }
        Insert: {
          id?: string
          trip_id: string
          airline: string
          flight_number: string
          departure_city: string
          arrival_city: string
          departure_time: string
          arrival_time: string
          price: number
          booking_reference?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          trip_id?: string
          airline?: string
          flight_number?: string
          departure_city?: string
          arrival_city?: string
          departure_time?: string
          arrival_time?: string
          price?: number
          booking_reference?: string | null
          created_at?: string
        }
      }
      saved_trips: {
        Row: {
          id: string
          user_id: string
          trip_id: string
          created_at: string
        }
        Insert: {
          id?: string
          user_id: string
          trip_id: string
          created_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          trip_id?: string
          created_at?: string
        }
      }
    }
  }
}