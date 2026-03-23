# Ichi UTM - Guía Interactiva del Campus

## Descripción General
**Ichi UTM** (del mixteco *Ichi*, que significa "camino" o "ruta") es una aplicación móvil desarrollada en Flutter, diseñada para facilitar la navegación y orientación de los estudiantes de nuevo ingreso en la Universidad Tecnológica de la Mixteca (UTM). 

La aplicación integra un mapa satelital interactivo del campus con elementos tridimensionales, marcando al menos diez Puntos de Interés (POIs) fundamentales para la vida universitaria. Además, incorpora mecánicas de ludificación (minijuegos contextualizados) vinculados a edificios específicos para reforzar el aprendizaje del entorno de una manera interactiva y amigable.

## Tecnologías a Utilizar (Propuestas)
* **Framework principal:** Flutter (Dart).
* **Mapas y Navegación:** `mapbox_maps_flutter` (Para renderizar el mapa base satelital interactivo con relieve y extrusión 3D de edificios, usando un estilo personalizado).
* **Seguridad de Credenciales:** `flutter_dotenv` (Para proteger los Access Tokens de las APIs mediante variables de entorno).
* **Geolocalización (Por integrar):** `geolocator` (Para ubicar al usuario dentro del campus en tiempo real).
* **UI/UX (Por integrar):** `carousel_slider` (Para las galerías de imágenes de cada punto de interés).

## Integrantes del Equipo
1. Ariadna Betsabe Espina Ramirez 
2. Jose Alberto Pérez Cortes 
3. Amaury Yamil Morales Diaz 


---

## Bocetos y Descripción de Pantallas Propuestas

*Nota: [Aquí deberás insertar el enlace a tu imagen de Figma o adjuntar la captura de tus bocetos]*
`![Bocetos de la app](enlace_a_tu_imagen.png)`

1. **Pantalla Principal (Mapa Interactivo):**
   Pantalla de inicio a pantalla completa que despliega el mapa de la UTM centrado en el campus. Contiene botones de control de cámara (zoom, brújula) y los 10 marcadores interactivos (pines) resaltando los institutos principales.

2. **Pantalla de Detalle del Lugar (POI):**
   Un panel inferior (Bottom Sheet) o pantalla modal que se despliega al tocar un pin. Muestra el nombre del instituto/edificio, una descripción de los servicios o carreras que alberga, un carrusel deslizable con fotografías del lugar y un botón de "Lanzar Actividad" si el lugar tiene un minijuego asignado.

3. **Pantallas de Actividades (Juegos):**
   Cada minijuego consta de al menos dos pantallas: una pantalla de "Inicio/Instrucciones" contextualizada con el edificio, y la pantalla del "Tablero de Juego" interactivo.

---

## Propuestas de Actividades y Juegos por Integrante

A continuación se describe la estructura de carpetas sugerida y la temática de cada juego contextualizado dentro de la UTM:

### `/propuesta/trivia-nombre/` (Contexto: Instituto de Computación)
**Idea del juego:** "Trivia Tech UTM". Es un juego de preguntas y respuestas de opción múltiple diseñado para evaluar y enseñar datos curiosos sobre la historia de la computación, lenguajes de programación y detalles específicos de la universidad. 
**Pantallas:** Contará con una pantalla de inicio para seleccionar la categoría y una segunda pantalla dinámica donde se despliegan las preguntas. *(Nota: Las preguntas han sido estructuradas utilizando herramientas de Inteligencia Artificial para enriquecer la base de datos, adaptándolas al contexto universitario).*

### `/propuesta/memorama-nombre/` (Contexto: Centro de Idiomas)
**Idea del juego:** Un memorama visual enfocado en relacionar conceptos lingüísticos. El usuario debe emparejar tarjetas táctiles; por ejemplo, conectando la bandera de un país con el nombre de su idioma, o palabras de vocabulario básico en inglés/mixteco con su respectiva imagen. Ayuda a familiarizar al alumno con el enfoque global del Centro de Idiomas.
**Pantallas:** Pantalla de menú con selector de dificultad (tamaño de la cuadrícula) y pantalla principal del tablero de cartas con contador de movimientos.

### `/propuesta/laberinto-nombre/` (Contexto: Servicios Escolares)
**Idea del juego:** "Carrera de Trámites". Un laberinto interactivo visto desde arriba donde el jugador controla un avatar estudiantil. El objetivo es encontrar el camino correcto a través de los pasillos para llegar a la ventanilla de "Becas" antes de que se agote un temporizador, simulando de forma humorística el proceso de hacer trámites.
**Pantallas:** Pantalla de "Ready/Go" con las reglas, y la pantalla del canvas interactivo donde se desarrolla el laberinto.

### `/propuesta/rompecabezas-nombre/` (Contexto: Instituto de Electrónica y Mecatrónica)
**Idea del juego:** Un rompecabezas lógico deslizante (tipo 15-puzzle). La imagen central a resolver será la fotografía de un brazo robótico de los laboratorios del instituto o un diagrama de circuitos. El jugador debe deslizar las baldosas en los espacios vacíos para completar la imagen.
**Pantallas:** Pantalla mostrando la fotografía original como referencia, y la pantalla del tablero de fichas deslizables con contador de tiempo.