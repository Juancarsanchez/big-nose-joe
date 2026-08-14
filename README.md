# Big Nose Joe

Clicker 2D hecho con Godot 4.6. Los glóbulos blancos limpian la nariz de Joe mientras él encadena cinco decisiones progresivamente peores. Cada desastre cambia el cuello de botella y exige una adaptación concreta.

Al abrir el juego aparece una portada desde la que se puede continuar, empezar de cero —con confirmación si ya existe progreso— o salir.

## Controles

- Clic izquierdo sobre la pared: desprender cocaína.
- Clic izquierdo sobre el montón: lanzar una pieza expuesta a la caja.
- Barra espaciadora: clic alternativo.
- `A`, `D` o flechas: desplazar el escenario.
- Cursor en los bordes del área jugable: desplazamiento automático.
- `MENÚ · AUDIO Y PARTIDA` o `Esc`: abre el panel izquierdo de opciones.
- El panel permite guardar, guardar y salir, cerrar el menú y regular por separado música y efectos.
- La partida se guarda cada 10 segundos y al cerrar; el progreso sin conexión está limitado a 4 horas.

## Progresión por fases

Cada cambio de fase abre un diálogo que explica el nuevo problema. La adaptación imprescindible se busca automáticamente en el laboratorio, aparece con el texto `NECESARIA PARA SUPERAR ESTA FASE` y queda rodeada por un halo azul hasta que se compra.

1. `UNA RAYITA PARA DESAYUNAR` — 90%: tutorial de clic, caída, recogida y entrega. La primera oleada desbloquea la `CÉLULA PÚGIL EN PRÁCTICAS`.
2. `¿QUIÉN HA VACIADO EL CÁRTEL?` — 70%: Joe estrena inmediatamente `PULMONES DE DROGATA`; después se repite cada 300 segundos. El apelmazado presentado por la primera rayita se vuelve constante y aparecen los paraguas.
3. `OFERTA DEL SUPERMERCADO` — 52%: cada rayita alterna serrín y yeso, y la tiza conserva su temporizador independiente. Los `QUIMIORRECEPTORES` evitan que el almacén se llene de basura.
4. `SPRAY NASAL DEL BAZAR` — 34%: el spray bloquea y reconstruye pared; el moco verde empieza a repetirse en esta misma fase. Los `MACRÓFAGOS ESPONJA` y las `CATAPULTAS MUCOLÍTICAS` resuelven ambos problemas.
5. `VOLCÁN ZOOLÓGICO` — 18%: comienzan hemorragia, daño tisular, bacterias, plaquetas y cuidadores mientras todas las locuras anteriores continúan activas.

Las fases ya no avanzan por tiempo ni por entregas. Joe empieza al 90% y cada tramo se desbloquea cuando el jugador logra reducir su colocón hasta 70%, 52%, 34% y 18%. Cada umbral provoca inmediatamente la nueva barbaridad y añade su temporizador al repertorio permanente. El medidor principal de colocón ocupa el centro superior: picar la pared lo hace bajar al instante, muestra las unidades reales extraídas y pulsa en azul; almacenar ese mismo polvo no aplica la reducción dos veces. La versión 16 inaugura el modelo masivo de partículas; todos los guardados anteriores quedan invalidados y se eliminan en vez de migrarse.

El panel `PRUEBA DE FASES`, fijado al extremo derecho, permite saltar inmediatamente a cualquiera de las cinco fases. Conserva células, mejoras y paredes, reinicia los indicadores de esa crisis y elimina los recursos futuros al volver hacia atrás.

## Cocaína, apelmazado y transporte

Cada clic crea una bolita individual que cae con suavidad y queda apoyada sobre el suelo o sobre otra pieza. El montón se recalcula por columnas después de cada caída o recogida, por lo que no quedan huecos flotantes. Las bolitas usan menos separación y menos oscilación horizontal; cada aterrizaje corrige picos demasiado finos para conservar montañas y valles con una silueta compacta. Los pedruscos pueden sostener pendientes como muros de contención. El tabique actúa como un límite duro: ningún grano ni pedrusco puede atravesarlo o dibujarse por encima de la pared compacta.

La primera `OTRA RAYITA` presenta el apelmazado antes del umbral del 70%, con un máximo introductorio de dos pedruscos. El primero revela y marca en azul la mejora de cascos. Al entrar en la segunda fase el límite sube a ocho. Un grano con al menos cinco vecinos cercanos forma un pedrusco de seis unidades. Con producción tranquila se comprueba el montón cada 24 aterrizajes; por encima de dos clics por segundo baja a 18 y por encima de cuatro baja a 12. La extracción automática puede llevar la cadencia hasta un mínimo de ocho aterrizajes. Los pedruscos conservan su valor, bloquean la recogida y solo los cascos azules pueden tratarlos y llevarlos.

