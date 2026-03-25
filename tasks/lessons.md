# PURC - Lecciones Aprendidas

*Este archivo se actualiza tras resolver bugs difíciles o tomar decisiones arquitectónicas clave. Ambos desarrolladores deben leerlo al inicio de cada sesión.*

## Decisiones Arquitectónicas
- **2026-03-24:** Se eligió Supabase como BaaS para evitar gestionar servidores. Prohibido Docker, Nginx, AWS EC2.
- **2026-03-24:** Las empresas externas de servicios públicos interactúan mediante "Magic Link" (enlace web temporal sin login), no con una app propia.
- **2026-03-24:** El ciudadano NO puede reabrir un caso. Solo califica (1-5 estrellas) y deja un comentario de máx. 140 caracteres.
- **2026-03-24:** La clasificación con IA se implementará POST-PILOTO. Por ahora, la categorización es manual por el ciudadano.
- **2026-03-24:** El municipio piloto se llama "Municipio Demo" (se cambia con un simple UPDATE en Supabase cuando tengamos municipio real).
- **2026-03-24:** Se arranca con 3 categorías básicas: Bache, Luminaria rota, Basura acumulada. Se agregan más después.
- **2026-03-24:** El SQL de setup (`supabase_setup.sql`) incluye TODO en un solo archivo: tablas, índices, triggers, RLS y datos iniciales. Se ejecuta de una vez en Supabase SQL Editor.
- **2026-03-24:** El trigger `handle_new_user` crea automáticamente un perfil de "citizen" al registrarse. No hace falta insertar en `profiles` manualmente.
- **2026-03-24:** El trigger `increment_upvote_count` actualiza automáticamente el campo `upvote_count` en `reports` al insertar en `report_upvotes`.
- **2026-03-24:** Realtime habilitado en `reports`, `notifications` y `status_history` para que el Dashboard Web se actualice sin refrescar.

## Configuración del Entorno
- **2026-03-24:** Supabase URL: `https://fwfyriatbonqdcgwietn.supabase.co`
- **2026-03-24:** Las credenciales (anon key) van en `.env` (mobile) y `.env.local` (web). NUNCA se suben a GitHub.
- **2026-03-24:** Archivos `.env.example` sirven como plantilla para nuevos desarrolladores.
- **2026-03-24:** En purc-mobile, `supabase.ts` usa AsyncStorage para persistir la sesión del usuario.
- **2026-03-24:** En purc-web, `supabase.ts` usa el cliente básico sin SSR (se puede mejorar después con `@supabase/ssr`).

## Estructura de Carpetas
- **2026-03-24:** Todo el proyecto vive dentro de `StudioProjects/PURC/` con 3 subcarpetas:
  - `purc-docs/` → Documentación y contexto para la IA
  - `purc-mobile/` → App ciudadana (Expo + React Native)
  - `purc-web/` → Dashboard municipal (Next.js + Tailwind)

## Bugs Resueltos
*(Vacío por ahora — se llenará cuando empecemos a codear)*
