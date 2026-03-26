# PURC - Lista de Tareas (Todo)
*Última actualización: 2026-03-25 por Martin (Sesión 2)*

## Fase 0: Planificación y Arquitectura — COMPLETADA
- [x] Leer y entender `claude.md`, `PURC_Plan_Desarrollo_IA_V2.md`, `Flujo_Core_PURC.md`
- [x] Diseñar esquema SQL completo (8 tablas con Multi-Tenant, PostGIS, Upvotes, Magic Link)
- [x] Definir comandos exactos para inicializar `purc-mobile` (Expo) y `purc-web` (Next.js)
- [x] Resolver las preguntas pendientes con los fundadores
- [x] Crear organización GitHub `Bramartechnology` con ambos miembros
- [x] Crear repositorio `purc-docs` y subir documentación
- [x] Crear repositorio `purc-mobile` (vacío, listo para inicializar Expo)
- [x] Crear repositorio `purc-web` (vacío, listo para inicializar Next.js)
- [x] Inicializar proyecto Expo dentro de `purc-mobile`
- [x] Downgrade de Expo SDK 55 → SDK 54 (compatibilidad con Expo Go del App Store)
- [x] Inicializar proyecto Next.js dentro de `purc-web`

## Fase 1: Setup de Supabase y Repositorios — EN PROGRESO (80% completada)
- [x] Crear cuenta Supabase y proyecto "PURC"
- [x] Ejecutar SQL de creación de 8 tablas en Supabase SQL Editor (`supabase_setup.sql`)
- [x] Habilitar PostGIS en Supabase (incluido en el SQL)
- [x] Configurar RLS (Row Level Security) en todas las tablas (incluido en el SQL)
- [x] Crear triggers automáticos: handle_new_user + increment_upvote_count
- [x] Habilitar Realtime en reports, notifications, status_history
- [x] Insertar datos iniciales: "Municipio Demo" + 3 categorías (Bache, Luminaria rota, Basura acumulada)
- [x] Inicializar repo `purc-mobile` con Expo + TypeScript + todas las dependencias
- [x] Inicializar repo `purc-web` con Next.js + Tailwind + todas las dependencias
- [x] Configurar `src/lib/supabase.ts` en ambos proyectos (conexión a Supabase)
- [x] Configurar `src/types/database.ts` en ambos proyectos (tipos TypeScript de las 8 tablas)
- [x] Crear `.env` / `.env.local` con credenciales reales
- [x] Crear `.env.example` para que el socio sepa qué variables necesita
- [x] Subir ambos repos a GitHub (Bramartechnology)
- [ ] Configurar Supabase Auth (Email + Google) — **PENDIENTE: hacer en dashboard de Supabase**
- [ ] Crear bucket de Storage para fotos de reportes — **PENDIENTE: hacer en dashboard de Supabase**
- [ ] Inicializar shadcn/ui en purc-web (`npx shadcn@latest init -d`) — **PENDIENTE**

## Fase 2: Desarrollo Paralelo (Semanas 3-6) — PRÓXIMO
- [ ] **App Móvil:** Login/Registro con Supabase Auth ← **SIGUIENTE TAREA**
- [ ] **App Móvil:** Pantalla de mapa con reportes cercanos (anti-duplicados)
- [ ] **App Móvil:** Flujo de captura: Categoría → Foto → GPS → Enviar
- [ ] **App Móvil:** Historial de mis reportes
- [ ] **App Móvil:** Pantalla de calificación (1-5 estrellas + 140 chars)
- [ ] **Dashboard Web:** Login municipal con roles
- [ ] **Dashboard Web:** Panel de KPIs (total, abiertos, resueltos, tiempo promedio)
- [ ] **Dashboard Web:** Mapa interactivo con reportes por estado
- [ ] **Dashboard Web:** Tabla de reportes con filtros
- [ ] **Dashboard Web:** Gestión de reporte (cambiar estado, derivar a empresa)
- [ ] **Dashboard Web:** Página "Magic Link" para empresas externas

## Fase 3: Integración y QA (Semanas 7-8)
- [ ] Probar flujo completo: App → Supabase → Dashboard (Realtime)
- [ ] Probar flujo Magic Link con empresa simulada
- [ ] Probar notificaciones Push (Expo)
- [ ] Verificar RLS: ciudadano NO puede ver reportes de otro municipio

## Fase 4: Multi-Tenant y Escalado (Semanas 9-12)
- [ ] Panel de Super Admin para dar de alta municipios
- [ ] Landing Page pública
- [ ] Deploy en Vercel (producción)
