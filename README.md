# Big Nose Joe

Clicker 2D hecho con Godot 4.6. Los glóbulos blancos limpian la nariz de Joe mientras él encadena cinco decisiones progresivamente peores. Cada desastre cambia el cuello de botella y exige una adaptación concreta.

Al abrir el juego aparece una portada desde la que se puede continuar, empezar de cero —con confirmación si ya existe progreso— o salir.

## Controles

- Clic izquierdo sobre la pared: desprender cocaína.
- Clic izquierdo sobre el montón: lanzar una pieza expuesta a la caja.
- Barra espaciadora: pausa o reanuda la partida.
- `A`, `D` o flechas: desplazar el escenario.
- Cursor en los bordes del área jugable: desplazamiento automático.
- `MENÚ · AUDIO Y PARTIDA` o `Esc`: abre el panel izquierdo de opciones.
- El panel permite guardar, guardar y salir, cerrar el menú y regular por separado música y efectos.
- La partida se guarda cada 10 segundos y al cerrar; el progreso sin conexión está limitado a 4 horas.

## Progresión por fases

Los cambios de fase no detienen la partida: Joe reacciona con un aviso central y la adaptación imprescindible se busca automáticamente en el laboratorio, aparece con el texto `NECESARIA PARA SUPERAR ESTA FASE` y queda rodeada por un halo azul hasta que se compra.

La tienda lineal ha sido sustituida por el `LABORATORIO DE ADAPTACIONES`. El catálogo conserva una tarjeta para cada criatura, transporte o infraestructura con identidad propia. Las unidades desconocidas aparecen como siluetas; al desbloquearlas recuperan su sprite real y abren una ficha con cantidades, estadísticas en unidades reales y únicamente sus propias tecnologías. Púgil, Leucocarnero, Leucofante, Cañón de Plasma Napial y Leucocito Supersaiyan son unidades independientes. Los rangos y accesorios que no crean otro actor permanecen dentro de la ficha de su unidad original.

1. `UNA RAYITA PARA DESAYUNAR` — 90%: tutorial de clic, caída, recogida y entrega. La primera oleada desbloquea la `CÉLULA PÚGIL EN PRÁCTICAS`.
2. `¿QUIÉN HA VACIADO EL CÁRTEL?` — 70%: el apelmazado presentado por la primera rayita se vuelve constante y el polvo que Joe deja acumulado presiona más visiblemente su colocón. La segunda cadena de mejoras púgiles queda disponible al entrar en esta fase.
3. `OFERTA DEL SUPERMERCADO` — 52%: cada rayita alterna serrín y yeso, y la tiza conserva su temporizador independiente. Los `QUIMIORRECEPTORES` evitan que el almacén se llene de basura.
4. `SPRAY NASAL DEL BAZAR` — 34%: el spray bloquea y reconstruye pared; el moco verde empieza a repetirse en esta misma fase. Los `MACRÓFAGOS ESPONJA` y las `CATAPULTAS MUCOLÍTICAS` resuelven ambos problemas.
5. `VOLCÁN ZOOLÓGICO` — 18%: comienzan hemorragia, daño tisular, bacterias, plaquetas y cuidadores mientras todas las locuras anteriores continúan activas.

Las fases ya no avanzan por tiempo ni por entregas. Joe empieza al 90% y cada tramo se desbloquea cuando el jugador logra reducir su colocón hasta 70%, 52%, 34% y 18%. Cada umbral provoca inmediatamente la nueva barbaridad y añade su temporizador al repertorio permanente. El medidor principal de colocón ocupa el centro superior: picar la pared lo hace bajar al instante, muestra las unidades reales extraídas y pulsa en azul; almacenar ese mismo polvo no aplica la reducción dos veces. La versión 18 reinicia los guardados anteriores para estrenar limpiamente la nueva escala de extracción.

## Cocaína, apelmazado y transporte

El polvo se representa como una única superficie de nieve continua: cada unidad extraída ocupa exactamente un píxel de pantalla de área, aunque internamente se agrupe en cargas ligeras para conservar el rendimiento. Por eso una descarga de 50 hace crecer la montaña 50 píxeles de masa y una descarga de 500.000 ocupa 500.000: no hay multiplicadores visuales ocultos ni una bolita gigante de valor arbitrario. La silueta forma lomas y valles, nunca torres de canicas. Los pedruscos conservan su propia capa interactiva y pueden sostener pendientes como muros de contención. El tabique actúa como un límite duro: ningún grano ni pedrusco puede atravesarlo o dibujarse por encima de la pared compacta.

