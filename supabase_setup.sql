-- ============================================================
-- PURC - Setup Completo de Base de Datos en Supabase
-- ============================================================
-- INSTRUCCIONES:
-- 1. Ve a https://supabase.com → Tu proyecto PURC
-- 2. Clic en "SQL Editor" (menú izquierdo)
-- 3. Clic en "New Query"
-- 4. Pega TODO este archivo
-- 5. Clic en "Run" (botón verde arriba a la derecha)
-- 6. Deberías ver "Success. No rows returned" — eso es CORRECTO
-- ============================================================


-- ============================================================
-- PASO 1: Habilitar PostGIS (extensión para coordenadas GPS)
-- ============================================================
CREATE EXTENSION IF NOT EXISTS postgis;


-- ============================================================
-- PASO 2: Crear las 8 tablas
-- ============================================================

-- ---- TABLA 1: municipalities (Los municipios clientes) ----
CREATE TABLE municipalities (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  province TEXT,
  country TEXT DEFAULT 'Argentina',
  contact_email TEXT,
  logo_url TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ---- TABLA 2: profiles (Usuarios del sistema) ----
-- Se conecta automáticamente con Supabase Auth
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  municipality_id UUID REFERENCES municipalities(id),
  full_name TEXT NOT NULL,
  phone TEXT,
  role TEXT NOT NULL CHECK (role IN (
    'citizen',
    'municipal_admin',
    'municipal_crew',
    'super_admin'
  )),
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ---- TABLA 3: categories (Tipos de problema) ----
CREATE TABLE categories (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  municipality_id UUID REFERENCES municipalities(id),
  name TEXT NOT NULL,
  icon TEXT,
  default_priority TEXT DEFAULT 'medium' CHECK (default_priority IN ('low', 'medium', 'high', 'critical')),
  sla_hours INT DEFAULT 72,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ---- TABLA 4: companies (Empresas de servicios públicos) ----
CREATE TABLE companies (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  municipality_id UUID REFERENCES municipalities(id),
  name TEXT NOT NULL,
  service_type TEXT,
  contact_email TEXT NOT NULL,
  sla_hours INT DEFAULT 48,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ---- TABLA 5: reports (El corazón del sistema) ----
CREATE TABLE reports (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  municipality_id UUID NOT NULL REFERENCES municipalities(id),
  citizen_id UUID NOT NULL REFERENCES profiles(id),
  category_id UUID NOT NULL REFERENCES categories(id),
  company_id UUID REFERENCES companies(id),

  -- Contenido del reporte
  description TEXT,
  photo_url TEXT NOT NULL,
  location GEOGRAPHY(POINT, 4326) NOT NULL,
  address_text TEXT,

  -- Estado y prioridad
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN (
    'pending',
    'assigned',
    'in_progress',
    'resolved',
    'verified',
    'closed'
  )),
  priority TEXT DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'critical')),

  -- Upvotes
  upvote_count INT DEFAULT 0,

  -- Evidencia de resolución
  resolution_photo_url TEXT,
  resolution_gps GEOGRAPHY(POINT, 4326),
  resolution_note TEXT,

  -- Magic Link
  magic_link_token UUID,
  magic_link_expires_at TIMESTAMPTZ,

  -- Calificación ciudadana
  citizen_rating INT CHECK (citizen_rating BETWEEN 1 AND 5),
  citizen_feedback TEXT CHECK (char_length(citizen_feedback) <= 140),

  -- Timestamps
  assigned_at TIMESTAMPTZ,
  resolved_at TIMESTAMPTZ,
  verified_at TIMESTAMPTZ,
  closed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ---- TABLA 6: report_upvotes (Validaciones ciudadanas) ----
CREATE TABLE report_upvotes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  report_id UUID NOT NULL REFERENCES reports(id) ON DELETE CASCADE,
  citizen_id UUID NOT NULL REFERENCES profiles(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(report_id, citizen_id)
);

-- ---- TABLA 7: status_history (Trazabilidad de cambios) ----
CREATE TABLE status_history (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  report_id UUID NOT NULL REFERENCES reports(id) ON DELETE CASCADE,
  old_status TEXT,
  new_status TEXT NOT NULL,
  changed_by UUID REFERENCES profiles(id),
  note TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ---- TABLA 8: notifications (Notificaciones in-app) ----
CREATE TABLE notifications (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES profiles(id),
  report_id UUID REFERENCES reports(id),
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);


-- ============================================================
-- PASO 3: Crear índices (hacen que las búsquedas sean rápidas)
-- ============================================================

-- Índice geoespacial para buscar reportes por zona en el mapa
CREATE INDEX idx_reports_location ON reports USING GIST (location);

-- Índice para filtrar reportes por municipio y estado
CREATE INDEX idx_reports_municipality ON reports (municipality_id, status);

-- Índice para encontrar Magic Links activos rápidamente
CREATE INDEX idx_reports_magic_link ON reports (magic_link_token) WHERE magic_link_token IS NOT NULL;

-- Índice para buscar notificaciones no leídas de un usuario
CREATE INDEX idx_notifications_user ON notifications (user_id, is_read);

-- Índice para buscar el historial de un reporte
CREATE INDEX idx_status_history_report ON status_history (report_id);

-- Índice para buscar upvotes de un reporte
CREATE INDEX idx_upvotes_report ON report_upvotes (report_id);


-- ============================================================
-- PASO 4: Función automática para crear perfil al registrarse
-- ============================================================
-- Cuando alguien se registra en la app, esto le crea
-- automáticamente un perfil de "citizen" sin que haga nada extra.

CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = ''
AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, role, municipality_id)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data ->> 'full_name', 'Usuario'),
    COALESCE(NEW.raw_user_meta_data ->> 'role', 'citizen'),
    (NEW.raw_user_meta_data ->> 'municipality_id')::UUID
  );
  RETURN NEW;
