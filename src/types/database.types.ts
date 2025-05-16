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
      admin_users: {
        Row: {
          id: string
          email: string
          password: string
          name: string
          role: 'super_admin' | 'content_manager' | 'support'
          created_at: string
          last_login: string | null
        }
        Insert: {
          id?: string
          email: string
          password: string
          name: string
          role: 'super_admin' | 'content_manager' | 'support'
          created_at?: string
          last_login?: string | null
        }
        Update: {
          id?: string
          email?: string
          password?: string
          name?: string
          role?: 'super_admin' | 'content_manager' | 'support'
          created_at?: string
          last_login?: string | null
        }
      }
      admin_logs: {
        Row: {
          id: string
          admin_id: string
          action: string
          entity_type: string
          entity_id: string | null
          details: Json | null
          ip_address: string | null
          created_at: string
        }
        Insert: {
          id?: string
          admin_id: string
          action: string
          entity_type: string
          entity_id?: string | null
          details?: Json | null
          ip_address?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          admin_id?: string
          action?: string
          entity_type?: string
          entity_id?: string | null
          details?: Json | null
          ip_address?: string | null
          created_at?: string
        }
      }
      admin_permissions: {
        Row: {
          id: string
          role: string
          resource: string
          action: string
        }
        Insert: {
          id?: string
          role: string
          resource: string
          action: string
        }
        Update: {
          id?: string
          role?: string
          resource?: string
          action?: string
        }
      }
      profiles: {
        Row: {
          id: string
          name: string | null
          avatar_url: string | null
          bio: string | null
          preferences: Json | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          name?: string | null
          avatar_url?: string | null
          bio?: string | null
          preferences?: Json | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          name?: string | null
          avatar_url?: string | null
          bio?: string | null
          preferences?: Json | null
          created_at?: string
          updated_at?: string
        }
      }
      badges: {
        Row: {
          id: string
          name: string
          icon: string
          description: string
          created_at: string
        }
        Insert: {
          id?: string
          name: string
          icon: string
          description: string
          created_at?: string
        }
        Update: {
          id?: string
          name?: string
          icon?: string
          description?: string
          created_at?: string
        }
      }
      user_badges: {
        Row: {
          id: string
          user_id: string
          badge_id: string
          earned_at: string
        }
        Insert: {
          id?: string
          user_id: string
          badge_id: string
          earned_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          badge_id?: string
          earned_at?: string
        }
      }
    }
  }
}