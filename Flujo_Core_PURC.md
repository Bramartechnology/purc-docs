# 🔄 Flujo Core de Información (Proyecto PURC Mejorado)
*Nota para la IA: Este documento describe el ciclo de vida completo de un reporte, preparado para escalar con Inteligencia Artificial, validación ciudadana, flujos de trabajo de operarios internos y empresas de servicios públicos externos.*

## El Viaje del Reporte (Paso a Paso)

### 1. Prevención de Duplicados y "Upvoting" (App Móvil Ciudadana)
- **Actor:** Ciudadano.
- **Acción (Radar de la zona):** Antes de crear un reporte, la app le muestra al ciudadano un mapa con los desvíos ya reportados en su radio cercano.
- **Bifurcación Anti-Duplicados:**
  - **Si el problema YA está reportado:** El sistema no le permite crear un reporte nuevo. En su lugar, el ciudadano presiona "Validar/Me pasa lo mismo" (similar a un *Like*). Esto le suma "peso" o criticidad al reporte original de cara a la municipalidad.
  - **Si el problema es NUEVO:** Procede al paso 2.

### 2. La Fase de Captura (App Móvil Ciudadana)
- **Actor:** Ciudadano.
- **Acción:** Toma una foto del desvío/incidente, agrega una descripción manual inicial y la envía. El GPS guarda sus coordenadas de forma invisible.
- *Nota de Escalabilidad (Mejora 1):* Tras el piloto, este paso incluirá un módulo de IA que analizará la foto para categorizar antes de llegar al humano.

### 3. Validación y Asignación de Órdenes de Trabajo "OT" (Dashboard Web)
- **Actor:** Administrativo / Operador Municipal.
- **Acción:** Recibe el reporte ordenado en pantalla según su criticidad natural y el "peso" (cantidad de validaciones de otros ciudadanos).
- **Asignación (El Cruce de Caminos):**
  - Si es responsabilidad Municipal: Asigna la tarea a una **Cuadrilla Interna**.
  - Si es responsabilidad Privada (Ej: Agua, Gas, Luz): El administrativo "Deriva" el caso a la empresa correspondiente dentro del panel web.

### 4. Ejecución del Trabajo (Cuadrillas Internas vs Empresas Externas)
Dado que las **Empresas de Servicios Públicos tienen sus propios sistemas de gestión de OTs** y no adoptarán herramientas externas del municipio para sus obreros, este paso maneja la complejidad con una estrategia dividida:
- **Ruta A (Cuadrillas Municipales Internas):** El obrero municipal usa la app interna municipal. Va al lugar, arregla el problema, y obligatoriamente **sube una evidencia fotográfica Y registra su propia geolocalización (GPS)**.
- **Ruta B (Empresas Externas - Solución "Magic Link"):** 
  1. Al derivarse el caso (Paso 3), nuestra plataforma (vía Resend/AWS SES) le dispara un email o mensaje automatizado al despacho de la Compañía Externa.
  2. Este email contiene un **"Enlace Mágico" (Magic Link)** web único, seguro y temporal.
  3. La compañía gestiona el trabajo en su propio software interno con sus cuadrillas como están acostumbrados.
  4. Una vez la cuadrilla externa arregla el pozo o el poste, el despachador (o la misma cuadrilla) hace clic en el *Enlace Mágico*.
  5. Se le abre una página web sencillísima en el navegador que *no requiere contraseña*. Solo tiene un botón para cargar la "Foto Final", solicitar el GPS del navegador, y presionar "Marcar Ticket como Resuelto para la Municipalidad".
  - *Nota Escalamiento Post-Piloto:* Cuando haya presupuesto, el "Magic Link" se puede reemplazar conectando nuestras bases de datos directamente (vía APIs y Webhooks) con el software corporativo (SAP, Salesforce) de cada empresa externa.

### 5. Verificación Municipal (Dashboard Web)
- **Actor:** Administrativo / Operador Municipal.
- **Acción:** Recibe la foto y el GPS (sea de su propio empleado municipal o a través del 'Magic Link' de la empresa privada). Audita visualmente que el trabajo sea real y aprueba el cierre, cambiando el estado a "Resuelto".

### 6. Retroalimentación Ciudadana (App Móvil)
- **Actor:** Ciudadanos (El reportador original y todos los vecinos que dieron "Upvote").
- **Acción:** Reciben una alerta Push: "Tu reporte ha sido resuelto", adjuntando la foto de evidencia.
- **Calificación Exclusiva:** El ciudadano NO tiene la opción de reabrir el caso. Solo cuenta con una pantalla de cierre para calificar con estrellas (1 a 5) y dejar de forma opcional un comentario de máximo 140 caracteres. El ticket se cierra permanentemente.

### 7. Análisis de Datos (Data Analytics)
- Esta métrica transversal es vital. El sistema medirá no solo la velocidad municipal, sino que construirá perfiles de cumplimiento de las **Empresas de Servicios Públicos (SLA)** externas midiendo desde el envío del 'Magic Link' hasta la resolución (esencial para informes, exigencias contractuales o posibles multas de concesión).
