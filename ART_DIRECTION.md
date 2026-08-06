# Dirección artística: Big Nose Joe

## Principio

La escena toma de *The Gnorp Apologue* su claridad estructural: fondo oscuro, terreno horizontal, criaturas diminutas, recurso muy contrastado y espacio para construcciones futuras. Todo el arte es original y está adaptado a la anatomía absurda de Joe.

La regla principal es la economía visual:

- píxel grande y deliberado;
- silueta antes que detalle;
- cuatro o cinco colores por sprite;
- sombras planas, sin gradientes;
- escenario oscuro y recursos claros;
- ningún adorno que compita con el bucle jugable.

## Mundo

El escenario mide 7.800 píxeles de ancho, se presenta al 62 % de escala y está dividido por el tabique en dos cámaras. La ampliación lateral permite que la logística crezca desde una caja próxima hasta una planta remota y deja recorrido legible para convoyes:

- la fosa derecha es la zona inicial;
- la fosa izquierda es visible pero inaccesible;
- ambas paredes tienen 10.000 millones de puntos de resistencia;
- la `TUNELADORA DE NARICES` se desbloquea tecnológicamente en la fase de spray, sin depender del desgaste de ninguna pared;
- el agujero permite cruzar, desplazar la cámara y minar el lado izquierdo.

La cámara se mueve con `A`, `D`, las flechas o acercando el cursor a los bordes.

## Capas activas

1. `Layer00_Backdrop`: cavidad nasal con carne, pelos, capilares y mocos discretos.
2. `Layer10_Septum`: columna orgánica central, compuerta y agujero.
3. `Layer20_Ground`: terreno horizontal continuo.
4. `Layer30_Props`: caja de entrega.
5. `Layer32_Infrastructure`: contenedor, silo, planta y bocas de túnel; cada elemento es un nodo sustituible.
6. `Layer40_Resources`: paredes de cocaína de ambos lados.
7. `Layer45_JoeEvents`: gotas azules, recubrimiento de spray, heridas y moco; todos independientes de pared y fondo.
8. `Layer46_Crisis`: lavado rojo progresivo y gotas de la hemorragia, sin masas sólidas sobre el suelo.
9. `Layer50_Chunks`: cocaína, impurezas, pedruscos y bacterias apiladas.
10. `Layer52_WallChunks`: grandes trozos desprendidos, siempre visibles sobre el polvo y minables solo por el jugador.
11. `Layer55_Platelets`: refuerzos de reparación independientes.
12. `Layer57_Transport`: carrito, mugidófilo, vagones y Expreso; nunca contiene lógica de minado.
13. `Layer58_Punchers`: autoclickers con guantes de boxeo, separados de la logística.
14. `Layer59_Adaptations`: paraguas, esponjas y catapultas, montados como cuerpo y accesorio reemplazables.
15. `Layer60_Pawns`: peones básicos y variantes funcionales.
16. `Layer70_Effects`: cifras reales y confirmaciones visuales.
17. Interfaz fija: laboratorio, colocón, daño, cabecera y prueba de fases. La contaminación exacta permanece oculta.
18. `JoeHigh`: retrato, etiqueta y barra de colocón independientes de los medidores de crisis.

No existe una silueta dinámica de presión detrás del montón: era la sombra roja que cambiaba con su altura y se eliminó por completo.

## Assets

Los elementos jugables móviles usan sprites separados:

- `pawn_empty.png` y `pawn_carry.png`: peón básico;
- `pawn_specialist_empty.png` y `pawn_specialist_carry.png`: el mismo peón con casco de obra azul;
- `pawn_detector_empty.png` y `pawn_detector_carry.png`: el mismo peón con gafas de ingeniería;
- `pawn_handler_empty.png` y `pawn_handler_carry.png`: cuidador con guantes gruesos;
- `pawn_empty.png` reutilizado por los púgiles, con guante rojo y cinta azul añadidos como capas hijas independientes;
- `leukocyte_elephant.png`, `pugilist_cannon.png` y `leukocyte_supersaiyan.png`: tres siluetas tardías independientes, siempre apoyadas en el suelo; proyectil y Kamehameha viven en la capa de efectos;
- `umbrella_pink.png`: paraguas rosa separado del cuerpo básico;
- `sponge_yellow.png`: esponja amarilla separada del cuerpo del macrófago;
- `mucus_catapult.png`: máquina mucolítica independiente; el proyectil vuelve a usar el cuerpo básico;
- `platelet.png`: plaqueta coral;
- `bacteria.png`: bacteria verde;
- `collection_box.png`: caja de entrega;
- `vesicular_cart.png`: carro independiente; el peón que tira de él reutiliza su sprite básico;
- `leukox.png`: `MUGIDÓFILO DE CARGA`, separado de `convoy_wagons.png` para poder retocar animal y carga por separado;
- `leukocyte_express.png`: Expreso completo que conserva locomotora y vagones en una silueta única durante las curvas;
- `cocaine_wall.png`: pared compacta adherida al tabique;
- `cocaine_wall_chunks.png`: atlas de cuatro bloques desprendidos; su fuente con croma permanece en `source/`;
- `cocaine_grain.png`: grano, impureza, bola segura y base visual de los pedruscos.
- `ui/joe_prognosis.png`: retrato de Joe para la barra de colocón, generado como pixel art y recortado con transparencia.
- `effects/cocaine_wall_damage.gdshader`: máscara escalonada que muerde el borde de la pared sin alterar su textura.

