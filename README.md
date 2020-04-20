# Shaders
A prototype usage of procedural generated shaders using [Processing](https://processing.org) and [GLSL](https://en.wikipedia.org/wiki/OpenGL_Shading_Language).
> **Adrián Lorenzo Melián** - *Creando Interfaces de Usuario*, [**ULPGC**](https://www.ulpgc.es).
> adrian.lorenzo101@alu.ulpgc.es

<div align="center">
 <img src=images/demo.gif alt="Demo"></img>
 <p>Figura 1 - Demostración de la ejecución del shader</p>
</div>

***

## Índice
* [Introducción](#introduction)
* [Instrucciones](#instructions)
* [Implementación](#implementation)
    * [Generación del shader](#shader-generation)
* [Herramientas y recursos utilizados](#tools-and-resources)
* [Referencias](#references)

## Introducción <a id="introduction"></a>
El objetivo de esta práctica es **crear un prototipo que haga uso de shaders de fragmentos con diseño generativo o realice algún procesamiento sobre imagen.**

En este caso, se ha elegido realizar **diseños generativos de un shader a partir de fuentes de ruido pseudoaleatorias y del movimiento de fractal Browniano`[1]`**. Para la creación de estos diseños, se ha hecho uso de un criterio puramente estético.

## Instrucciones <a id="introduction"></a>
Haciendo **click con el puntero**, podrás cambiar de ruido usado para generar el shader, y por tanto, **cambiar el diseño.**

Por otra parte, **moviendo el puntero por la ventana**, podrás **cambiar la tonalidad del color que se está mostrando**.

## Implementación <a id="implementation"></a>

### Generación del shader <a id="shaders-generation"></a>

Para generar el shader, se realizan los siguientes pasos:

1. Se **normaliza la posición a tratar y la posición del ratón.**
2. Se realizan **cambios de escala a la posición** que se está tratando.
3. Se obtiene el **movimiento fractal browniano de la fuente de ruido seleccionada por el usuario.** La semilla de esta fuente de ruido está establecida por la posición escalada por el seno/coseno del tiempo, lo que genera movimiento. A su vez, este valor seno/coseno del tiempo se encuentra escalado por un factor de velocidad.
4. Se **rota este punto**, en función del coseno/seno del tiempo.
5. Se **realiza el producto de este valor por el color,** cuya tonalidad es modificada en función de la posición del ratón.

```c
void main() {
  vec2 pos = gl_FragCoord.xy / u_resolution.xy;
  vec2 mouse = u_mouse.xy / u_resolution.xy;

  float scale = u_resolution.x/u_resolution.y;
  pos = getScaleTileCoord(pos, scale);

  float mistMovementSpeed = 0.07;
  float mistRotationSpeed = 0.05;

  vec3 posValue = vec3(fractalBrownianMotion(
    rotate2d(pos * vec2(sin(mistMovementSpeed*u_time)), mistRotationSpeed * cos(u_time))
  ));
  posValue = posValue * vec3(fractalBrownianMotion(
    rotate2d(pos * vec2(cos(mistMovementSpeed*u_time)), mistRotationSpeed * sin(u_time))
  ));

  vec3 color = vec3(0.12915 * mouse.x, 0.4853, 0.24115 * mouse.y);
  gl_FragColor = vec4(posValue * color, 1.0);
}
```

## Herramientas y recursos utilizados <a id="tools-and-resources"></a>
- **[Giphy](https://giphy.com)** - Herramienta usada para la creación de gifs a partir de los frames de la aplicación.

## Referencias <a id="references"></a>
- `[1]` **[Fractal de movimiento Browniano](https://en.wikipedia.org/wiki/Fractional_Brownian_motion)**.
- `[2]`**[*The Book of Shaders*](https://thebookofshaders.com)**. Patricio González Vivo, Jen Lowe.
- ***Guión de Prácticas 2019/20**, Creando Interfaces de Usuario*. Modesto F. Castrillón Santana, J Daniel Hernández Sosa.