Los peones recorren un ciclo físico completo: salen vacíos de la caja, rascan exactamente un grano de la pared, esperan la caída, levantan piezas expuestas, muestran la carga delante del cuerpo y la depositan dentro de la caja. Peón y carga pasan a capas de primer plano durante el transporte, por lo que ningún almacén puede ocultarlos. Ese raspado mantiene una producción basal sin competir con los púgiles. `TRABAJO EN CADENA` solo aparece después de perforar el tabique.

Solo los peones blancos rascan la pared. La logística crece como una cadena visible y separada: el cajón inicial admite 1.000 unidades; el `CONTENEDOR DE NIEVE DE EMERGENCIA`, 5.000; su `DOBLE FONDO FARMACÉUTICO`, 15.000; el `SILO DE NIEVE ESTRATÉGICA`, 50.000; y la `PLANTA DE NIEVE INDUSTRIAL`, 500.000. El contenedor queda deliberadamente más lejos que el cajón. El mismo carrito pasa de 12 a 24 y 36 unidades mediante mejoras puramente numéricas, sin vagones ni unidades nuevas. `MEMBRANA CON BOLSILLOS` aumenta la carga de todos los peones presentes y futuros. El `MUGIDÓFILO DE CARGA` y el tren siguen siendo escalones tardíos ya existentes. Ningún transporte mina ni daña bloques desprendidos.

El Expreso se desbloquea al final, después de abrir la segunda fosa y construir la planta. Recoge en la fosa derecha, sale cargado por un túnel del extremo derecho y reaparece por el extremo izquierdo para descargar en la planta. El viaje vacío hace el circuito inverso. No existen vías sobre el tabique ni cruces visibles entre fosas. La caja y cada edificio tienen límite real; cuando se llenan, las entregas se detienen hasta que el jugador gasta cocaína o amplía el almacén.

El jugador también puede intervenir directamente en la logística. Al pulsar sobre cualquier parte ocupada del montón, la pieza superior más cercana describe un arco hasta la caja y sólo se entrega al llegar. Las piezas que aún caen o están enterradas no responden. Los pedruscos siguen necesitando cascos azules, las bacterias necesitan cuidadores y enviar una impureza manualmente ensucia la caja igual que cualquier otra entrega.

## Arquitectura para partículas masivas

El polvo jugable ya no crea un `Sprite2D` por bolita. Cada grano es un objeto de datos ligero y se dibuja mediante `RenderingServer` en `MultiMesh` separados por fosa, textura, material y estado —montaña o carga—. Veinte mil granos equivalentes ocupan muy pocos lotes y añaden cero nodos de partícula al árbol de escenas. Los pedruscos conservan únicamente sus grietas como nodos escasos e interactivos.

Las alturas, superficies, cargas y pedruscos se indexan por fosa y columna. Colocar o consultar una bola no recorre el montón completo; el apelmazado construye una cuadrícula local y solo compara celdas vecinas. Todas las caídas y vuelos manuales comparten un único actualizador, sin un `Tween` por partícula. El tren reclama y deposita cargas masivas por lotes y el guardado agrupa secuencias equivalentes dentro de cada columna.

La prueba de regresión fija veinte mil partículas individuales como carga de referencia: exige cero nodos de polvo, un único lote para una textura común, búsqueda espacial acotada, transporte sin borrado cuadrático y un guardado compacto inferior a 500 KB.

## Pared y colocón de Joe

Las dos paredes tienen 10.000 millones de puntos de resistencia, pero esa cifra aparece como `???` al comenzar. Solo la `RADIOGRAFÍA DE NAPIA`, disponible después de analizar el serrín y el yeso, revela el valor restante. Conservan su anchura completa al 100% y se reducen proporcionalmente hasta un mínimo visual del 5%. Cada punto porcentual atravesado abre o profundiza una muesca azulada claramente acumulativa en el borde libre y desprende polvo visual. El recorte se calcula desde el primer píxel opaco de la silueta, por lo que siempre elimina una parte visible del muro. Cada 10% una de esas fracturas crece, arranca un bloque compacto equivalente y lo deja caer al suelo en su propia capa. Ese bloque contiene 25 unidades reales, pero tiene 24 puntos de resistencia independientes: cada golpe libera solo una parte y el daño manual está limitado a tres, por lo que incluso un clic muy mejorado necesita al menos ocho impactos. El desgaste se comunica mediante grietas y texto, sin la antigua barra horizontal. Al llegar a cero, una pared queda agotada y desaparece definitivamente; no se regenera de golpe.

