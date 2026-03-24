# PURC - Plan de Arquitectura Inicial

## ✅ Confirmación de Lectura del [claude.md](file:///c:/Users/Pablo/Desktop/6_Personal/13-%20Proyectos/PURC/claude.md)

He leído y entendido las reglas. Resumen de restricciones técnicas:

- **PROHIBIDO:** Docker, Nginx, AWS EC2, Kubernetes, Redis, Reverse Proxy, o cualquier servidor autogestionado.
- **OBLIGATORIO:** Supabase (BD + Auth + Storage), Next.js + Tailwind + shadcn/ui (Web), React Native + Expo (Móvil), Vercel (Deploy Web), GitHub (Código).
- **Arquitectura:** Todo debe ser Multi-Tenant con `municipality_id` desde el día 1.
- **Código:** Siempre con `console.log()` y `try/catch`. Explicar como si fuéramos principiantes.
- **Workflow:** Planificar antes de codear. Mantener `tasks/todo.md` y `tasks/lessons.md`.

---

## 1. Estructura de Repositorios

Dos repositorios completamente separados en GitHub. Ambos se conectan al **mismo proyecto de Supabase**.

### Repositorio 1: `purc-mobile` (Desarrollador 1)

**Comando para crear el proyecto (Windows - PowerShell):**
```powershell
# 1. Ir a la carpeta donde quieras guardar el proyecto
cd C:\Users\TuNombre\Proyectos

# 2. Crear el proyecto Expo con TypeScript
npx -y create-expo-app@latest purc-mobile --template blank-typescript

# 3. Entrar a la carpeta del proyecto
cd purc-mobile

# 4. Instalar las dependencias esenciales de Supabase
npx expo install @supabase/supabase-js @react-native-async-storage/async-storage

# 5. Instalar navegación entre pantallas
npx expo install @react-navigation/native @react-navigation/native-stack react-native-screens react-native-safe-area-context

# 6. Instalar cámara y ubicación GPS
npx expo install expo-camera expo-location expo-image-picker

# 7. Instalar mapas
npx expo install react-native-maps

# 8. Inicializar Git y hacer el primer guardado
git init
git add .
git commit -m "feat: proyecto Expo inicial con Supabase, cámara, GPS y mapas"
```

### Repositorio 2: `purc-web` (Desarrollador 2)

**Comando para crear el proyecto (Windows - PowerShell):**
```powershell
# 1. Ir a la carpeta donde quieras guardar el proyecto
cd C:\Users\TuNombre\Proyectos

# 2. Crear el proyecto Next.js con TypeScript, Tailwind, ESLint y App Router
npx -y create-next-app@latest purc-web --typescript --tailwind --eslint --app --src-dir --use-npm

# 3. Entrar a la carpeta del proyecto
cd purc-web

# 4. Instalar componentes visuales premium (shadcn/ui)
npx -y shadcn@latest init -d

# 5. Instalar Supabase para conectar con la base de datos
npm install @supabase/supabase-js @supabase/ssr

# 6. Instalar librería de mapas (Leaflet, gratuita, sin API key)
npm install leaflet react-leaflet
npm install -D @types/leaflet

# 7. Instalar librería de gráficos para el dashboard de KPIs
npm install recharts

# 8. Inicializar Git y hacer el primer guardado
git init
git add .
git commit -m "feat: proyecto Next.js inicial con Supabase, shadcn, mapas y gráficos"
```

---

## 2. Diseño de Base de Datos en Supabase (SQL)

> [!IMPORTANT]
> Este SQL se ejecuta en el **Editor SQL de Supabase** (Interfaz web > SQL Editor > New Query > Pegar > Run). No necesitan instalar nada en sus PCs.

### Habilitar PostGIS (para coordenadas GPS)
```sql
CREATE EXTENSION IF NOT EXISTS postgis;
```

### Tabla: `municipalities` (Los municipios clientes)
```sql
CREATE TABLE municipalities (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,                    -- "Municipalidad de Godoy Cruz"
  province TEXT,                         -- "Mendoza"
  country TEXT DEFAULT 'Argentina',
  contact_email TEXT,
  logo_url TEXT,                         -- Logo para la app
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

### Tabla: `profiles` (Usuarios del sistema, extiende Supabase Auth)
```sql
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  municipality_id UUID REFERENCES municipalities(id),
  full_name TEXT NOT NULL,
  phone TEXT,
  role TEXT NOT NULL CHECK (role IN (
    'citizen',           -- Ciudadano que reporta
    'municipal_admin',   -- Administrativo que gestiona
    'municipal_crew',    -- Cuadrilla interna municipal
    'super_admin'        -- Nosotros (los fundadores)
  )),
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

