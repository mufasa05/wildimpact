# Supabase Backend Setup for WildImpact

WildImpact uses **Supabase** (PostgreSQL, Realtime, Row-Level Security, Auth, and Storage) as its centralized cloud backend.

---

## 1. Quick Setup (1-Click SQL Migration)

1. Open your [Supabase Dashboard](https://supabase.com/dashboard) and create or select your project.
2. Go to the **SQL Editor** tab on the left navigation bar.
3. Click **New Query**.
4. Copy the entire contents of [`supabase/schema.sql`](file:///c:/Users/user/Tourism/supabase/schema.sql) and paste it into the editor.
5. Click **Run** (or `Cmd/Ctrl + Enter`).

This will create:
- **`lodges`**: Multi-tenant safari lodge operators (Singita Pamushana, Victoria Falls Safari Lodge, Hwange Bush Camp, Mana Pools Camp).
- **`conservation_projects`**: Anti-poaching patrols, solar microgrids, community water boreholes.
- **`milestones`**: Real-time verifiable field milestones with GPS.
- **`carbon_offset_projects`**: Verra & Gold Standard verified carbon credits with Zimbabwe CAMPFIRE revenue sharing.
- **`booking_contributions`**: Stay levies, conservation funds, and automatic CO2 offset calculations.
- **`impact_evidence`**: Geotagged photo proof and audited registry references.
- **`offset_purchases`**: Tourist certificate generation and blockchain-ready receipts.
- **`ranger_telemetry` & `wildlife_sightings`**: Real-time GPS tracking.
- **Row Level Security (RLS)** & Realtime replication channels.

---

## 2. Connect Your App with Supabase Credentials

Once your Supabase project is created:
1. Go to **Project Settings** -> **API**.
2. Copy your **Project URL** and **`anon` `public` Key**.
3. Pass them to Flutter during build/run or via environment variables:

```bash
flutter run -d chrome --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

Or for release build:
```bash
flutter build web --release --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your-anon-key
```
