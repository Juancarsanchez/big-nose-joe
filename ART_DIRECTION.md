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

El escenario mide 5200 píxeles de ancho, se presenta al 68 % de escala y está dividido por el tabique en dos cámaras:

- la fosa derecha es la zona inicial;
- la fosa izquierda es visible pero inaccesible;
- la pared derecha tiene 120.000 puntos de resistencia y la izquierda 180.000;
- al reducir la pared derecha al 50% se desbloquea la `TUNELADORA DE NARICES`;
- el agujero permite cruzar, desplazar la cámara y minar el lado izquierdo.

La cámara se mueve con `A`, `D`, las flechas o acercando el cursor a los bordes.

## Capas activas

1. `Layer00_Backdrop`: cavidad nasal con carne, pelos, capilares y mocos discretos.
2. `Layer10_Septum`: columna orgánica central, compuerta y agujero.
3. `Layer20_Ground`: terreno horizontal continuo.
4. `Layer30_Props`: caja de entrega.
5. `Layer40_Resources`: paredes de cocaína de ambos lados.
6. `Layer45_JoeEvents`: gotas azules, recubrimiento de spray, heridas y moco; todos independientes de pared y fondo.
7. `Layer46_Crisis`: lavado rojo progresivo y gotas de la hemorragia, sin masas sólidas sobre el suelo.
8. `Layer50_Chunks`: cocaína, impurezas, pedruscos y bacterias apiladas.
9. `Layer52_WallChunks`: grandes trozos desprendidos, siempre visibles sobre el polvo y minables solo por el jugador.
10. `Layer55_Platelets`: refuerzos de reparación independientes.
11. `Layer58_Punchers`: autoclickers con guantes de boxeo, separados de la logística.
12. `Layer59_Adaptations`: paraguas, esponjas y catapultas, montados como cuerpo y accesorio reemplazables.
13. `Layer60_Pawns`: peones básicos y variantes funcionales.
14. `Layer70_Effects`: cifras reales y confirmaciones visuales.
15. Interfaz fija: laboratorio, colocón, daño, cabecera y prueba de fases. La contaminación exacta permanece oculta.
16. `JoeHigh`: retrato, etiqueta y barra de colocón independientes de los medidores de crisis.

No existe una silueta dinámica de presión detrás del montón: era la sombra roja que cambiaba con su altura y se eliminó por completo.

## Assets

Los elementos jugables móviles usan sprites separados:

- `pawn_empty.png` y `pawn_carry.png`: peón básico;
- `pawn_specialist_empty.png` y `pawn_specialist_carry.png`: el mismo peón con casco de obra azul;
- `pawn_detector_empty.png` y `pawn_detector_carry.png`: el mismo peón con gafas de ingeniería;
- `pawn_handler_empty.png` y `pawn_handler_carry.png`: cuidador con guantes gruesos;
- `pawn_empty.png` reutilizado por los púgiles, con guante rojo y cinta azul añadidos como capas hijas independientes;
- `umbrella_pink.png`: paraguas rosa separado del cuerpo básico;
- `sponge_yellow.png`: esponja amarilla separada del cuerpo del macrófago;
- `mucus_catapult.png`: máquina mucolítica independiente; el proyectil vuelve a usar el cuerpo básico;
- `platelet.png`: plaqueta coral;
- `bacteria.png`: bacteria verde;
- `collection_box.png`: caja de entrega;
- `cocaine_wall.png`: pared compacta adherida al tabique;
- `cocaine_wall_chunks.png`: atlas de cuatro bloques desprendidos; su fuente con croma permanece en `source/`;
- `cocaine_grain.png`: grano, impureza, bola segura y base visual de los pedruscos.
- `ui/joe_prognosis.png`: retrato de Joe para la barra de colocón, generado como pixel art y recortado con transparencia.
- `effects/cocaine_wall_damage.gdshader`: máscara escalonada que muerde el borde de la pared sin alterar su textura.

El escenario utiliza:

- `background/nasal_cavity.png`: fondo panorámico oscuro montado en paneles alternados y reflejados;
- `environment/septum.png`: revestimiento orgánico del tabique;
- `environment/septum_gate.png`: tramo independiente que desaparece al perforar.

Los originales con croma están en `assets/art/gameplay/source`. Cada elemento se mantiene en su propia capa o nodo para poder sustituirlo sin romper los demás. Las adaptaciones reutilizan el cuerpo del peón: el paraguas y la esponja animan suavemente sin desplazar los pies, y la catapulta permanece apoyada mientras el proyectil describe un arco independiente.

## Reglas visuales de las mecánicas