### Tabla: `categories` (Tipos de problema)
```sql
CREATE TABLE categories (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  municipality_id UUID REFERENCES municipalities(id),
  name TEXT NOT NULL,                    -- "Bache", "Luminaria", "Caño roto"
  icon TEXT,                             -- Emoji o nombre de ícono
  default_priority TEXT DEFAULT 'medium' CHECK (default_priority IN ('low', 'medium', 'high', 'critical')),
  sla_hours INT DEFAULT 72,             -- Horas máximas para resolver (SLA)
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

### Tabla: `companies` (Empresas de servicios públicos externas)
```sql
CREATE TABLE companies (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  municipality_id UUID REFERENCES municipalities(id),
  name TEXT NOT NULL,                    -- "Aguas Mendocinas S.A."
  service_type TEXT,                     -- "agua", "gas", "electricidad"
  contact_email TEXT NOT NULL,           -- Donde llega el Magic Link
  sla_hours INT DEFAULT 48,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

### Tabla: `reports` (El corazón del sistema)
```sql
CREATE TABLE reports (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  municipality_id UUID NOT NULL REFERENCES municipalities(id),
  citizen_id UUID NOT NULL REFERENCES profiles(id),
  category_id UUID NOT NULL REFERENCES categories(id),
  company_id UUID REFERENCES companies(id),        -- NULL si es responsabilidad municipal
  
  -- Contenido del reporte
  description TEXT,
  photo_url TEXT NOT NULL,                          -- Foto del problema (Supabase Storage)
  location GEOGRAPHY(POINT, 4326) NOT NULL,         -- Coordenadas GPS (PostGIS)
  address_text TEXT,                                 -- Dirección legible (opcional)
  
  -- Estado y prioridad
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN (
    'pending',         -- Recién creado por el ciudadano
    'assigned',        -- Asignado a cuadrilla o empresa
    'in_progress',     -- Trabajo en curso
    'resolved',        -- Terminado por la cuadrilla/empresa
    'verified',        -- Verificado por el municipio (cierre oficial)
    'closed'           -- Calificado por ciudadano (ciclo completo)
  )),
  priority TEXT DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'critical')),
  
  -- Sistema de "peso" (upvotes de otros ciudadanos)
  upvote_count INT DEFAULT 0,
  
  -- Evidencia de resolución (subida por cuadrilla o Magic Link)
  resolution_photo_url TEXT,
  resolution_gps GEOGRAPHY(POINT, 4326),
  resolution_note TEXT,
  
  -- Magic Link para empresas externas
  magic_link_token UUID,                             -- Token único y temporal
  magic_link_expires_at TIMESTAMPTZ,
  
  -- Calificación ciudadana final
  citizen_rating INT CHECK (citizen_rating BETWEEN 1 AND 5),
  citizen_feedback TEXT CHECK (char_length(citizen_feedback) <= 140),
  
  -- Timestamps
  assigned_at TIMESTAMPTZ,
  resolved_at TIMESTAMPTZ,
  verified_at TIMESTAMPTZ,
  closed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Índice geoespacial (OBLIGATORIO para búsquedas por zona)
CREATE INDEX idx_reports_location ON reports USING GIST (location);

-- Índice para buscar reportes por municipio rápidamente
CREATE INDEX idx_reports_municipality ON reports (municipality_id, status);

-- Índice para buscar Magic Links activos
CREATE INDEX idx_reports_magic_link ON reports (magic_link_token) WHERE magic_link_token IS NOT NULL;
```

### Tabla: `report_upvotes` (Registro de "Likes" / Validaciones ciudadanas)
```sql
CREATE TABLE report_upvotes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  report_id UUID NOT NULL REFERENCES reports(id) ON DELETE CASCADE,
  citizen_id UUID NOT NULL REFERENCES profiles(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(report_id, citizen_id)          -- Un ciudadano solo puede votar 1 vez por reporte
);
```

### Tabla: `status_history` (Trazabilidad de cada cambio de estado)
```sql
CREATE TABLE status_history (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  report_id UUID NOT NULL REFERENCES reports(id) ON DELETE CASCADE,
  old_status TEXT,
  new_status TEXT NOT NULL,
  changed_by UUID REFERENCES profiles(id),
  note TEXT,                              -- "Se envía camión 04", "Derivado a Aguas Mendocinas"
  created_at TIMESTAMPTZ DEFAULT now()
);
```

### Tabla: `notifications` (Inbox de notificaciones en la app)
```sql
CREATE TABLE notifications (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES profiles(id),
  report_id UUID REFERENCES reports(id),
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

---

## 3. Preguntas Antes de Avanzar

Antes de ejecutar este plan, necesito que me confirmes o aclares lo siguiente:

1. **¿Tienen ya creada la cuenta de Supabase y el proyecto "PURC"?** Necesito saber si ya tienen la `URL` y la `Anon Key` para ponerlas en el código.
2. **¿Tienen cuenta de GitHub creada?** Para subir los repositorios `purc-mobile` y `purc-web`.
3. **¿Quién de los dos va a trabajar en qué parte?** (Tú = Móvil o Web) para que en la siguiente sesión personalice las instrucciones.
4. **¿Van a usar el mismo nombre de municipio para el piloto?** (Ej: "Municipalidad de Godoy Cruz") para crear los datos de prueba iniciales.
5. **Categorías iniciales:** ¿Cuáles son los tipos de problema que quieren mostrar en el piloto? Ejemplos: Bache, Luminaria rota, Caño de agua roto, Basura acumulada, Poste caído, etc.