La fosa tiene aforo físico. El `LEUCOTOPÓGRAFO DE 1927` muestra su llenado en tiempo real desde el principio: la primera excavación admite 75K de polvo. Si llega al límite, se detiene todo el minado —manual y automático— mientras los porteadores siguen retirando nieve. La tecnología `GALERÍA SUBMUCOSA` desplaza el almacén y abre volumen profundo hasta 600K. No es un requisito impuesto por una fase: solo se vuelve imprescindible cuando el jugador ha decidido llenar la fosa. En fase 3, la `PRENSA DEL SUMIDERO` inaugura la compresión visible y escala el aforo a 100M, 50B y 100T para acompañar a Leucofante, plasma y Supersaiyan.

La primera `OTRA RAYITA` presenta el apelmazado antes del umbral del 70%, con un máximo introductorio de dos pedruscos. El primero revela y marca en azul la mejora de cascos. Al entrar en la segunda fase el límite sube a ocho. Un grano con al menos cinco vecinos cercanos forma un pedrusco de seis unidades. Con producción tranquila se comprueba el montón cada 24 aterrizajes; por encima de dos clics por segundo baja a 18 y por encima de cuatro baja a 12. La extracción automática puede llevar la cadencia hasta un mínimo de ocho aterrizajes. Los pedruscos conservan su valor, bloquean la recogida y solo los cascos azules pueden tratarlos y llevarlos.

Los peones recorren un ciclo físico de recogida y transporte: salen vacíos de la caja, extraen piezas expuestas de la superficie y las representan como una pequeña pila de nieve delante del cuerpo antes de depositarla dentro del almacén. La mini-pila es una sola silueta visual; las piezas conservan su valor real en la lógica. No minan la pared; esa función pertenece al jugador y a las unidades de extracción. Peón y carga pasan a capas de primer plano durante el transporte, por lo que ningún almacén puede ocultarlos. Tras desbloquear los cascos azules, `APELMAZADO INTELIGENTE` les permite agrupar 3, 5, 8 y finalmente 12 granos normales dentro de cada mini-pila; los pedruscos hostiles siguen siendo trabajo exclusivo de los cascos azules. `TRABAJO EN CADENA` se muestra desde el laboratorio, pero solo puede comprarse después de perforar el tabique.

Los peones blancos se dedican exclusivamente a recoger y transportar. La logística crece como una cadena visible y separada: cajón de 1.000, contenedor de 5.000, doble fondo de 25.000, almacén alveolar de 100.000, silo de 2 millones, silo ampliado de 10 millones, bóveda presurizada de 100 millones, bóveda hiperbárica de 1.000 millones, planta de 10.000 millones y planta de fusión de 100.000 millones. Cada salto fuerte de transporte exige primero la instalación capaz de recibirlo: el carrito avanza 12 → 60 → 300 → 1.500 unidades y el `MUGIDÓFILO DE CARGA`, 10.000 → 150.000 → 6,5 millones → 100 millones → 10.000 millones. Son mejoras numéricas de los vehículos y edificios existentes, no unidades nuevas. Con toda la logística de fase 2, la recogida ronda 479K/s frente a 471K/s de extracción combinada entre ocho púgiles y el Leucocarnero: puede vaciar el pico de producción sin chocar contra un almacén pequeño. Las ampliaciones posteriores acompañan al Leucofante y al plasma; la carga final del Supersaiyan la retira el Expreso.

El Expreso se desbloquea al final, después de abrir la segunda fosa y construir la planta. Recoge en la fosa derecha, sale cargado por un túnel del extremo derecho y reaparece por el extremo izquierdo para descargar en la planta. El viaje vacío hace el circuito inverso. No existen vías sobre el tabique ni cruces visibles entre fosas. La caja y cada edificio tienen límite real; cuando se llenan, las entregas se detienen hasta que el jugador gasta cocaína o amplía el almacén.

El jugador también puede intervenir directamente en la logística. Al pulsar sobre cualquier parte ocupada del montón, la pieza superior más cercana describe un arco hasta la caja y sólo se entrega al llegar. Las piezas que aún caen o están enterradas no responden. Los pedruscos siguen necesitando cascos azules, las bacterias necesitan cuidadores y enviar una impureza manualmente ensucia la caja igual que cualquier otra entrega.

## Arquitectura para partículas masivas

El polvo jugable ya no crea un `Sprite2D` por bolita. Cada grano es un objeto de datos ligero y se dibuja mediante `RenderingServer` en `MultiMesh` separados por fosa, textura, material y estado —montaña o carga—. Veinte mil granos equivalentes ocupan muy pocos lotes y añaden cero nodos de partícula al árbol de escenas. Los pedruscos conservan únicamente sus grietas como nodos escasos e interactivos.

