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
2. `¿QUIÉN HA VACIADO EL CÁRTEL?` — 70%: Joe estrena inmediatamente `PULMONES DE DROGATA`; después se repite cada 300 segundos. Aparecen apelmazados, cascos azules y paraguas.
3. `OFERTA DEL SUPERMERCADO` — 52%: cada rayita alterna serrín y yeso, y la tiza conserva su temporizador independiente. Los `QUIMIORRECEPTORES` evitan que el almacén se llene de basura.
4. `SPRAY NASAL DEL BAZAR` — 34%: el spray bloquea y reconstruye pared; el moco verde empieza a repetirse en esta misma fase. Los `MACRÓFAGOS ESPONJA` y las `CATAPULTAS MUCOLÍTICAS` resuelven ambos problemas.
5. `VOLCÁN ZOOLÓGICO` — 18%: comienzan hemorragia, daño tisular, bacterias, plaquetas y cuidadores mientras todas las locuras anteriores continúan activas.

Las fases ya no avanzan por tiempo ni por entregas. Joe empieza al 90% y cada tramo se desbloquea cuando el jugador logra reducir su colocón hasta 70%, 52%, 34% y 18%. Cada umbral provoca inmediatamente la nueva barbaridad y añade su temporizador al repertorio permanente. La barra lateral representa la presión ejercida sobre Joe hasta su siguiente reacción. La versión 14 del guardado conserva los umbrales, las crisis, las paredes y todos los temporizadores; las partidas anteriores se migran al cargar.

El panel `PRUEBA DE FASES`, fijado al extremo derecho, permite saltar inmediatamente a cualquiera de las cinco fases. Conserva células, mejoras y paredes, reinicia los indicadores de esa crisis y elimina los recursos futuros al volver hacia atrás.

## Cocaína, apelmazado y transporte

Cada clic crea una bolita individual que cae con suavidad y queda apoyada sobre el suelo o sobre otra pieza. El montón se recalcula por columnas después de cada caída o recogida, por lo que no quedan huecos flotantes. Las tandas van cambiando de zona de vertido y forman montañas conectadas; las pendientes demasiado bruscas producen pequeños corrimientos y la recogida abre valles visibles. Los pedruscos pueden sostener pendientes como muros de contención. El tabique actúa como un límite duro: ningún grano ni pedrusco puede atravesarlo o dibujarse por encima de la pared compacta.

En la fase 2, un grano con al menos cinco vecinos cercanos forma un pedrusco de seis unidades. Los pedruscos conservan su valor, bloquean la recogida y solo los cascos azules pueden tratarlos y llevarlos.

Los peones recorren un ciclo físico completo: salen vacíos de la caja, rascan exactamente un grano de la pared, esperan la caída, levantan piezas expuestas, muestran la carga junto al cuerpo y la depositan dentro de la caja. Ese raspado mantiene una producción basal sin competir con los púgiles. `TRABAJO EN CADENA` solo aparece después de perforar el tabique.

Solo los peones blancos rascan la pared. La logística crece como una cadena visible y separada: el cajón inicial admite 1.000 unidades; el `CONTENEDOR DE NIEVE DE EMERGENCIA`, 5.000; el `SILO DE NIEVE ESTRATÉGICA`, 50.000; y la `PLANTA DE NIEVE INDUSTRIAL`, 500.000. El carrito mueve 12 granos por viaje, el `MUGIDÓFILO DE CARGA` tira de tres carros con 40 y el `EXPRESO LEUCOCITARIO` recoge todo el polvo normal disponible. Ninguno mina ni daña bloques desprendidos. Si uno de esos bloques corta el paso, la logística espera hasta que el jugador lo pique.

El Expreso se desbloquea al final, después de abrir la segunda fosa y construir la planta. Recoge en la fosa derecha, sale cargado por un túnel del extremo derecho y reaparece por el extremo izquierdo para descargar en la planta. El viaje vacío hace el circuito inverso. No existen vías sobre el tabique ni cruces visibles entre fosas. La caja y cada edificio tienen límite real; cuando se llenan, las entregas se detienen hasta que el jugador gasta cocaína o amplía el almacén.

