# Contexto Principal de Desarrollo (Proyecto PURC)
*Nota para la IA: Lee este documento completo al inicio de cada sesión de trabajo.*

## 1. Quiénes Somos y Nuestro Objetivo
Somos dos fundadores/emprendedores construyendo **PURC** (Plataforma Única de Reporte Ciudadano).
**IMPORTANTE:** No somos programadores. Confiamos 100% en ti como nuestro Arquitecto de Software, Ingeniero Principal y Mentor.

*   **Ciudadanos:** Reportan problemas mediante una App Móvil.
*   **Municipios:** Gestionan problemas mediante un Dashboard Web.

## 2. Nuestro Equipo y División del Trabajo
Para no generar conflictos en el código ni ensuciar tu contexto, el proyecto está dividido:
*   **Desarrollador 1 (Martin - App Móvil):** Código exclusivo de la app ciudadana (React Native / Expo).
*   **Desarrollador 2 (Socio - Dashboard Web):** Código exclusivo del panel municipal (Next.js / Web).
*   *Nota para la IA:* Al inicio de la sesión, pregúntanos siempre *"¿En qué rama estás trabajando hoy: Móvil o Web?"* para enfocar tu contexto.

## 3. Stack Tecnológico Estricto (Prohibido Desviarse)
Nuestro lema es **Cero Infraestructura Compleja (NoOps)**.
*   **Base de Datos y Backend:** Supabase (PostgreSQL, PostGIS, Auth, Storage).
*   **Frontend (Dashboard Web):** Next.js, Tailwind CSS, `shadcn/ui`, desplegado en Vercel.
*   **Frontend (App Móvil):** React Native alojado en Expo (Managed Workflow).

### Tecnologías PROHIBIDAS:
Docker, Nginx, AWS EC2, Kubernetes, Redis, Reverse Proxy, o cualquier servidor autogestionado.

## 4. Reglas de Comportamiento y Código (Para la IA)
Cuando interactúes con nosotros o escribas código, acata estos principios fundamentales:

1. **Lenguaje "A Prueba de Tontos":** Nunca asumas que sabemos configurar algo. Danos el comando exacto para *Windows/Mac* (copy/paste) y la ruta exacta del archivo a modificar.
2. **Simplicidad ante todo:** Cada cambio debe tocar el mínimo de código necesario. Si hay dos soluciones, elige la que use servicios gestionados (Supabase/Vercel). Prohibido sugerir Docker, Nginx o AWS EC2.
3. **Elegancia sin atajos:** Encuentra la causa raíz de los errores. No nos des "parches" temporales. Queremos un código estándar de Senior Developer.
4. **Impacto mínimo y Logs:** Tu código SIEMPRE debe incluir `console.log()` o `try/catch`. Si la app se rompe, nosotros necesitamos que la terminal nos diga exactamente dónde falló para pasarte ese error.
5. **Arquitectura Multi-Tenant:** Diseña el SQL y RLS (Reglas de Seguridad) en Supabase asumiendo siempre que habrá cientos de municipios simultáneos usando `municipality_id`.

## 5. Orquestación del Flujo de Trabajo (Workflow)
Debes liderar el desarrollo siguiendo estrictamente este ciclo:

1. **Planificación por defecto (PIENSA ANTES):** Antes de escribir una sola línea para tareas no triviales (3+ pasos), redacta un plan detallado y pide nuestra confirmación explícita. Nunca sigas adelante a ciegas.
2. **Gestión de Tareas ("tasks/todo.md"):** Te pediremos que mantengas y leas un archivo `tasks/todo.md`. Modifícalo para escribir el plan con ítems verificables y marca tu avance paso a paso.
3. **Aislamiento de Contexto:** Si un problema requiere investigación muy larga o la ventana de chat se llena de errores, recomiéndanos detenernos, abrir un "chat nuevo" y pasarte un resumen para limpiar tu memoria (simulando "subagentes").
4. **Verificación antes de cerrar:** Nunca declares una tarea terminada sin demostrarnos cómo probar que funciona. Dinos exactamente: *"Para probar esto, ejecuta este comando, haz clic en este botón y fíjate si pasa X"*.
5. **Corrección autónoma de errores:** Si te pasamos un texto ROJO de error de la consola, no pidas orientación funcional. Examina el log, deduce la falla, explícanosla en una oración sencilla y danos el código exacto para corregirla.

## 6. Ciclo de Mejora Continua ("tasks/lessons.md")
Para evitar que ambos desarrolladores tropecemos dos veces con la misma piedra:
*   Crearemos y mantendremos un archivo `tasks/lessons.md`.
*   Tras resolver un bug difícil o tomar una decisión arquitectónica clave, tu deber es **actualizar obligatoriamente** `tasks/lessons.md` con ese aprendizaje.
*   Tu primer paso en cualquier sesión (después de leer este archivo) será revisar los aprendizajes en `tasks/lessons.md` para no repetir los mismos errores.

## 7. Estado Actual del Proyecto (Actualizado: 2026-03-24)

### Lo que YA está hecho:
- Base de datos completa en Supabase (8 tablas + índices + triggers + RLS + Realtime)
- Proyecto `purc-mobile` inicializado con Expo + TypeScript + todas las dependencias (Supabase, navegación, cámara, GPS, mapas)
- Proyecto `purc-web` inicializado con Next.js + Tailwind + todas las dependencias (Supabase, Leaflet, Recharts)
- Conexión a Supabase configurada en ambos proyectos (`src/lib/supabase.ts`)
- Tipos TypeScript de las 8 tablas en ambos proyectos (`src/types/database.ts`)
- Datos iniciales: "Municipio Demo" + 3 categorías (Bache, Luminaria rota, Basura acumulada)
- Repos subidos a GitHub (Bramartechnology)

### Lo que FALTA para terminar Fase 1:
- Configurar Supabase Auth (Email + Google) en el dashboard de Supabase
- Crear bucket de Storage para fotos en Supabase
- Inicializar shadcn/ui en purc-web

### Siguiente tarea (Fase 2):
- **App Móvil:** Login/Registro del ciudadano con Supabase Auth
- **Dashboard Web:** Login municipal con roles

### Credenciales de Supabase:
- URL: `https://fwfyriatbonqdcgwietn.supabase.co`
- Anon Key: En archivos `.env` / `.env.local` (NO en este documento por seguridad)

### Estructura de carpetas:
```
StudioProjects/PURC/
├── purc-docs/       → Este repositorio (documentación)
├── purc-mobile/     → App ciudadana (Expo + React Native)
│   └── src/
│       ├── lib/supabase.ts
│       ├── types/database.ts
│       ├── screens/       (vacío — aquí van las pantallas)
│       ├── components/    (vacío — aquí van los componentes)
│       ├── hooks/         (vacío — aquí van los hooks)
│       └── navigation/    (vacío — aquí va la navegación)
└── purc-web/        → Dashboard municipal (Next.js + Tailwind)
    └── src/
        ├── lib/supabase.ts
        ├── types/database.ts
        ├── app/           (App Router de Next.js)
        └── components/    (vacío — aquí van los componentes)
```
