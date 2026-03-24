# PURC: Plataforma Única de Reporte Ciudadano
## Plan de Desarrollo Escalable (V2 - Arquitectura IA & No-Code)

**Resumen Ejecutivo**
Este plan está diseñado específicamente para **dos desarrolladores sin conocimientos previos de programación**, utilizando Agentes de Inteligencia Artificial (IA) como "programadores principales". El objetivo no es solo lograr un MVP, sino establecer una **arquitectura altamente escalable** desde el día 1, capaz de soportar múltiples municipios sin requerir conocimientos complejos de infraestructura o servidores.

---

### 🧠 Principios Fundamentales del Desarrollo con IA

1. **Mentalidad de Product Manager (PM), no de Programador:** Ustedes no escriben código, ustedes diseñan la lógica, los requerimientos y auditan el trabajo de la IA. Sus instrucciones (prompts) son su código fuente.
2. **Cero Infraestructura Compleja (NoOps / Serverless):** Prohibido configurar servidores Linux, Docker, o clústers de AWS manualmente. Se usarán exclusivamente Servicios Gestionados (BaaS) que escalan automáticamente ("con un botón").
3. **Escalabilidad por Defecto (No solo MVP):** La tecnología elegida (Supabase + Vercel) es la misma que usan startups de nivel mundial. El proyecto nace listo para ser *multi-tenant* (soportar cientos de municipios independientes) sin rediseñar la base.
4. **Instrucciones a prueba de tontos ("Prompt Master"):** La regla de oro para interactuar con la IA será: *"Asume que no sé programar. Dime exactamente qué comando copiar y pegar, dónde hacer clic, y en qué archivo exacto pegar el código"*.
5. **Aislamiento de Contexto (Divide y Vencerás):** Para que la IA no se confunda mezclando código web con móvil y ustedes no se "pisen":
   - **Desarrollador 1 + IA:** Dueño exclusivo de la App Móvil Ciudadana.
   - **Desarrollador 2 + IA:** Dueño exclusivo del Dashboard Municipal Web.

---

### 🏗️ Stack Tecnológico Escalable y Orientado a IA

| Capa | Tecnología | Por qué es perfecta para No-Programadores + IA |
| :--- | :--- | :--- |
| **Backend & Base de Datos** | **Supabase** (BaaS) | Reemplaza meses de trabajo tradicional. Te da: Base de Datos (PostgreSQL), Mapas (PostGIS), Autenticación, Subida de Imágenes y APIs de forma automática. Todo con una interfaz visual intuitiva. Escala sin tocar servidores. |
| **Dashboard Municipal** | **Next.js + Tailwind + Vercel** | Vercel aloja páginas web con cero configuración y escala infinito. Para el diseño premium, la IA usará `shadcn/ui` (componentes visuales modernos listos para usar). |
| **App Ciudadana** | **React Native + Expo** | Expo permite ir programando y probando la app en tiempo real en tu teléfono físico escaneando un QR, sin tener que instalar complejos emuladores de Android o XCode. |
| **Control de Versiones** | **GitHub** | Las IAs se conectan directo a GitHub. Es el punto de encuentro donde se guardará todo el avance sin miedo a perderlo. |

---

### 📅 Plan de Acción (Reestructurado)

#### FASE 1: Fundación Sin Código y Setup (Semanas 1-2)
*Ambos trabajan juntos configurando el núcleo del sistema.*

**1. Setup Visual y Cuentas (Sin programar):**
- Crear cuenta en Supabase, crear el proyecto "PURC".
- Crear cuenta en Vercel y GitHub.
- Diseñar las tablas clave en la interfaz visual de Supabase: `users`, `reports` (con PostGIS para ubicación en mapas), `categories`, `municipalities`.

**2. Reglas de Seguridad Base (RLS en Supabase):**
- La seguridad se hace directo en Supabase usando RLS (Row Level Security). Tu prompt a la IA será: *"Dame las reglas SQL para pegar en Supabase y asegurar que un ciudadano solo vea sus reportes y un empleado municipal solo vea los de su zona"*.

**3. Definición del "Master Prompt":**
- Guardar en un bloc de notas un texto que SIEMPRE le pegarán a la IA antes de empezar una nueva sesión de trabajo. Ejemplo:
  > *"Somos dos fundadores sin experiencia en código construyendo una plataforma ciudadana altamente escalable usando React Native, Next.js y Supabase. Tu trabajo es ser nuestro Arquitecto de Software Principal. Explica cada paso como si se lo enseñaras a un principiante total. Dame comandos exactos de terminal. Diseña cada función pensando en que el sistema pueda escalar a cientos de municipios (multi-tenant) sin rehacer código. Nunca asumas que sé configurar algo avanzado. Si hay una forma más fácil e integrada de hacerlo, propón esa."*

