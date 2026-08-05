# Big Nose Joe

Clicker 2D hecho con Godot 4.6. Los glóbulos blancos limpian la nariz de Joe mientras él encadena cinco decisiones progresivamente peores. Cada desastre cambia el cuello de botella y exige una adaptación concreta.

Al abrir el juego aparece una portada desde la que se puede continuar, empezar de cero —con confirmación si ya existe progreso— o salir.

## Controles

- Clic izquierdo sobre la pared: desprender cocaína.
- Clic izquierdo sobre el montón: lanzar una pieza expuesta a la caja.
- Barra espaciadora: clic alternativo.
- `A`, `D` o flechas: desplazar el escenario.
- Cursor en los bordes del área jugable: desplazamiento automático.
- `GUARDAR Y SALIR`: guarda la partida y cierra el juego.
- La partida se guarda cada 10 segundos y al cerrar; el progreso sin conexión está limitado a 4 horas.

## Progresión por fases

Cada cambio de fase abre un diálogo que explica el nuevo problema. La adaptación imprescindible se busca automáticamente en el laboratorio, aparece con el texto `NECESARIA PARA SUPERAR ESTA FASE` y queda rodeada por un halo azul hasta que se compra.

1. `UNA RAYITA PARA DESAYUNAR`: tutorial de clic, caída, recogida y entrega. La primera gran oleada desbloquea la adaptación `CÉLULA PÚGIL EN PRÁCTICAS`.
2. `¿QUIÉN HA VACIADO EL CÁRTEL?`: los grupos densos se apelmazan en pedruscos. Solo los especialistas de `CASCO AZUL REGLAMENTARIO` pueden abrirlos y transportarlos; `PULMONES DE DROGATA` roba almacén y los glóbulos con `PARAGUAS ROSA HOMOLOGADO` amortiguan la pérdida.
3. `OFERTA DEL SUPERMERCADO`: cada rayita trae serrín, Joe añade tiza con su propio ritmo y el `SPRAY NASAL DEL BAZAR` vuelve a pegar cocaína a la pared treinta segundos después. Los `QUIMIORRECEPTORES` limpian una caja atascada y los `MACRÓFAGOS ESPONJA` absorben cantidades crecientes del spray.
4. `NARIZ EN MODO VOLCÁN`: el fondo se enrojece, caen gotas desde el techo y comienza el medidor de daño tisular. El rascado de Joe abre heridas visibles; las `PLAQUETAS TURBO` y `PLAQUETAS GRAPADORAS` reparan el tejido.
5. `BIENVENIDOS AL ZOO`: aparecen bacterias que los peones normales ignoran por completo y moco verde que impide minar la pared. Los cuidadores de `GUANTES DE PROTECTORA` retiran bacterias y las `CATAPULTAS MUCOLÍTICAS` lanzan glóbulos contra el bloqueo.

Las fases necesitan 1.500, 12.000, 35.000, 80.000 y 180.000 puntos de trabajo, además de usar realmente su mecánica. La barra de estabilidad muestra el progreso y la condición pendiente. La versión 10 del guardado conserva fase, temporizadores independientes de Joe, colocón, atasco de la caja, daño, infección, adaptaciones, recursos, estado del montón y resistencia de los bloques desprendidos; las partidas anteriores se migran al cargar.

El panel `PRUEBA DE FASES`, fijado al extremo derecho, permite saltar inmediatamente a cualquiera de las cinco fases. Conserva células, mejoras y paredes, reinicia los indicadores de esa crisis y elimina los recursos futuros al volver hacia atrás.

## Cocaína, apelmazado y transporte

Cada clic crea una bolita individual que cae con suavidad y queda apoyada sobre el suelo o sobre otra pieza. El montón se recalcula por columnas después de cada caída o recogida, por lo que no quedan huecos flotantes. Las tandas van cambiando de zona de vertido y forman montañas conectadas; las pendientes demasiado bruscas producen pequeños corrimientos y la recogida abre valles visibles. Los pedruscos pueden sostener pendientes como muros de contención. El tabique actúa como un límite duro: ningún grano ni pedrusco puede atravesarlo o dibujarse por encima de la pared compacta.

En la fase 2, un grano con al menos cinco vecinos cercanos forma un pedrusco de seis unidades. Los pedruscos conservan su valor, bloquean la recogida y solo los cascos azules pueden tratarlos y llevarlos.

Los peones recorren un ciclo físico completo: salen vacíos de la caja, rascan exactamente un grano de la pared, esperan la caída, levantan piezas expuestas, muestran la carga junto al cuerpo y la depositan dentro de la caja. Ese raspado mantiene una producción basal sin competir con los púgiles. `TRABAJO EN CADENA` solo aparece después de perforar el tabique.

