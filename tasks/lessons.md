# PURC - Lecciones Aprendidas

*Este archivo se actualiza tras resolver bugs difíciles o tomar decisiones arquitectónicas clave. Ambos desarrolladores deben leerlo al inicio de cada sesión.*

## Decisiones Arquitectónicas
- **2026-03-24:** Se eligió Supabase como BaaS para evitar gestionar servidores. Prohibido Docker, Nginx, AWS EC2.
- **2026-03-24:** Las empresas externas de servicios públicos interactúan mediante "Magic Link" (enlace web temporal sin login), no con una app propia.
- **2026-03-24:** El ciudadano NO puede reabrir un caso. Solo califica (1-5 estrellas) y deja un comentario de máx. 140 caracteres.
- **2026-03-24:** La clasificación con IA se implementará POST-PILOTO. Por ahora, la categorización es manual por el ciudadano.

## Bugs Resueltos
*(Vacío por ahora — se llenará cuando empecemos a codear)*