Las alturas, superficies, cargas y pedruscos se indexan por fosa y columna. Colocar o consultar una bola no recorre el montón completo; el apelmazado construye una cuadrícula local y solo compara celdas vecinas. Todas las caídas y vuelos manuales comparten un único actualizador, sin un `Tween` por partícula. El tren reclama y deposita cargas masivas por lotes y el guardado agrupa secuencias equivalentes dentro de cada columna.

La prueba de regresión fija veinte mil partículas individuales como carga de referencia: exige cero nodos de polvo, un único lote para una textura común, búsqueda espacial acotada, transporte sin borrado cuadrático y un guardado compacto inferior a 500 KB.

## Pared y colocón de Joe

Las dos paredes tienen un billón de puntos de resistencia, pero esa cifra aparece como `???` al comenzar. Solo la `RADIOGRAFÍA DE NAPIA`, disponible después de analizar el serrín y el yeso, revela el valor restante. Conservan su anchura completa al 100% y se reducen proporcionalmente hasta un mínimo visual del 5%. Cada punto porcentual atravesado abre o profundiza una muesca azulada claramente acumulativa en el borde libre y desprende polvo visual. El recorte se calcula desde el primer píxel opaco de la silueta, por lo que siempre elimina una parte visible del muro. Cada 10% una de esas fracturas crece, arranca un bloque compacto equivalente y lo deja caer al suelo en su propia capa. Ese bloque contiene 25 unidades reales, pero tiene 24 puntos de resistencia independientes: cada golpe libera solo una parte y el daño manual está limitado a tres, por lo que incluso un clic muy mejorado necesita al menos ocho impactos. El desgaste se comunica mediante grietas y texto, sin la antigua barra horizontal. Al llegar a cero, una pared queda agotada y desaparece definitivamente; no se regenera de golpe.

`COLOCÓN DE JOE` es la carrera global: arrancar cocaína de la pared baja el valor de inmediato y limpiar el sabotaje de Joe también ayuda; las nuevas rayas, la contaminación, el daño tisular y la infección lo elevan. Durante la apertura, la montaña creada por el propio jugador no anula ese avance: solo los granos añadidos por Joe ejercen una presión pequeña y limitada. Desde la fase 2, una acumulación extrema puede añadir hasta 0,025 puntos de colocón por segundo. Alcanzar el 100% mata a Joe y abre una decisión: cargar el último guardado o volver al menú. La sobredosis nunca sobrescribe la partida. El jugador ve siempre unidades reales en los impactos —granos añadidos, absorbidos, restaurados o bloqueados— aunque el balance interno use porcentajes.

Los desastres no forman una ruleta ni pueden cancelarse. Cada fase añade un temporizador propio y todos los anteriores continúan activos: `OTRA RAYITA` cae cada 120 segundos con granos indivisibles de valor 1 y escala según lo minado durante el intervalo anterior; la tiza cae cada 180 segundos; al 34% se incorporan juntos el spray y el moco aglutinante; al 18% comienzan el rascado, la hemorragia y las bacterias. Ningún evento roba cocaína que ya esté guardada.

## Automatización de los golpes

La producción automática especializada no está disponible al comenzar. Cada 120 segundos Joe se mete `OTRA RAYITA`: aparece un aviso y una oleada de 240, 360, 600, 1.000, 1.600, 2.600 o 4.000 granos según la extracción reciente. Todos valen exactamente una unidad y ocupan un hueco completo de transporte, de modo que son sabotaje logístico y no paquetes de riqueza. Los granos extraídos por el jugador conservan el valor completo del golpe y solo se distinguen de los de Joe mediante un contorno oscuro pronunciado; nunca revelan su valor ni se fraccionan para entrar en el almacén. Tras la primera avalancha se desbloquea `CÉLULA PÚGIL EN PRÁCTICAS`.

El primer púgil entra con guante rojo y cinta azul, calienta el brazo, atraviesa físicamente la zona de trabajo y suelta siempre diez partículas. Su primer impacto, y el debut de cada extractor nuevo, añade una ráfaga extra de nieve puramente visual: celebra el salto de poder sin alterar el valor económico ni llenar el montón con recursos falsos. Los cuatro rangos tienen golpes base de 50, 500, 5.000 y 50.000. Esa fórmula permanece interna: el impacto solo muestra el daño total. `SINDICATO DEL PUÑO` incorpora dos púgiles básicos; `PROTEÍNA DE MÉDULA` triplica la cuadrilla y añade una venda turquesa separada; el turno de noche reduce el primer intervalo de cuatro a 2,5 segundos. Al comenzar la fase 2, el federado multiplica el golpe base por diez. `RABIA DE TURNO DOBLE` duplica la fuerza, los `BECARIOS DEL TURNO PARTIDO` añaden dos púgiles, `COMBO DE BAR DE GUARDIA` duplica cada quinta ronda y las `VENDAS DE URANIO HOMEOPÁTICO` reducen otro 20% el intervalo. `PUÑO COLECTIVO DE CONVENIO` cierra el tramo triplicando la cuadrilla y permite empezar a ahorrar para el Leucocarnero. Cada accesorio nuevo vive en una capa separada del mismo cuerpo; las evoluciones visuales continúan limitadas a una por fase.

