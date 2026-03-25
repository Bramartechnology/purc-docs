# Instrucciones para subir purc-mobile y purc-web a GitHub

## Requisitos previos
- Tener Git instalado
- Tener acceso a la organización Bramartechnology en GitHub
- Los repositorios `purc-mobile` y `purc-web` ya deben existir en GitHub (vacíos)

## Paso 1: Instalar dependencias en cada proyecto

Antes de nada, abrí tu terminal y ejecutá estos comandos:

```bash
# Ir a la carpeta purc-mobile e instalar dependencias
cd StudioProjects/purc-mobile
npm install

# Ir a la carpeta purc-web e instalar dependencias
cd ../purc-web
npm install
```

## Paso 2: Subir purc-mobile a GitHub

```bash
# Ir a la carpeta del proyecto
cd StudioProjects/purc-mobile

# Inicializar Git
git init

# Agregar todos los archivos (el .gitignore ya excluye lo sensible)
git add .

# Crear el primer commit
git commit -m "feat: proyecto Expo inicial con Supabase, cámara, GPS y mapas"

# Conectar con el repositorio remoto en GitHub
git remote add origin https://github.com/Bramartechnology/purc-mobile.git

# Renombrar la rama a 'main' (estándar de GitHub)
git branch -M main

# Subir el código
git push -u origin main
```

## Paso 3: Subir purc-web a GitHub

```bash
# Ir a la carpeta del proyecto
cd StudioProjects/purc-web

# Inicializar Git
git init

# Agregar todos los archivos
git add .

# Crear el primer commit
git commit -m "feat: proyecto Next.js inicial con Supabase, shadcn, mapas y gráficos"

# Conectar con el repositorio remoto en GitHub
git remote add origin https://github.com/Bramartechnology/purc-web.git

# Renombrar la rama a 'main'
git branch -M main

# Subir el código
git push -u origin main
```

## Paso 4: Tu socio clona los repos

Tu socio ejecuta estos comandos en su computadora:

```bash
# Clonar ambos repos
git clone https://github.com/Bramartechnology/purc-mobile.git
git clone https://github.com/Bramartechnology/purc-web.git

# Instalar dependencias en cada uno
cd purc-mobile && npm install
cd ../purc-web && npm install
```

## IMPORTANTE: Tu socio necesita crear su propio .env

El archivo `.env` (con las credenciales de Supabase) NO se sube a GitHub por seguridad.
Tu socio debe crear su propio archivo:

Para purc-mobile:
```bash
cp .env.example .env
# Luego editar .env y poner las credenciales reales
```

Para purc-web:
```bash
cp .env.example .env.local
# Luego editar .env.local y poner las credenciales reales
```

Las credenciales son:
- URL: https://fwfyriatbonqdcgwietn.supabase.co
- Anon Key: (pásasela por WhatsApp o un canal privado, NO por GitHub)
