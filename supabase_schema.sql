-- ==============================================================================
-- PHOENIX FOOD DELIVERY - SUPABASE SCHEMA & SQL EDITOR SCRIPT
-- ==============================================================================
-- قم بنسخ هذا الكود ولصقه في SQL Editor داخل لوحة تحكم Supabase واضغط Run.
-- ==============================================================================

-- 1. تفعيل الإضافات اللازمة
create extension if not exists "uuid-ossp";

-- 2. جدول البروفايلات للمستخدمين (Profiles) مرتبط بـ Supabase Auth
create table if not exists public.profiles (
  id uuid references auth.users(id) on delete cascade primary key,
  full_name text not null,
  email text,
  phone text,
  role text not null check (role in ('customer', 'restaurant', 'driver')),
  avatar_url text,
  restaurant_id text,
  driver_id text,
  phone_verified boolean default false,
  email_verified boolean default false,
  approval_status text default 'approved',
  preferred_language text default 'ar',
  marketing_opt_in boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now())
);

-- 3. جدول المطابخ / التصنيفات (Cuisines / Categories)
create table if not exists public.cuisines (
  id text primary key,
  name text not null,
  emoji text,
  icon_url text,
  sort_order int default 0,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 4. جدول المطاعم (Restaurants)
create table if not exists public.restaurants (
  id text primary key default gen_random_uuid()::text,
  owner_id uuid references auth.users(id) on delete set null,
  name text not null,
  description text,
  phone text,
  image_url text,
  logo_url text,
  rating numeric(3,2) default 5.0,
  review_count int default 0,
  delivery_time_min int default 20,
  delivery_time_max int default 40,
  delivery_fee numeric(10,2) default 20.0,
  distance numeric(5,2) default 1.5,
  is_open boolean default true,
  address text not null,
  lat double precision default 30.0560,
  lng double precision default 31.3300,
  category_ids text[] default '{}',
  cuisine text default '',
  minimum_order numeric(10,2) default 0,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 5. جدول وجبات ومنتجات المطاعم (Products)
create table if not exists public.products (
  id text primary key default gen_random_uuid()::text,
  restaurant_id text references public.restaurants(id) on delete cascade not null,
  category_id text,
  category text,
  name text not null,
  description text,
  price numeric(10,2) not null default 0,
  image_url text,
  is_available boolean default true,
  addons jsonb default '[]'::jsonb,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 6. جدول عناوين التوصيل للعملاء (Addresses)
create table if not exists public.addresses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  label text not null,
  governorate text default 'القاهرة',
  city text default 'القاهرة',
  area text not null,
  street text not null,
  building text,
  building_number text,
  floor text,
  apartment text,
  landmark text,
  notes text,
  lat double precision default 30.0444,
  lng double precision default 31.2357,
  is_default boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 7. جدول بيانات المندوب (Driver Profiles)
create table if not exists public.driver_profiles (
  user_id uuid references auth.users(id) on delete cascade primary key,
  full_name text not null,
  status text default 'pending', -- pending, approved, suspended
  status_reason text,
  avatar_url text,
  is_online boolean default false,
  lat double precision default 30.0444,
  lng double precision default 31.2357,
  rating_avg numeric(3,2) default 5.0,
  rating_count int default 0,
  vehicle jsonb default '{}'::jsonb, -- { vehicle_type, plate_number, model, color }
  earnings numeric(10,2) default 0.0,
  total_deliveries int default 0,
  updated_at timestamp with time zone default timezone('utc'::text, now())
);

-- 8. جدول الطلبات (Orders)
create table if not exists public.orders (
  id text primary key default substring(gen_random_uuid()::text, 1, 8),
  customer_id uuid references auth.users(id) on delete set null,
  customer_name text not null,
  customer_phone text not null,
  restaurant_id text references public.restaurants(id) on delete cascade not null,
  restaurant_name text not null,
  driver_id text,
  driver_name text,
  items jsonb not null default '[]'::jsonb,
  status text not null default 'pending', -- pending, accepted, preparing, ready, driverAssigned, pickedUp, onTheWay, delivered, cancelled
  delivery_address jsonb not null default '{}'::jsonb,
  payment_method text not null default 'الدفع عند الاستلام',
  subtotal numeric(10,2) not null default 0,
  delivery_fee numeric(10,2) not null default 20.0,
  discount numeric(10,2) default 0,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now())
);

-- 9. تفعيل الـ Row Level Security (RLS) وسياسات الأمان
alter table public.profiles enable row level security;
alter table public.cuisines enable row level security;
alter table public.restaurants enable row level security;
alter table public.products enable row level security;
alter table public.addresses enable row level security;
alter table public.driver_profiles enable row level security;
alter table public.orders enable row level security;

-- سياسات عامة للوصول (قراءة للجميع / تعديل للمالك)
create policy "Allow read all profiles" on public.profiles for select using (true);
create policy "Allow users to update own profile" on public.profiles for update using (auth.uid() = id);
create policy "Allow users to insert own profile" on public.profiles for insert with check (auth.uid() = id);

create policy "Allow read all cuisines" on public.cuisines for select using (true);
create policy "Allow read all restaurants" on public.restaurants for select using (true);
create policy "Allow read all products" on public.products for select using (true);

create policy "Allow clients to manage their addresses" on public.addresses for all using (auth.uid() = user_id);

create policy "Allow read all driver profiles" on public.driver_profiles for select using (true);
create policy "Allow drivers to update their profile" on public.driver_profiles for update using (auth.uid() = user_id);

create policy "Allow read orders" on public.orders for select using (
  auth.uid() = customer_id or
  auth.uid()::text = driver_id or
  true -- للتبسيط في التطوير لتتمكن المطاعم والمناديب من رؤية الطلبات
);
create policy "Allow insert orders" on public.orders for insert with check (true);
create policy "Allow update orders" on public.orders for update using (true);

-- 10. إدخال بيانات تجريبية أولية (Seed Data)
insert into public.cuisines (id, name, emoji, sort_order) values
('cat1', 'برجر', '🍔', 1),
('cat2', 'بيتزا', '🍕', 2),
('cat3', 'شاورما', '🌯', 3),
('cat4', 'مشويات', '🍖', 4),
('cat5', 'حلويات', '🍰', 5),
('cat6', 'مشروبات', '🥤', 6),
('cat7', 'وجبات سريعة', '🍟', 7)
on conflict (id) do nothing;

insert into public.restaurants (id, name, description, phone, image_url, logo_url, rating, review_count, delivery_time_min, delivery_time_max, delivery_fee, distance, is_open, address, lat, lng, category_ids, cuisine, minimum_order)
values
('rest1', 'مطعم أبو خالد', 'أشهى المأكولات والمشويات الشرقية والبرجر الطازج', '01022222222', 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500', 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=150', 4.8, 342, 25, 40, 20.0, 1.2, true, 'شارع عباس العقاد، مدينة نصر', 30.0560, 31.3300, array['cat1', 'cat4'], 'مشويات وبرجر', 50.0),
('rest2', 'بيتزا الإيطالي', 'البيتزا الإيطالية الأصلية بالفرن الحجري والجبنة الطبيعية', '01033333333', 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500', 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=150', 4.6, 218, 30, 45, 25.0, 2.5, true, 'شارع التسعين الشمالي، التجمع الخامس', 30.0260, 31.4700, array['cat2'], 'بيتزا إيطالية', 60.0),
('rest3', 'شاورما الشام', 'أصل الشاورما السوري بالثومية والخبز الصاج', '01044444444', 'https://images.unsplash.com/photo-1561651823-34feb02250e4?w=500', 'https://images.unsplash.com/photo-1561651823-34feb02250e4?w=150', 4.9, 510, 20, 35, 15.0, 0.8, true, 'ميدان الحصري، 6 أكتوبر', 29.9700, 30.9500, array['cat3', 'cat7'], 'شاورما سوري', 40.0)
on conflict (id) do nothing;

insert into public.products (id, restaurant_id, category_id, category, name, description, price, image_url, is_available)
values
('p1', 'rest1', 'cat1', 'برجر', 'برجر لحم فاخر', 'قطعة لحم أنجوس مشوية مع صوص خاص وخس وجبنة شيدر وبصل مكرمل', 120.0, 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400', true),
('p2', 'rest1', 'cat1', 'برجر', 'برجر دجاج مقرمش', 'صدور دجاج كرسبي مع صوص الرانش والخس وصلصة الباربكيو', 95.0, 'https://images.unsplash.com/photo-1625813506062-0aeb1d7a094b?w=400', true),
('p3', 'rest1', 'cat4', 'مشويات', 'شيش طاووق مشوي', 'أسياخ دجاج متبلة ومشوية على الفحم مع الأرز والخضار', 140.0, 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400', true),
('p4', 'rest1', 'cat6', 'مشروبات', 'كوكاكولا كانز', 'مشروب غازي بارد منعش 330 مل', 20.0, 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=400', true)
on conflict (id) do nothing;