El escenario utiliza:

- `background/nasal_cavity.png`: fondo panorámico oscuro montado en paneles alternados y reflejados;
- `environment/septum.png`: revestimiento orgánico del tabique;
- `environment/septum_gate.png`: tramo independiente que desaparece al perforar.
- `infrastructure/storage_container.png`: contenedor de 5.000 unidades;
- `infrastructure/cocaine_silo.png`: silo de 50.000 unidades;
- `infrastructure/processing_plant.png`: planta de 500.000 unidades en la fosa opuesta.

Los originales con croma están en `assets/art/gameplay/source`. Cada elemento se mantiene en su propia capa o nodo para poder sustituirlo sin romper los demás. Las adaptaciones reutilizan el cuerpo del peón: el paraguas y la esponja animan suavemente sin desplazar los pies, y la catapulta permanece apoyada mientras el proyectil describe un arco independiente.

Los puntos de apoyo se calculan desde el último píxel opaco de cada sprite: caja, contenedor, silo, planta, carrito, buey, vagones, tren, elefante, cañón y Supersaiyan descansan sobre el mismo suelo. El carrito y el convoy cambian de orientación como una unidad, pero sus piezas continúan separadas. El Expreso nunca aparece flotando ni cruza visualmente el tabique: cargado recorre el suelo hasta la boca derecha, desaparece durante dos segundos y reaparece por la boca izquierda para llegar a la planta. Vacío realiza el circuito inverso. Las dos bocas oscuras son nodos independientes en los extremos del mundo y no existe ninguna vía sobre el techo.

## Reglas visuales de las mecánicas

Cada clic conserva su bolita visible. La caída dura entre 0,82 y 1,18 segundos, tiene poco giro y no rebota. Al aterrizar, el montón se compacta verticalmente por columnas; al retirar una pieza, todas las piezas superiores vuelven a apoyarse. El límite junto al tabique impide que el relieve invada la pared.

El polvo se comporta como un pequeño vertedero. Las partículas que aún están cayendo reservan altura, diferentes tandas escogen zonas de vertido distintas y cada zona levanta su propia loma. Una pendiente excesiva provoca corrimientos laterales cortos, pero nunca una expansión plana por todo el suelo. La recogida abre valles y mordiscos; los pedruscos no ruedan y pueden sostener pendientes. `OTRA RAYITA` produce así varias montañas conectadas, no una aguja ni una inundación uniforme. Las oleadas sucesivas desplazan ligeramente sus puntos de caída, por lo que el perfil evoluciona en vez de reforzar siempre las mismas tres cumbres.

El clic manual sobre el relieve toma la pieza superior de la columna más cercana. Durante el vuelo aumenta ligeramente de tamaño, gira y describe un arco limpio hasta la caja; permanece en `Layer50_Chunks` y no necesita un asset compuesto nuevo. Al salir deja de sostener su columna, de modo que el valle y los corrimientos resultantes se ven desde el primer instante.

La pared se estrecha de forma proporcional hasta el 5%. Cada 1% activa o profundiza una muesca escalonada de varios píxeles y la perfila en azul frío para que el cambio se lea incluso con el zoom alejado; el borde unido al tabique permanece intacto. El shader busca primero el borde opaco real del PNG —no el límite transparente del rectángulo— y recorta desde esa silueta visible. Cada 10% la misma familia de fracturas crea un hueco mayor y suelta una de las cuatro variantes reducidas de `cocaine_wall_chunks.png`. El bloque cae sobre la ruta entre la pila y la caja, guarda 25 unidades de masa y tiene 24 puntos de resistencia propios. Su desgaste se comunica con grietas, movimiento y texto de impacto, sin barras flotantes. Solo el jugador puede romperlo: los peones vacíos esperan delante y los púgiles paran hasta despejar el paso. Al agotarse una pared desaparece y no vuelve a su tamaño completo. Los fragmentos pequeños siguen viviendo en `Layer70_Effects`; los bloques persistentes, en `Layer52_WallChunks`, por encima del polvo.

