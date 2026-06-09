# Rastreo de personal — veda

App web para que el cliente vea **en tiempo real** dónde se mueve el equipo durante las
visitas de invierno (camino y chalets). El equipo lleva **un dispositivo** (tablet o celu
montado en el tablero, enchufado y con la pantalla encendida) que transmite la ubicación.

- **Visor (cliente):** abre el link y ve el/los puntos moverse en el mapa. No instala nada.
- **Carga + transmisión (equipo):** una persona carga los vehículos y, **en cada vehículo, quién va arriba**, y toca *Iniciar*.

Stack: un solo `index.html` (React + Leaflet) + Supabase Realtime, colgado en GitHub Pages.

---

## 1. Configurar Supabase (una vez)

1. Crear un proyecto en [supabase.com](https://supabase.com) **o reutilizar el de ControlObra**
   (el SQL no toca esas tablas: agrega `posiciones` en el schema `public`).
2. **SQL Editor → New query**, pegar el contenido de [`supabase.sql`](supabase.sql) y **Run**.
3. **Settings → API**, copiar `Project URL` y la `anon public key`.
4. En `index.html`, completar al principio del bloque de configuración:
   ```js
   const SUPABASE_URL  = "https://xxxxx.supabase.co";
   const SUPABASE_ANON = "eyJhbGci...";   // anon public
   const CENTRO = [-41.133, -71.31];      // centro inicial del mapa (ajustar a la obra)
   ```

## 2. Publicar en GitHub Pages

1. Crear un repositorio y subir `index.html` (y opcionalmente `supabase.sql` / `README.md`).
2. **Settings → Pages → Source: Deploy from a branch**, rama `main`, carpeta `/root`.
3. A los minutos queda online en `https://TU-USUARIO.github.io/TU-REPO/`.

## 3. Uso

- **Cliente:** se le pasa el link `https://TU-USUARIO.github.io/TU-REPO/` → ve el mapa en vivo.
- **Equipo (tablet):** abrir el mismo link y tocar el botón **📡** arriba a la derecha
  (o entrar directo con `?rol=recorrida`). Cargar vehículos + personas a bordo y **Iniciar**.
  Al terminar, **Finalizar recorrida**.

---

## Importante sobre la pantalla / el bloqueo

Una página web **solo puede mandar GPS mientras está abierta y a la vista**. La app pide
*Wake Lock* para **mantener la pantalla encendida sola**, así que con el dispositivo
enchufado transmite sin cortes.

> ⚠️ Lo que un navegador **no** puede hacer es despertarse solo con la pantalla bloqueada
> para mandar una ubicación cada X minutos. Eso requiere una app nativa. Por eso el esquema
> es: **dispositivo dedicado, enchufado, pantalla encendida** durante la recorrida.

## Notas

- **Solo en vivo:** no se guarda historial; la posición se sobrescribe. Si más adelante
  quieren reproducir el recorrido, se agrega una tabla de historial.
- Cada **vehículo** lleva su propia lista de **personas a bordo** (anidado, estilo ControlObra).
- Soporta **varios dispositivos** a la vez (si va más de un vehículo por separado, cada uno
  con su tablet): aparecen como puntos distintos.
- Capa **Satélite** disponible en el control de capas del mapa, útil para caminos de montaña.
