# PURC - Lista de Tareas (Todo)

## Fase 0: Planificación y Arquitectura
- [x] Leer y entender `claude.md`, `PURC_Plan_Desarrollo_IA_V2.md`, `Flujo_Core_PURC.md`
- [x] Diseñar esquema SQL completo (8 tablas con Multi-Tenant, PostGIS, Upvotes, Magic Link)
- [x] Definir comandos exactos para inicializar `purc-mobile` (Expo) y `purc-web` (Next.js)
- [ ] Resolver las 5 preguntas pendientes con los fundadores
- [ ] Ejecutar los comandos de creación de ambos proyectos

## Fase 1: Setup de Supabase y Repositorios (Semanas 1-2)
- [ ] Crear cuenta Supabase y proyecto "PURC"
- [ ] Ejecutar SQL de creación de tablas en Supabase SQL Editor
- [ ] Habilitar PostGIS en Supabase
- [ ] Configurar Supabase Auth (Email + Google)
- [ ] Crear bucket de Storage para fotos de reportes
- [ ] Configurar RLS (Row Level Security) en todas las tablas
- [ ] Inicializar repo `purc-mobile` con Expo
- [ ] Inicializar repo `purc-web` con Next.js
- [ ] Subir ambos repos a GitHub

## Fase 2: Desarrollo Paralelo (Semanas 3-6)
- [ ] **App Móvil:** Login/Registro con Supabase Auth
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