#### FASE 2: Desarrollo Paralelo y Construcción (Semanas 3-6)
*División de tareas. Cada uno trabaja interactuando con su IA en proyectos separados que se conectan al mismo Supabase.*

**Equipo 1 (Desarrollador 1 + IA): App Ciudadana (Expo)**
- **Meta:** Una app móvil veloz que toma una foto, obtiene el GPS y la sube a Supabase.
- **Paso 1:** Pedir a la IA: *"¿Cómo instalo Expo en Windows/Mac y creo un proyecto en blanco?"*.
- **Paso 2:** Integrar Login y Registro con Supabase.
- **Paso 3:** Componente de mapa y uso de la cámara del teléfono.
- **Escudos:** Preguntar a la IA siempre *"¿Maneja esto bien la pérdida de conexión a internet?"* (Escalabilidad en la calle).

**Equipo 2 (Desarrollador 2 + IA): Dashboard Municipal (Next.js)**
- **Meta:** Un panel web visualmente de lujo para empleados.
- **Paso 1:** Pedir a la IA: *"Crea un proyecto Next.js y configúralo con shadcn/ui. Dime los comandos"*.
- **Paso 2:** Crear la tabla de reportes en tiempo real que lea directo de Supabase.
- **Paso 3:** Implementar un mapa de calor visual (la IA te dará un componente de Mapbox o Leaflet).
- **Escudos:** Asegurarse de que cada tabla y gráfico se filtre por el `municipality_id` del empleado conectado (Garantía de multitenencia y escalabilidad).

#### FASE 3: Enlace y Control de Calidad Asistido (Semanas 7-8)
- **La Magia en Vivo:** El Dev 1 crea un reporte en el celular, el Dev 2 observa cómo aparece automáticamente en el Dashboard usando *Supabase Realtime* (sin necesidad de refrescar la página).
- **Manejo de Errores con IA:** Si algo falla, el flujo de trabajo es estricto: Copiar el texto rojo del error de la pantalla -> Pegarlo a la IA tal cual -> Modificar el código exacto que la IA devuelve.
- **Notificaciones Escalables:** Integrar Expo Push Notifications. La IA genera el código (Servicio externo) para avisar a miles de ciudadanos simultáneamente cuando su bache sea tapado.

#### FASE 4: Escalado "Multi-Tenant" Comercial (Semanas 9-12)
- El producto está listo. Ahora se le pide a la IA: *"Ayúdame a crear un panel para "Super Administradores" (nosotros) donde podamos dar de alta nuevos municipios de forma rápida"*.
- Se crea la *Landing Page* pública (Next.js) para vender el sistema a diferentes gobiernos, la cual se despliega en Vercel en 2 minutos guiado por la IA.

---

### 🚨 Las 4 Reglas de Supervivencia para Programar con IA

1. **Guardar el Progreso (Commits Frecuentes):** Cada vez que algo en la pantalla funcione (un simple botón, o el login), pide a la IA *"Dime los comandos para guardar esto en GitHub"*. Si la IA rompe todo en el paso siguiente, pueden "volver en el tiempo" fácilmente.
2. **Si el error insiste 3 veces, Detén a la IA:** A veces las IAs se "enredan" intentando arreglar el mismo error y rompen más cosas. Si pasa 3 veces, abre un Chat Nuevo de la IA, pégale el archivo completo problemático y dile: *"Tengo este código y me da este error. Analiza todo el contexto desde cero y dame la solución definitiva"*.
3. **Exige "Logs" para entender qué pasa:** Como no saben cómo depurar código complejo, acostúmbrense a pedirle a la IA: *"Agrega muchos `console.log` a esta función para que, cuando la prueba en la terminal, pueda leer exactamente paso a paso si se están mandando los datos o si falla antes"*.
4. **Rechaza Soluciones Complejas:** Si en algún momento la IA sugiere instalar cosas como *"Redis"*, *"Nginx"*, configurar un *"Reverse Proxy"*, o armar un *"Docker Container"*, dile tajantemente: *"Rompiste el principio NoOps. No sé usar servidores. Consigue el mismo resultado usando funciones nativas de Next.js, Vercel o Supabase"*. ¡La simplicidad es clave para mantener un sistema escalable sin volverse locos!