Los recolectores siguen siendo necesarios para convertir el polvo del suelo en moneda, por lo que producción y logística pueden mejorarse por separado. Los saltos grandes se alternan deliberadamente: una mejora de extracción crea una montaña; la siguiente familia logística la vacía; la ampliación de almacén permite ahorrar para el nuevo salto.

Cada fase incorpora una silueta de extracción propia y exige completar la anterior. En la segunda aparece el `LEUCOCARNERO`: retrocede, toma carrerilla y embiste por 500K, 1M o 2,5M cada ocho segundos, reducibles a seis. La tercera añade el `LEUCOFANTE`, que comienza con 15M cada veinte segundos y multiplica el cabezazo por cinco. La cuarta abre el `CAÑÓN DE PLASMA NAPIAL`, con una descarga inicial de 5B y dos bobinas multiplicadoras. El cañón no dispara células: condensa una esfera azul, deja estela luminosa y solo aplica el daño cuando alcanza la pared. La fase quinta culmina con el `LEUCOCITO SUPERSAIYAN`: 15B de daño inicial y dos saltos de potencia por diez.

Las compras de la fase 1 aparecen de forma escalonada. `BARRIDO CONTINUO` llega pronto: mantener pulsado sobre el montón recoge cada 0,22 segundos y sus dos mejoras bajan el intervalo a 0,14 y 0,09. `NUDILLOS DE QUERATINA` crea cada diez clics tantas bolas adicionales como niveles tenga, y cada bola conserva toda la potencia manual actual; `RITMO DE BAÑO` reduce más adelante los clics necesarios. El carrito recibe dos saltos multiplicativos, `APELMAZADO INTELIGENTE` crea una segunda curva de capacidad para los peones y `SINDICATO DEL PUÑO` añade extracción. Adquirir el último salto del carrito o el sindicato desbloquea la `AUTOVÍA LINFÁTICA`. La interfaz no muestra fórmulas de presión ni umbrales: solo avisa que Joe está colocado, inquieto o a punto de cometer una locura.

## Paso a la fosa izquierda

La `TUNELADORA DE NARICES` aparece al alcanzar la fase de spray. Su tecnología abre el paso independientemente de la resistencia de las dos paredes. Al activarla, la cámara puede entrar en la fosa izquierda y los mismos peones cruzan para alternar el trabajo entre ambas paredes.

La ventana es de 1440×810. El escenario interior mide 7.800 píxeles de ancho y se muestra al 62 % de escala. La extensión a ambos lados deja recorrido para convoyes, una planta en la fosa opuesta y el Expreso que da la vuelta a la nariz.

## Estructura

- `scenes/main.tscn`: composición visual, capas e interfaz.
- `scenes/technology_lab.tscn`: ventana, catálogo de unidades y panel de tecnologías.
- `scripts/main.gd`: lógica de juego.
- `scripts/technology_lab.gd`: presentación de fichas, sprites y siluetas bloqueadas.
- `scripts/progression_data.gd`: fases, textos, costes y adaptaciones.
- `assets/art/gameplay/sprites`: peones, paredes, recursos y transportes separados por vehículo y animal de tiro.
- `assets/art/gameplay/infrastructure`: contenedor, silo y planta como edificios independientes.
- `assets/art/gameplay/background`: fondo panorámico de la cavidad nasal.
- `assets/art/gameplay/environment`: tabique completo y pieza perforable.
- `assets/art/gameplay/source`: originales con fondo de recorte.
- `assets/audio`: banda sonora, respiración y efectos de impacto originales.
- `tools/generate_audio.py`: generador reproducible de todos los sonidos del prototipo.
- Los volúmenes se conservan en `user://big_nose_joe_settings.cfg`, separados de la partida.
- `assets/joe_theme.tres`: colores y estilos de interfaz.
- `tests`: pruebas de progresión, apilado y capturas visuales.

Consulta `ART_DIRECTION.md` para mantener el estilo y la separación por capas.