EXCEPTION
  WHEN others THEN
    RAISE LOG 'Error en handle_new_user: %', SQLERRM;
    RETURN NEW;
END;
$$;

-- Trigger: se ejecuta automáticamente después de cada registro
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();


-- ============================================================
-- PASO 5: Función para incrementar upvotes automáticamente
-- ============================================================

CREATE OR REPLACE FUNCTION increment_upvote_count()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = ''
AS $$
BEGIN
  UPDATE public.reports
  SET upvote_count = upvote_count + 1
  WHERE id = NEW.report_id;
  RETURN NEW;
EXCEPTION
  WHEN others THEN
    RAISE LOG 'Error en increment_upvote_count: %', SQLERRM;
    RETURN NEW;
END;
$$;

CREATE TRIGGER on_upvote_created
  AFTER INSERT ON report_upvotes
  FOR EACH ROW EXECUTE FUNCTION increment_upvote_count();


-- ============================================================
-- PASO 6: Habilitar Realtime en tablas clave
-- ============================================================
-- Esto permite que el Dashboard Web vea reportes nuevos
-- sin tener que refrescar la página (magia de Supabase).

ALTER PUBLICATION supabase_realtime ADD TABLE reports;
ALTER PUBLICATION supabase_realtime ADD TABLE notifications;
ALTER PUBLICATION supabase_realtime ADD TABLE status_history;


-- ============================================================
-- PASO 7: Políticas RLS (Row Level Security)
-- ============================================================
-- Esto es la SEGURIDAD del sistema. Asegura que:
-- - Un ciudadano solo ve SUS reportes y los de su municipio
-- - Un admin municipal solo ve los de SU municipio
-- - Nadie puede hackear y ver datos de otro municipio

-- Habilitar RLS en todas las tablas
ALTER TABLE municipalities ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE report_upvotes ENABLE ROW LEVEL SECURITY;
ALTER TABLE status_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Función auxiliar: obtener el municipality_id del usuario logueado
CREATE OR REPLACE FUNCTION get_my_municipality_id()
RETURNS UUID
LANGUAGE sql
STABLE
SECURITY DEFINER SET search_path = ''
AS $$
  SELECT municipality_id FROM public.profiles WHERE id = auth.uid();
$$;

-- Función auxiliar: obtener el rol del usuario logueado
CREATE OR REPLACE FUNCTION get_my_role()
RETURNS TEXT
LANGUAGE sql
STABLE
SECURITY DEFINER SET search_path = ''
AS $$
  SELECT role FROM public.profiles WHERE id = auth.uid();
$$;

-- ---- POLÍTICAS: municipalities ----
-- Todos pueden ver municipios activos (necesario para la pantalla de registro)
CREATE POLICY "Municipios visibles para todos"
  ON municipalities FOR SELECT
  USING (is_active = true);

-- Solo super_admin puede modificar municipios
CREATE POLICY "Solo super_admin modifica municipios"
  ON municipalities FOR ALL
  USING (get_my_role() = 'super_admin');

-- ---- POLÍTICAS: profiles ----
-- Cada usuario puede ver su propio perfil
CREATE POLICY "Ver mi perfil"
  ON profiles FOR SELECT
  USING (id = auth.uid());

-- Admins municipales pueden ver perfiles de su municipio
CREATE POLICY "Admin ve perfiles de su municipio"
  ON profiles FOR SELECT
  USING (
    municipality_id = get_my_municipality_id()
    AND get_my_role() IN ('municipal_admin', 'super_admin')
  );

-- Cada usuario puede actualizar su propio perfil
CREATE POLICY "Actualizar mi perfil"
  ON profiles FOR UPDATE
  USING (id = auth.uid())
  WITH CHECK (id = auth.uid());

-- Permitir insertar perfil propio (necesario para el trigger)
CREATE POLICY "Insertar perfil propio"
  ON profiles FOR INSERT
  WITH CHECK (true);