Una bola apelmazada natural representa seis granos vecinos y solo la transporta un casco azul después de tratarla. El contador que intenta crearla baja de 36 a 12 aterrizajes conforme crece la extracción automática: una producción más agresiva genera más trabajo de casco, con un límite simultáneo para que el sistema no absorba todo el juego. Los peones normales ya no pueden fabricar ni transportar una versión segura automáticamente.

Solo el peón básico rasca un punto de pared en cada ciclo. El carrito, el `MUGIDÓFILO DE CARGA` y el `EXPRESO LEUCOCITARIO` son transporte puro: mueven 12, 40 y todo el polvo normal disponible respectivamente, pero no dañan paredes ni bloques. Un bloque caído detiene sus rutas hasta que el jugador lo destruye. El espacio de almacenamiento también es físico y finito: 1.000 en la caja, 5.000 en el contenedor, 50.000 en el silo y 500.000 en la planta.

Las impurezas usan colores deliberadamente distintos —naranja, azul grisáceo y amarillo—. Sin quimiorreceptores, normales y cascos no saben distinguirlas y las llevan al compartimento de basura. Al entrar tiñen el almacén de marrón, alargan físicamente la descarga y reducen los números de entrega. Si llega al máximo, el almacén tiembla, se oscurece y congela toda célula y máquina; el colocón acelera hasta poder provocar sobredosis. Los quimiorreceptores realizan entonces una limpieza pasiva muy lenta; el trabajo solo vuelve cuando la suciedad baja al umbral seguro. No se muestra el porcentaje exacto. En la hemorragia no hay cúpulas: el peligro se representa mediante fondo rojo, gotas superiores, heridas en el suelo y medidor de daño.

El spray reutiliza la silueta de gota en azul y deja una película con 2.400 unidades propias sobre la pared. Mientras quede una sola unidad no puede minarse; a los 30 segundos, su proporción restante vuelve a solidificar parte de la raya. Los macrófagos mantienen el cuerpo básico y llevan una esponja amarilla que crece con la mejora; absorben 40 unidades por segundo y unidad, multiplicadas por 1,8 en cada evolución. El moco usa manchas verdes irregulares sobre la pared: bloquea la minería hasta perder su resistencia. La catapulta coral queda anclada al suelo y lanza el mismo glóbulo blanco en un arco suave. Cada resolución muestra cantidades concretas (`TE HAN ROBADO 2.000`, `PARAGUAS HAN SALVADO 500`, `ESPONJAS -1.440 SPRAY`) en lugar de comunicar porcentajes abstractos.

El debut del primer púgil debe leerse como un salto de escala: calentamiento visible, recorrido completo hasta la pared, texto `¡¡PUM!!`, 50 unidades agregadas en ocho partículas y un montón alterado de inmediato. Después regresa por el suelo a su punto de espera. El elefante conserva esa lógica de recorrido, levanta polvo con cada pisada y comprime el cuerpo al embestir; el cañón separa máquina, fogonazo, estela y proyectil giratorio; el Supersaiyan separa cuerpo, carga pulsante, anillos de aura y dos líneas de energía. Cada escala de impacto tiene una sacudida propia sin desplazar los pies de las unidades.

## Sonido

`nasal_shift_loop.wav` es una pieza original de 32 segundos: percusión orgánica, bajo, acordes oscuros, una melodía discreta y respiración filtrada. No usa los pitidos provisionales de las primeras builds. Púgil, elefante, cañón y Kamehameha tienen impactos diferenciados; las aspiraciones de Joe, el moco, los pedruscos, el guardado y la sobredosis poseen señales propias. Todo vive en `assets/audio` y puede regenerarse o retocarse desde `tools/generate_audio.py` sin mezclarlo con las capas visuales.

Cuando una fase exige tecnología, el botón correspondiente aumenta ligeramente de alto, recibe borde y resplandor cian, añade una línea explicativa y se desplaza automáticamente dentro del laboratorio para quedar completamente visible.