`COLOCÓN DE JOE` es la carrera global: entregar cocaína limpia baja el valor; las nuevas rayas, la contaminación, el daño tisular y la infección lo elevan. Alcanzar el 100% mata a Joe y abre una decisión: cargar el último guardado o volver al menú. La sobredosis nunca sobrescribe la partida. El jugador ve siempre unidades reales en los impactos —granos robados, salvados por paraguas, absorbidos, restaurados o bloqueados— aunque el balance interno use porcentajes.

Los desastres no forman una ruleta ni pueden cancelarse. Cada fase añade un temporizador propio y todos los anteriores continúan activos: `OTRA RAYITA` cae cada 120 segundos con granos indivisibles de valor 1 y escala según lo minado durante el intervalo anterior; `PULMONES DE DROGATA` actúa cada 300 segundos, roba el 20% del almacén, suma otra lluvia y añade 20 puntos de colocón; la tiza cae cada 180 segundos; al 34% se incorporan juntos el spray y el moco aglutinante; al 18% comienzan el rascado, la hemorragia y las bacterias.

## Automatización de los golpes

La producción automática especializada no está disponible al comenzar. Cada 120 segundos Joe se mete `OTRA RAYITA`: aparece un aviso y una oleada de 240, 360, 600, 1.000, 1.600, 2.600 o 4.000 granos según la extracción reciente. Todos valen exactamente una unidad y ocupan un hueco completo de transporte, de modo que son sabotaje logístico y no paquetes de riqueza. Los granos extraídos por el jugador conservan el valor completo del golpe y solo se distinguen de los de Joe mediante un contorno oscuro pronunciado; nunca revelan su valor ni se fraccionan para entrar en el almacén. Tras la primera avalancha se desbloquea `CÉLULA PÚGIL EN PRÁCTICAS`.

El primer púgil entra con guante rojo y cinta azul, calienta el brazo, atraviesa físicamente la zona de trabajo y suelta siempre diez partículas. Los cuatro rangos producen respectivamente diez bolas de 5, 10, 20 y 50 unidades: impactos totales de 50, 100, 200 y 500. Esa fórmula permanece interna: el impacto solo muestra el daño total. Si surge moco o cae un bloque mientras camina, vuelve a su puesto en vez de congelarse a mitad del recorrido. Cada evolución incorpora capas visibles de guante, cinta, cinturón, insignia y aura, y solo puede comprarse una evolución nueva por fase. El `SINDICATO DEL PUÑO` constituye un salto de cantidad previo: incorpora dos púgiles básicos de una vez sin adelantar su rango. Después llegan tres saltos deliberadamente absurdos: el `PAQUIDERMO LEUCOCITARIO` camina hasta la pared y embiste 120.000 cada veinte segundos; el `CAÑÓN DE CÉLULAS PÚGIL` dispara 750.000 cada catorce; y el `LEUCOCITO SUPERSAIYAN` carga un Kamehameha de 50 millones cada cincuenta. Sus mejoras multiplican esos impactos por cinco, seis y diez respectivamente.

`GUANTES EMPAPADOS EN COCAÍNA` aumenta los granos desprendidos por golpe y `CAMPANA SIN DESCANSO` reduce el intervalo entre rondas. Los recolectores siguen siendo necesarios para convertir el polvo del suelo en células, por lo que producción y logística pueden mejorarse por separado.

Las compras de la fase 1 aparecen de forma escalonada. `BARRIDO CONTINUO` llega pronto: mantener pulsado sobre el montón recoge cada 0,22 segundos y sus dos mejoras bajan el intervalo a 0,14 y 0,09. `NUDILLOS DE QUERATINA` crea cada diez clics tantas bolas adicionales como niveles tenga, y cada bola conserva toda la potencia manual actual; `RITMO DE BAÑO` reduce más adelante los clics necesarios. El carrito recibe dos saltos numéricos y `SINDICATO DEL PUÑO` añade extracción. Adquirir el último salto del carrito o el sindicato desbloquea la `AUTOVÍA LINFÁTICA`. La interfaz no muestra fórmulas de presión ni umbrales: solo avisa que Joe está colocado, inquieto o a punto de cometer una locura.

## Paso a la fosa izquierda

La `TUNELADORA DE NARICES` aparece al alcanzar la fase de spray. Su tecnología abre el paso independientemente de la resistencia de las dos paredes. Al activarla, la cámara puede entrar en la fosa izquierda y los mismos peones cruzan para alternar el trabajo entre ambas paredes.

La ventana es de 1440×810. El escenario interior mide 7.800 píxeles de ancho y se muestra al 62 % de escala. La extensión a ambos lados deja recorrido para convoyes, una planta en la fosa opuesta y el Expreso que da la vuelta a la nariz.

## Estructura

- `scenes/main.tscn`: composición visual, capas e interfaz.
- `scripts/main.gd`: lógica de juego.
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
