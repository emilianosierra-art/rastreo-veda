-- ============================================================
--  Rastreo de personal (veda) — esquema Supabase
--  Pegar y ejecutar en: Supabase → SQL Editor → New query → Run
--
--  NO toca las tablas de ControlObra: esas viven en el schema `obra`;
--  esto solo agrega la tabla `posiciones` en el schema `public`.
-- ============================================================

-- Última posición de cada dispositivo (una fila por dispositivo).
-- "Solo en vivo": no se guarda historial, se sobrescribe la posición.
create table if not exists public.posiciones (
  unit_id     text primary key,            -- id del dispositivo (lo genera la app)
  referencia  text,                        -- nombre de la visita (ej: "Visita semanal · Chalet 4")
  tipo        text,                         -- tipo del vehículo principal (para el ícono)
  vehiculos   text,                         -- JSON: [{ "tipo": "...", "nombre": "...", "personas": ["..."] }]
  personas    text,                         -- JSON: lista plana de todas las personas
  lat         double precision,
  lng         double precision,
  rumbo       double precision,             -- heading (puede venir null)
  velocidad   double precision,             -- speed   (puede venir null)
  exactitud   double precision,             -- accuracy en metros
  actualizado timestamptz default now(),
  activo      boolean default true
);

-- Permisos de fila (RLS). Lectura/escritura pública: alcanza para una herramienta
-- interna chica. La "seguridad" real es que el link y la anon key no son públicos.
alter table public.posiciones enable row level security;

drop policy if exists "lectura publica"  on public.posiciones;
drop policy if exists "alta publica"     on public.posiciones;
drop policy if exists "update publico"   on public.posiciones;

create policy "lectura publica" on public.posiciones for select using (true);
create policy "alta publica"    on public.posiciones for insert with check (true);
create policy "update publico"  on public.posiciones for update using (true) with check (true);

-- GRANT explícito a los roles del cliente. ¡No omitir!
-- (Sin esto la app puede fallar en silencio aunque la policy esté bien.)
grant select, insert, update on public.posiciones to anon, authenticated;

-- Habilitar Realtime para que el visor reciba los cambios al instante.
alter publication supabase_realtime add table public.posiciones;