El jugador también puede intervenir directamente en la logística. Al pulsar sobre cualquier parte ocupada del montón, la pieza superior más cercana describe un arco hasta la caja y sólo se entrega al llegar. Las piezas que aún caen o están enterradas no responden. Los pedruscos siguen necesitando cascos azules, las bacterias necesitan cuidadores y enviar una impureza manualmente ensucia la caja igual que cualquier otra entrega.

## Pared y colocón de Joe

Las dos paredes tienen 10.000 millones de puntos de resistencia. Conservan su anchura completa al 100% y se reducen proporcionalmente hasta un mínimo visual del 5%. Cada punto porcentual atravesado abre o profundiza una muesca azulada claramente acumulativa en el borde libre y desprende polvo visual. El recorte se calcula desde el primer píxel opaco de la silueta, por lo que siempre elimina una parte visible del muro. Cada 10% una de esas fracturas crece, arranca un bloque compacto equivalente y lo deja caer al suelo en su propia capa. Ese bloque contiene 25 unidades reales, pero tiene 24 puntos de resistencia independientes: cada golpe libera solo una parte y el daño manual está limitado a tres, por lo que incluso un clic muy mejorado necesita al menos ocho impactos. El desgaste se comunica mediante grietas y texto, sin la antigua barra horizontal. Al llegar a cero, una pared queda agotada y desaparece definitivamente; no se regenera de golpe.

`COLOCÓN DE JOE` es la carrera global: entregar cocaína limpia baja el valor; las nuevas rayas, la contaminación, el daño tisular y la infección lo elevan. Alcanzar el 100% mata a Joe y abre una decisión: cargar el último guardado o volver al menú. La sobredosis nunca sobrescribe la partida. El jugador ve siempre unidades reales en los impactos —granos robados, salvados por paraguas, absorbidos, restaurados o bloqueados— aunque el balance interno use porcentajes.

Los desastres no forman una ruleta ni pueden cancelarse. Cada fase añade un temporizador propio y todos los anteriores continúan activos: `OTRA RAYITA` cae cada 120 segundos con 200.000 unidades; `PULMONES DE DROGATA` actúa cada 300 segundos, roba el 20% del almacén, suma otra lluvia y añade 20 puntos de colocón; la tiza cae cada 180 segundos; al 34% se incorporan juntos el spray y el moco aglutinante; al 18% comienzan el rascado, la hemorragia y las bacterias.

## Automatización de los golpes

La producción automática especializada no está disponible al comenzar. Cada 120 segundos Joe se mete `OTRA RAYITA`: aparece un aviso y una oleada calibrada de 200.000 unidades representadas por 200 bultos. La lluvia ya no se calcula como porcentaje de la pared: hacerlo con paredes de 10.000 millones rompería la caja inicial y toda la economía. Tras la primera avalancha se desbloquea `CÉLULA PÚGIL EN PRÁCTICAS`.

El primer púgil entra con guante rojo y cinta azul, calienta el brazo, atraviesa físicamente la zona de trabajo y golpea 50 unidades. Sus cuatro rangos saltan a 300, 1.800 y 12.000 por golpe mientras el intervalo baja de 4 a 2,2 segundos antes de las mejoras de campana. Después llegan tres saltos deliberadamente absurdos: el `PAQUIDERMO LEUCOCITARIO` camina hasta la pared y embiste 120.000 cada veinte segundos; el `CAÑÓN DE CÉLULAS PÚGIL` dispara 750.000 cada catorce; y el `LEUCOCITO SUPERSAIYAN` carga un Kamehameha de 50 millones cada cincuenta. Sus mejoras multiplican esos impactos por cinco, seis y diez respectivamente.

`GUANTES EMPAPADOS EN COCAÍNA` aumenta los granos desprendidos por golpe y `CAMPANA SIN DESCANSO` reduce el intervalo entre rondas. Los recolectores siguen siendo necesarios para convertir el polvo del suelo en células, por lo que producción y logística pueden mejorarse por separado.

Las compras de la fase 1 aparecen de forma escalonada según el trabajo entregado. `NUDILLOS DE QUERATINA` crea una ráfaga cada diez clics y `RITMO DE BAÑO` reduce más adelante los clics necesarios. La interfaz nunca identifica un cuello de botella: el jugador lo deduce viendo crecer el montón, observando cargas pequeñas o notando cómo se comporta la caja.

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
