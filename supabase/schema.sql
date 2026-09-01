-- ==============================================================================
-- WILDIMPACT: ECO-TOURISM & CONSERVATION SAAS BACKEND SCHEMA (SUPABASE / POSTGRES)
-- ==============================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ==============================================================================
-- 1. TENANT LODGES (Multi-Tenant Safari Operators)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.lodges (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    country TEXT NOT NULL DEFAULT 'Zimbabwe',
    region TEXT NOT NULL,
    description TEXT NOT NULL,
    banner_url TEXT NOT NULL,
    campfire_share_pct NUMERIC(5, 2) NOT NULL DEFAULT 40.0,
    total_patrol_hours INTEGER NOT NULL DEFAULT 0,
    hectares_protected INTEGER NOT NULL DEFAULT 0,
    carbon_offset_funded_usd NUMERIC(12, 2) NOT NULL DEFAULT 0.0,
    trees_planted INTEGER NOT NULL DEFAULT 0,
    water_liters_provided INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ==============================================================================
-- 2. USER PROFILES & ROLES
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    role TEXT NOT NULL DEFAULT 'operator', -- 'operator' | 'guest' | 'auditor' | 'ranger'
    tenant_id TEXT REFERENCES public.lodges(id) ON DELETE SET NULL,
    avatar_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ==============================================================================
-- 3. CONSERVATION PROJECTS
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.conservation_projects (
    id TEXT PRIMARY KEY,
    tenant_id TEXT NOT NULL REFERENCES public.lodges(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    type TEXT NOT NULL, -- 'antiPoaching' | 'waterProject' | 'reforestation' | 'solarCommunity' | 'wildlifeCorridor' | 'humanWildlifeConflict'
    target_metric NUMERIC(12, 2) NOT NULL DEFAULT 100.0,
    current_metric NUMERIC(12, 2) NOT NULL DEFAULT 0.0,
    unit TEXT NOT NULL DEFAULT 'units',
    image_url TEXT,
    latitude NUMERIC(10, 6),
    longitude NUMERIC(10, 6),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ==============================================================================
-- 4. CONSERVATION MILESTONES (Verifiable Impact Evidence)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.milestones (
    id TEXT PRIMARY KEY,
    project_id TEXT NOT NULL REFERENCES public.conservation_projects(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    metric_delta NUMERIC(12, 2) NOT NULL DEFAULT 0.0,
    evidence_url TEXT,
    latitude NUMERIC(10, 6),
    longitude NUMERIC(10, 6),
    verified_by TEXT NOT NULL DEFAULT 'Field Ranger',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ==============================================================================
-- 5. CARBON OFFSET PROJECTS (Verra & Gold Standard Verified)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.carbon_offset_projects (
    id TEXT PRIMARY KEY,
    tenant_id TEXT NOT NULL REFERENCES public.lodges(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    price_per_tonne NUMERIC(10, 2) NOT NULL DEFAULT 18.0,
    total_capacity NUMERIC(12, 2) NOT NULL,
    remaining_capacity NUMERIC(12, 2) NOT NULL,
    registry_id TEXT NOT NULL,
    zimbabwe_campfire_pct NUMERIC(5, 2) NOT NULL DEFAULT 40.0,
    impact_narrative TEXT NOT NULL,
    image_url TEXT NOT NULL,
    location TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ==============================================================================
-- 6. BOOKING CONTRIBUTIONS (Guest Stay Levies & Conservation Splits)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.booking_contributions (
    id TEXT PRIMARY KEY,
    tenant_id TEXT REFERENCES public.lodges(id) ON DELETE SET NULL,
    tour_name TEXT NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    date_str TEXT NOT NULL,
    guest_name TEXT NOT NULL,
    guest_count INTEGER NOT NULL DEFAULT 2,
    status TEXT NOT NULL DEFAULT 'Verified', -- 'Verified' | 'Allocated' | 'Pending'
    co2_offset_tonnes NUMERIC(8, 2) NOT NULL DEFAULT 0.0,
    allocation_category TEXT NOT NULL DEFAULT 'Anti-Poaching',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ==============================================================================
-- 7. IMPACT EVIDENCE LEDGER (Audited Field Proof)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.impact_evidence (
    id TEXT PRIMARY KEY,
    tenant_id TEXT REFERENCES public.lodges(id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    category TEXT NOT NULL, -- 'Anti-Poaching' | 'Community Water' | 'Habitat Restoration' | 'Wildlife Monitoring'
    location TEXT NOT NULL,
    date_str TEXT NOT NULL,
    image_url TEXT NOT NULL,
    verified_by TEXT NOT NULL,
    description TEXT NOT NULL,
    latitude NUMERIC(10, 6) NOT NULL,
    longitude NUMERIC(10, 6) NOT NULL,
    registry_ref TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ==============================================================================
-- 8. OFFSET PURCHASES (Tourist Carbon Certificates)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.offset_purchases (
    id TEXT PRIMARY KEY,
    offset_project_id TEXT NOT NULL REFERENCES public.carbon_offset_projects(id) ON DELETE CASCADE,
    project_name TEXT NOT NULL,
    tourist_name TEXT NOT NULL,
    tourist_email TEXT NOT NULL,
    tonnes NUMERIC(8, 2) NOT NULL,
    amount_paid NUMERIC(10, 2) NOT NULL,
    campfire_share NUMERIC(10, 2) NOT NULL,
    certificate_code TEXT UNIQUE NOT NULL,
    payment_method TEXT NOT NULL DEFAULT 'Stripe Visa Card',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ==============================================================================
-- 9. REAL-TIME RANGER TELEMETRY & WILDLIFE SIGHTINGS
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.ranger_telemetry (
    id TEXT PRIMARY KEY,
    tenant_id TEXT REFERENCES public.lodges(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    latitude NUMERIC(10, 6) NOT NULL,
    longitude NUMERIC(10, 6) NOT NULL,
    battery_pct INTEGER NOT NULL DEFAULT 100,
    status TEXT NOT NULL DEFAULT 'Patrolling Sector Alpha',
    last_ping TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.wildlife_sightings (
    id TEXT PRIMARY KEY,
    tenant_id TEXT REFERENCES public.lodges(id) ON DELETE CASCADE,
    species TEXT NOT NULL,
    count INTEGER NOT NULL DEFAULT 1,
    latitude NUMERIC(10, 6) NOT NULL,
    longitude NUMERIC(10, 6) NOT NULL,
    time_ago TEXT NOT NULL DEFAULT 'Just now',
    is_verified BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ==============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ==============================================================================
ALTER TABLE public.lodges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conservation_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.milestones ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.carbon_offset_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.booking_contributions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.impact_evidence ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.offset_purchases ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ranger_telemetry ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.wildlife_sightings ENABLE ROW LEVEL SECURITY;

-- Allow public read for transparency, guest apps, and ESG verification
CREATE POLICY "Public Read Lodges" ON public.lodges FOR SELECT USING (true);
CREATE POLICY "Public Read Projects" ON public.conservation_projects FOR SELECT USING (true);
CREATE POLICY "Public Read Milestones" ON public.milestones FOR SELECT USING (true);
CREATE POLICY "Public Read Offsets" ON public.carbon_offset_projects FOR SELECT USING (true);
CREATE POLICY "Public Read Contributions" ON public.booking_contributions FOR SELECT USING (true);
CREATE POLICY "Public Read Evidence" ON public.impact_evidence FOR SELECT USING (true);
CREATE POLICY "Public Read Purchases" ON public.offset_purchases FOR SELECT USING (true);
CREATE POLICY "Public Read Telemetry" ON public.ranger_telemetry FOR SELECT USING (true);
CREATE POLICY "Public Read Sightings" ON public.wildlife_sightings FOR SELECT USING (true);

-- Allow authenticated insertions / updates
CREATE POLICY "Allow Insert Contributions" ON public.booking_contributions FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow Insert Purchases" ON public.offset_purchases FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow Insert Milestones" ON public.milestones FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow Insert Projects" ON public.conservation_projects FOR INSERT WITH CHECK (true);

-- ==============================================================================
-- ENABLE SUPABASE REALTIME REPLICATION
-- ==============================================================================
ALTER PUBLICATION supabase_realtime ADD TABLE public.booking_contributions;
ALTER PUBLICATION supabase_realtime ADD TABLE public.milestones;
ALTER PUBLICATION supabase_realtime ADD TABLE public.offset_purchases;
ALTER PUBLICATION supabase_realtime ADD TABLE public.ranger_telemetry;
ALTER PUBLICATION supabase_realtime ADD TABLE public.wildlife_sightings;

-- ==============================================================================
-- SEED DATA (Authentic Zimbabwe Eco-Safari Lodges & Conservation Data)
-- ==============================================================================

INSERT INTO public.lodges (id, name, slug, country, region, description, banner_url, campfire_share_pct, total_patrol_hours, hectares_protected, carbon_offset_funded_usd, trees_planted, water_liters_provided)
VALUES
('pamushana-malilangwe', 'Singita Pamushana Lodge', 'singita-pamushana', 'Zimbabwe', 'Malilangwe Wildlife Reserve', 'Ultra-luxury cliffside eco-lodge overlooking Malilangwe dam, funding world-class black and white rhino sanctuaries and community nourishment programs.', 'https://images.unsplash.com/photo-1516426122078-c23e76319801?auto=format&fit=crop&w=1200&q=80', 45.0, 4820, 52000, 184500.00, 14200, 850000),
('vicfalls-safari-lodge', 'Victoria Falls Safari Lodge', 'vic-falls-safari', 'Zimbabwe', 'Victoria Falls National Park', 'Sunset plateau lodge overlooking an active waterhole, pioneering vulture conservation and clean solar grid initiatives for local schools.', 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?auto=format&fit=crop&w=1200&q=80', 40.0, 3140, 28000, 96200.00, 8400, 420000),
('hwange-bush-camp', 'Hwange Bush Camp', 'hwange-bush-camp', 'Zimbabwe', 'Hwange National Park North', 'Deep wilderness tented sanctuary running smart solar borehole pumps, elephant migration corridor monitoring and scout patrol units.', 'https://images.unsplash.com/photo-1575550959106-5a7defe28b56?auto=format&fit=crop&w=1200&q=80', 50.0, 5600, 84000, 142800.00, 11500, 1200000),
('mana-pools-camp', 'Mana Pools Safari Camp', 'mana-pools-camp', 'Zimbabwe', 'Mana Pools UNESCO Biosphere', 'Remote Zambezi riverbank sanctuary dedicated to flood basin biodiversity, anti-poaching boats and elephant habituation safety.', 'https://images.unsplash.com/photo-1534177616072-ef7dc120449d?auto=format&fit=crop&w=1200&q=80', 42.0, 2900, 39000, 78400.00, 6200, 310000)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.conservation_projects (id, tenant_id, name, description, type, target_metric, current_metric, unit, image_url, latitude, longitude)
VALUES
('p1', 'pamushana-malilangwe', 'Rhino Sanctuary K9 Scout Patrol', 'Funding elite scout ranger patrols and GPS telemetry collars across the 52,000-hectare Malilangwe sanctuary.', 'antiPoaching', 5000.0, 4120.0, 'Patrol Hours', 'https://images.unsplash.com/photo-1534177616072-ef7dc120449d?auto=format&fit=crop&w=600&q=80', -21.0189, 31.9056),
('p2', 'pamushana-malilangwe', 'Chiredzi Community Water Wells', 'Solar-powered smart boreholes bringing clean potable drinking water to 4 rural primary schools.', 'waterProject', 500000.0, 385000.0, 'Liters Pumped', 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?auto=format&fit=crop&w=600&q=80', -21.0500, 31.8500),
('p3', 'pamushana-malilangwe', 'Save Valley Indigenous Reforestation', 'Nurturing and planting Baobab, Mahogany and Acacia saplings to combat soil erosion.', 'reforestation', 20000.0, 14200.0, 'Trees Planted', 'https://images.unsplash.com/photo-1448375240586-882707db888b?auto=format&fit=crop&w=600&q=80', -20.9500, 32.0000),
('p4', 'vicfalls-safari-lodge', 'Vulture Restaurant & Poison Defense', 'Supplementary feeding station and toxicology defense shielding endangered White-backed and Hooded vultures.', 'antiPoaching', 1200.0, 940.0, 'Monitored Flights', 'https://images.unsplash.com/photo-1516426122078-c23e76319801?auto=format&fit=crop&w=600&q=80', -17.9244, 25.8560),
('p5', 'hwange-bush-camp', 'Sinamatella Smart Solar Waterholes', 'Continuous green solar borehole pumps providing perennial water for 3,000+ elephants during dry seasons.', 'waterProject', 1000000.0, 820000.0, 'Liters Provided', 'https://images.unsplash.com/photo-1575550959106-5a7defe28b56?auto=format&fit=crop&w=600&q=80', -18.6167, 26.2500)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.carbon_offset_projects (id, tenant_id, name, description, price_per_tonne, total_capacity, remaining_capacity, registry_id, zimbabwe_campfire_pct, impact_narrative, image_url, location)
VALUES
('co-1', 'pamushana-malilangwe', 'Chilo Gorge Indigenous Tree Sanctuary', 'Community-managed reforestation sequestering verified carbon and creating sustainable agroforestry jobs in southeast Zimbabwe.', 18.00, 450.0, 185.0, 'VERRA-VCS-2024-ZW-8821', 40.0, 'Funds local nursery guardians planting native hardwood trees and protecting wildlife buffer zones.', 'https://images.unsplash.com/photo-1448375240586-882707db888b?auto=format&fit=crop&w=600&q=80', 'Gonarezhou National Park Border'),
('co-2', 'pamushana-malilangwe', 'Kariba REDD+ Forest Protection', 'Preventing deforestation across 784,987 hectares of Zambezi valley miombo forest along Lake Kariba.', 15.00, 800.0, 340.0, 'GOLD-STD-GS4029-ZW', 45.0, 'Guarantees fire-break maintenance and community anti-snare ranger patrols.', 'https://images.unsplash.com/photo-1516426122078-c23e76319801?auto=format&fit=crop&w=600&q=80', 'Lake Kariba Basin'),
('co-3', 'hwange-bush-camp', 'Hwange Buffer Zone Solar Microgrid', 'Replacing diesel generator water pumps and kerosene lamps with high-efficiency solar battery systems.', 22.00, 300.0, 120.0, 'VERRA-VCS-2024-ZW-9104', 50.0, 'Directly eliminates 240,000 liters of diesel combustion emissions annually in rural Hwange.', 'https://images.unsplash.com/photo-1509391365360-2e959784a276?auto=format&fit=crop&w=600&q=80', 'Dete Rural District')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.booking_contributions (id, tenant_id, tour_name, amount, date_str, guest_name, guest_count, status, co2_offset_tonnes, allocation_category)
VALUES
('bc-01', 'pamushana-malilangwe', '7-Day Greater Kruger & Malilangwe Luxury Safari', 840.00, 'Today, 14:20', 'Eleanor & Marcus Vance', 2, 'Verified', 2.8, 'Anti-Poaching'),
('bc-02', 'pamushana-malilangwe', 'Chiredzi Community School & Village Immersion', 320.00, 'Today, 11:45', 'Dr. Aris Thorne', 1, 'Verified', 0.9, 'Community Projects'),
('bc-03', 'pamushana-malilangwe', '4-Night Big Five Photographic Expedition', 650.00, 'Yesterday', 'Sophie & Liam Becker', 2, 'Allocated', 2.1, 'Habitat Restoration'),
('bc-04', 'pamushana-malilangwe', 'Sunset Walking Safari & Ranger Tracking', 280.00, '2 days ago', 'Elena Rostova', 1, 'Verified', 0.6, 'Anti-Poaching'),
('bc-05', 'pamushana-malilangwe', 'Save Valley Conservation Immersion Tour', 520.00, '3 days ago', 'Jonathan Sterling', 2, 'Allocated', 1.7, 'Habitat Restoration')
ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- 10. CULTURAL LIVING HERITAGE ORAL RECORDS (Multi-Vocal RAG)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.cultural_oral_records (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    location TEXT NOT NULL,
    elder_name TEXT NOT NULL,
    community_name TEXT NOT NULL,
    language TEXT NOT NULL DEFAULT 'ChiShona',
    audio_duration TEXT NOT NULL,
    audio_url TEXT NOT NULL,
    transcript TEXT NOT NULL,
    spiritual_context TEXT NOT NULL,
    royalty_earned_usd NUMERIC(10, 2) NOT NULL DEFAULT 0.0,
    total_listens INTEGER NOT NULL DEFAULT 0,
    cover_image_url TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ==============================================================================
-- 11. UNIVERSAL ACCESSIBILITY & MOBILITY GIS
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.accessibility_features (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    destination_name TEXT NOT NULL,
    location TEXT NOT NULL,
    grade TEXT NOT NULL DEFAULT 'grade1',
    slope_incline_pct NUMERIC(5, 2) NOT NULL DEFAULT 0.0,
    step_count INTEGER NOT NULL DEFAULT 0,
    has_tactile_paving BOOLEAN NOT NULL DEFAULT false,
    has_accessible_ablution BOOLEAN NOT NULL DEFAULT true,
    has_audio_guide BOOLEAN NOT NULL DEFAULT true,
    has_mounting_platform BOOLEAN NOT NULL DEFAULT false,
    latitude NUMERIC(10, 6) NOT NULL,
    longitude NUMERIC(10, 6) NOT NULL,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ==============================================================================
-- 12. ECONOMIC LEAKAGE & LOCAL RETENTION LOGS (ZTA National Intelligence)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.economic_leakage_logs (
    id TEXT PRIMARY KEY,
    region TEXT NOT NULL,
    average_daily_tourist_spend_usd NUMERIC(10, 2) NOT NULL,
    local_resident_retention_usd NUMERIC(10, 2) NOT NULL,
    foreign_ota_leakage_usd NUMERIC(10, 2) NOT NULL,
    campfire_community_share_usd NUMERIC(10, 2) NOT NULL,
    direct_informal_sme_spend_usd NUMERIC(10, 2) NOT NULL,
    key_bottleneck TEXT NOT NULL,
    intervention_strategy TEXT NOT NULL,
    recorded_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ==============================================================================
-- 13. INFORMAL COMMUNITY SME PROVIDERS
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.sme_providers (
    id TEXT PRIMARY KEY,
    business_name TEXT NOT NULL,
    category TEXT NOT NULL,
    location TEXT NOT NULL,
    owner_name TEXT NOT NULL,
    whatsapp_number TEXT NOT NULL,
    starting_price_usd NUMERIC(10, 2) NOT NULL,
    price_unit TEXT NOT NULL DEFAULT 'per booking',
    rating NUMERIC(3, 2) NOT NULL DEFAULT 5.0,
    review_count INTEGER NOT NULL DEFAULT 1,
    is_zta_registered BOOLEAN NOT NULL DEFAULT true,
    is_eco_certified BOOLEAN NOT NULL DEFAULT true,
    description TEXT NOT NULL,
    image_url TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Realtime & RLS Policies for New Tables
ALTER TABLE public.cultural_oral_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.accessibility_features ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.economic_leakage_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sme_providers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public Read Cultural" ON public.cultural_oral_records FOR SELECT USING (true);
CREATE POLICY "Public Read Accessibility" ON public.accessibility_features FOR SELECT USING (true);
CREATE POLICY "Public Read Leakage" ON public.economic_leakage_logs FOR SELECT USING (true);
CREATE POLICY "Public Read SMEs" ON public.sme_providers FOR SELECT USING (true);
CREATE POLICY "Allow Insert SMEs" ON public.sme_providers FOR INSERT WITH CHECK (true);

ALTER PUBLICATION supabase_realtime ADD TABLE public.cultural_oral_records;
ALTER PUBLICATION supabase_realtime ADD TABLE public.sme_providers;