Cada clic conserva su bolita visible. La caída dura entre 0,82 y 1,18 segundos, tiene poco giro y no rebota. Al aterrizar, el montón se compacta verticalmente por columnas; al retirar una pieza, todas las piezas superiores vuelven a apoyarse. El límite junto al tabique impide que el relieve invada la pared.

El polvo se comporta como un pequeño vertedero. Las partículas que aún están cayendo reservan altura, diferentes tandas escogen zonas de vertido distintas y cada zona levanta su propia loma. Una pendiente excesiva provoca corrimientos laterales cortos, pero nunca una expansión plana por todo el suelo. La recogida abre valles y mordiscos; los pedruscos no ruedan y pueden sostener pendientes. `OTRA RAYITA` produce así varias montañas conectadas, no una aguja ni una inundación uniforme. Las oleadas sucesivas desplazan ligeramente sus puntos de caída, por lo que el perfil evoluciona en vez de reforzar siempre las mismas tres cumbres.

El clic manual sobre el relieve toma la pieza superior de la columna más cercana. Durante el vuelo aumenta ligeramente de tamaño, gira y describe un arco limpio hasta la caja; permanece en `Layer50_Chunks` y no necesita un asset compuesto nuevo. Al salir deja de sostener su columna, de modo que el valle y los corrimientos resultantes se ven desde el primer instante.

La pared se estrecha de forma proporcional hasta el 5%. Cada 1% activa o profundiza una muesca escalonada de varios píxeles y la perfila en azul frío para que el cambio se lea incluso con el zoom alejado; el borde unido al tabique permanece intacto. El shader busca primero el borde opaco real del PNG —no el límite transparente del rectángulo— y recorta desde esa silueta visible. Cada 10% la misma familia de fracturas crea un hueco mayor y suelta una de las cuatro variantes reducidas de `cocaine_wall_chunks.png`. El bloque cae sobre la ruta entre la pila y la caja, guarda 25 unidades de masa y tiene 24 puntos de resistencia propios. Su desgaste se comunica con grietas, movimiento y texto de impacto, sin barras flotantes. Solo el jugador puede romperlo: los peones vacíos esperan delante y los púgiles paran hasta despejar el paso. Al agotarse una pared desaparece y no vuelve a su tamaño completo. Los fragmentos pequeños siguen viviendo en `Layer70_Effects`; los bloques persistentes, en `Layer52_WallChunks`, por encima del polvo.

Una bola apelmazada natural representa seis granos vecinos y solo la transporta un casco azul después de tratarla. Los peones normales ya no pueden fabricar ni transportar una versión segura automáticamente.

Las impurezas usan colores deliberadamente distintos —naranja, azul grisáceo y amarillo—. Al entrar en la caja la tiñen de marrón, alargan físicamente la descarga y reducen los números de entrega. Si llega al máximo, la caja tiembla, se oscurece, rechaza los clics de entrega y congela peones y púgiles. Los quimiorreceptores realizan entonces una limpieza pasiva lenta; el trabajo solo vuelve cuando la suciedad baja al umbral seguro. No se muestra el porcentaje exacto. En la hemorragia no hay cúpulas: el peligro se representa mediante fondo rojo, gotas superiores, heridas en el suelo y medidor de daño.

El spray reutiliza la silueta de gota en azul y deja manchas húmedas sobre la pared durante sus 30 segundos de preparación. Los macrófagos mantienen el cuerpo básico y llevan una esponja amarilla que crece con la mejora. El moco usa manchas verdes irregulares sobre la pared: bloquea la minería hasta perder su resistencia. La catapulta coral queda anclada al suelo y lanza el mismo glóbulo blanco en un arco suave. Cada resolución muestra cantidades concretas (`-2.000 GRANOS`, `ESPONJAS ABSORBEN 1.440`, `CATAPULTA -400 MOCO`) en lugar de comunicar porcentajes abstractos.

El debut del primer púgil debe leerse como un salto de escala: calentamiento visible, recorrido completo hasta la pared, texto `¡¡PUM!!`, doce partículas y un montón alterado de inmediato. Después regresa por el suelo a su punto de espera. El guante se refleja de forma independiente al cambiar de fosa, la criatura siempre mira hacia la pared y el punto de impacto sigue su borde libre mientras ésta se estrecha. Sus guantes y cinta continúan siendo capas hijas independientes del cuerpo básico.

Cuando una fase exige tecnología, el botón correspondiente aumenta ligeramente de alto, recibe borde y resplandor cian, añade una línea explicativa y se desplaza automáticamente dentro del laboratorio para quedar completamente visible.