El jugador también puede intervenir directamente en la logística. Al pulsar sobre cualquier parte ocupada del montón, la pieza superior más cercana describe un arco hasta la caja y sólo se entrega al llegar. Las piezas que aún caen o están enterradas no responden. Los pedruscos siguen necesitando cascos azules, las bacterias necesitan cuidadores y enviar una impureza manualmente ensucia la caja igual que cualquier otra entrega.

## Pared y colocón de Joe

La pared derecha tiene 120.000 puntos de resistencia y la izquierda 180.000. Conservan su anchura completa al 100% y se reducen proporcionalmente hasta un mínimo visual del 5%. Cada punto porcentual atravesado abre o profundiza una muesca azulada claramente acumulativa en el borde libre y desprende polvo visual. El recorte se calcula desde el primer píxel opaco de la silueta, por lo que siempre elimina una parte visible del muro. Cada 10% una de esas fracturas crece, arranca un bloque compacto equivalente y lo deja caer al suelo en su propia capa. Ese bloque contiene 25 unidades reales, pero tiene 24 puntos de resistencia independientes y una barra visible: cada golpe libera solo una parte y el daño manual está limitado a tres, por lo que incluso un clic muy mejorado necesita al menos ocho impactos. Al llegar a cero, una pared queda agotada y desaparece definitivamente; no se regenera de golpe.

`COLOCÓN DE JOE` es la carrera global: entregar cocaína limpia baja el valor; las nuevas rayas, la contaminación, el daño tisular y la infección lo elevan. El jugador ve siempre unidades reales en los impactos —granos robados, absorbidos, restaurados o bloqueados— aunque el balance interno use porcentajes.

Los desastres no forman una ruleta ni pueden cancelarse. Cada fase añade un temporizador propio y todos los anteriores continúan activos: `OTRA RAYITA` cae cada 120 segundos con 1.200 unidades; `PULMONES DE DROGATA` actúa cada 300 segundos, roba el 20% del almacén, suma otra lluvia y añade 20 puntos de colocón; la tiza cae cada 180 segundos; el spray vuelve a recubrir hasta 2.400 puntos de pared tras 30 segundos; después se incorporan el rascado y el moco aglutinante. Las adaptaciones reducen el golpe, nunca impiden que Joe fastidie la partida.

## Automatización de los golpes

La producción automática especializada no está disponible al comenzar. Cada 120 segundos Joe se mete `OTRA RAYITA`: aparece un aviso y una oleada de exactamente 1.200 unidades —el 1% de la resistencia inicial de la pared derecha— levanta varias lomas sobre el montón existente. Tras la primera avalancha se desbloquea `CÉLULA PÚGIL EN PRÁCTICAS`.

El primer púgil entra con guante rojo y cinta azul, calienta el brazo, atraviesa físicamente la zona de trabajo y estrena su contrato contra el borde visible de la pared con un golpe especial de doce granos. Después de cada impacto regresa a su posición de espera. Las rondas posteriores repiten ese ciclo; el punto de contacto acompaña a la pared mientras se estrecha. Cada ronda acerca la pared al 50% que desbloquea la tuneladora y lanza granos físicos desde el lugar exacto del golpe.

`GUANTES EMPAPADOS EN COCAÍNA` aumenta los granos desprendidos por golpe y `CAMPANA SIN DESCANSO` reduce el intervalo entre rondas. Los recolectores siguen siendo necesarios para convertir el polvo del suelo en células, por lo que producción y logística pueden mejorarse por separado.

Las compras de la fase 1 aparecen de forma escalonada según el trabajo entregado. `NUDILLOS DE QUERATINA` crea una ráfaga cada diez clics y `RITMO DE BAÑO` reduce más adelante los clics necesarios. La interfaz nunca identifica un cuello de botella: el jugador lo deduce viendo crecer el montón, observando cargas pequeñas o notando cómo se comporta la caja.

## Paso a la fosa izquierda

Cuando la pared derecha baja al 50% aparece `TUNELADORA DE NARICES`. Al activarla, la cámara puede entrar en la fosa izquierda y los mismos peones cruzan para alternar el trabajo entre ambas paredes.

La ventana es de 1440×810. El escenario interior mide 5200 píxeles de ancho y se muestra al 68 % de escala, dejando espacio para edificios y acontecimientos futuros.

## Estructura

- `scenes/main.tscn`: composición visual, capas e interfaz.
- `scripts/main.gd`: lógica de juego.
- `scripts/progression_data.gd`: fases, textos, costes y adaptaciones.
- `assets/art/gameplay/sprites`: peones, caja, paredes y recursos.
- `assets/art/gameplay/background`: fondo panorámico de la cavidad nasal.
- `assets/art/gameplay/environment`: tabique completo y pieza perforable.
- `assets/art/gameplay/source`: originales con fondo de recorte.
- `assets/joe_theme.tres`: colores y estilos de interfaz.
- `tests`: pruebas de progresión, apilado y capturas visuales.

Consulta `ART_DIRECTION.md` para mantener el estilo y la separación por capas.