-- ---- POLÍTICAS: categories ----
-- Todos ven las categorías de su municipio
CREATE POLICY "Ver categorías de mi municipio"
  ON categories FOR SELECT
  USING (municipality_id = get_my_municipality_id());

-- Solo admin puede gestionar categorías
CREATE POLICY "Admin gestiona categorías"
  ON categories FOR ALL
  USING (
    municipality_id = get_my_municipality_id()
    AND get_my_role() IN ('municipal_admin', 'super_admin')
  );

-- ---- POLÍTICAS: companies ----
-- Admin y crew ven empresas de su municipio
CREATE POLICY "Ver empresas de mi municipio"
  ON companies FOR SELECT
  USING (municipality_id = get_my_municipality_id());

-- Solo admin gestiona empresas
CREATE POLICY "Admin gestiona empresas"
  ON companies FOR ALL
  USING (
    municipality_id = get_my_municipality_id()
    AND get_my_role() IN ('municipal_admin', 'super_admin')
  );

-- ---- POLÍTICAS: reports ----
-- Ciudadanos ven reportes de su municipio (para el mapa anti-duplicados)
CREATE POLICY "Ciudadano ve reportes de su municipio"
  ON reports FOR SELECT
  USING (municipality_id = get_my_municipality_id());

-- Ciudadanos pueden crear reportes en su municipio
CREATE POLICY "Ciudadano crea reporte"
  ON reports FOR INSERT
  WITH CHECK (
    municipality_id = get_my_municipality_id()
    AND citizen_id = auth.uid()
  );

-- Admin/crew pueden actualizar reportes de su municipio
CREATE POLICY "Admin actualiza reportes"
  ON reports FOR UPDATE
  USING (
    municipality_id = get_my_municipality_id()
    AND get_my_role() IN ('municipal_admin', 'municipal_crew', 'super_admin')
  );

-- Ciudadano puede actualizar solo calificación de su propio reporte
CREATE POLICY "Ciudadano califica su reporte"
  ON reports FOR UPDATE
  USING (
    citizen_id = auth.uid()
    AND status = 'verified'
  )
  WITH CHECK (
    citizen_id = auth.uid()
  );

-- ---- POLÍTICAS: report_upvotes ----
-- Ver upvotes de reportes de mi municipio
CREATE POLICY "Ver upvotes de mi municipio"
  ON report_upvotes FOR SELECT
  USING (
    report_id IN (SELECT id FROM reports WHERE municipality_id = get_my_municipality_id())
  );

-- Ciudadano puede votar reportes de su municipio
CREATE POLICY "Ciudadano puede votar"
  ON report_upvotes FOR INSERT
  WITH CHECK (citizen_id = auth.uid());

-- ---- POLÍTICAS: status_history ----
-- Ver historial de reportes de mi municipio
CREATE POLICY "Ver historial de mi municipio"
  ON status_history FOR SELECT
  USING (
    report_id IN (SELECT id FROM reports WHERE municipality_id = get_my_municipality_id())
  );

-- Admin/crew pueden insertar cambios de estado
CREATE POLICY "Admin registra cambios de estado"
  ON status_history FOR INSERT
  WITH CHECK (
    get_my_role() IN ('municipal_admin', 'municipal_crew', 'super_admin')
  );

-- ---- POLÍTICAS: notifications ----
-- Cada usuario ve solo sus notificaciones
CREATE POLICY "Ver mis notificaciones"
  ON notifications FOR SELECT
  USING (user_id = auth.uid());

-- El sistema puede crear notificaciones (vía service_role)
CREATE POLICY "Sistema crea notificaciones"
  ON notifications FOR INSERT
  WITH CHECK (true);

-- Usuario puede marcar sus notificaciones como leídas
CREATE POLICY "Marcar notificación como leída"
  ON notifications FOR UPDATE
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());


-- ============================================================
-- PASO 8: Datos iniciales (Municipio Demo + Categorías)
-- ============================================================

-- Insertar el municipio de prueba
INSERT INTO municipalities (name, province, country, contact_email)
VALUES ('Municipio Demo', 'Demo', 'Argentina', 'demo@purc.app');

-- Insertar las 3 categorías básicas para el piloto
-- (usamos el ID del municipio que acabamos de crear)
INSERT INTO categories (municipality_id, name, icon, default_priority, sla_hours)
SELECT
  m.id,
  c.name,
  c.icon,
  c.priority,
  c.sla
FROM municipalities m
CROSS JOIN (
  VALUES
    ('Bache',            '🕳️', 'high',   48),
    ('Luminaria rota',   '💡', 'medium', 72),
    ('Basura acumulada', '🗑️', 'medium', 24)
) AS c(name, icon, priority, sla)
WHERE m.name = 'Municipio Demo';


-- ============================================================
-- ¡LISTO! Si ves "Success" arriba, tu base de datos está lista.
-- Ahora ve a Authentication > Settings y habilita Email + Google.
-- ============================================================
