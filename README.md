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
2. `¿QUIÉN HA VACIADO EL CÁRTEL?`: los grupos densos se apelmazan en pedruscos. Solo los especialistas de `CASCO AZUL REGLAMENTARIO` pueden abrirlos y transportarlos; hay que abrir seis para dominar la fase.
3. `OFERTA DEL SUPERMERCADO`: serrín, yeso y tiza ensucian la caja lentamente. El perjuicio no se traduce a porcentajes: se descubre observando su color, la animación de descarga y las recompensas. Los `QUIMIORRECEPTORES` deben filtrar diez muestras.
4. `NARIZ EN MODO VOLCÁN`: el fondo se enrojece, caen gotas desde el techo y comienza el medidor de daño tisular. Las `PLAQUETAS TURBO` reparan el tejido mientras continúa la limpieza.
5. `BIENVENIDOS AL ZOO`: aparecen bacterias que los peones normales ignoran por completo. Solo los cuidadores de `GUANTES DE PROTECTORA` pueden retirarlas y contener la infección.

Las fases necesitan 800, 4.500, 14.000, 32.000 y 75.000 puntos de trabajo, además de usar realmente su mecánica. La barra de estabilidad muestra el progreso y la condición pendiente. La versión 7 del guardado conserva fase, acontecimientos de Joe, objetivos, pronóstico, contaminación, daño, infección, automatización, roles, recursos y estado del montón; las partidas anteriores se migran al cargar.

El panel `PRUEBA DE FASES`, fijado al extremo derecho, permite saltar inmediatamente a cualquiera de las cinco fases. Conserva células, mejoras y paredes, reinicia los indicadores de esa crisis y elimina los recursos futuros al volver hacia atrás.

## Cocaína, apelmazado y transporte

Cada clic crea una bolita individual que cae con suavidad y queda apoyada sobre el suelo o sobre otra pieza. El montón se recalcula por columnas después de cada caída o recogida, por lo que no quedan huecos flotantes. Las tandas van cambiando de zona de vertido y forman montañas conectadas; las pendientes demasiado bruscas producen pequeños corrimientos y la recogida abre valles visibles. Los pedruscos pueden sostener pendientes como muros de contención. El tabique actúa como un límite duro: ningún grano ni pedrusco puede atravesarlo o dibujarse por encima de la pared compacta.

En la fase 2, un grano con al menos cinco vecinos cercanos forma un pedrusco de seis unidades. Los pedruscos conservan su valor, bloquean la recogida y solo los cascos azules pueden tratarlos y llevarlos.

`APELMAZADO INTELIGENTE` resuelve otro problema: cuando un peón carga seis granos normales, estos se convierten en una sola bola segura de valor seis. Esa bola de transporte no es un pedrusco y cualquier peón puede llevarla.

Los peones recorren un ciclo físico completo: salen vacíos de la caja, rascan exactamente un grano de la pared, esperan la caída, levantan piezas expuestas, muestran la carga junto al cuerpo y la depositan dentro de la caja. Ese raspado mantiene una producción basal sin competir con los púgiles. `TRABAJO EN CADENA` solo aparece después de perforar el tabique.

El jugador también puede intervenir directamente en la logística. Al pulsar sobre cualquier parte ocupada del montón, la pieza superior más cercana describe un arco hasta la caja y sólo se entrega al llegar. Las piezas que aún caen o están enterradas no responden. Los pedruscos siguen necesitando cascos azules, las bacterias necesitan cuidadores y enviar una impureza manualmente ensucia la caja igual que cualquier otra entrega.

## Pared y pronóstico de Joe

La pared conserva su anchura completa al 100% y se reduce proporcionalmente hasta un mínimo visual del 5%. Cada punto porcentual de resistencia atravesado desprende fragmentos y añade un nuevo mordisco transparente al borde libre. Por debajo del 10% queda una tira muy fina y especialmente irregular, siempre pegada al tabique. La textura original no se modifica: el dentado vive en un shader independiente y los fragmentos en la capa de efectos.

`PRONÓSTICO DE JOE` resume la evolución global sin revelar el cuello de botella concreto. Retirar cocaína limpia de la nariz lo mejora; las nuevas rayas producen retrocesos y una montaña excesiva, la contaminación, el daño tisular o la infección lo erosionan lentamente. Llegar a cero todavía no causa una derrota: primero debe demostrar que aporta decisiones interesantes.

## Automatización de los golpes

La producción automática especializada no está disponible al comenzar. Cada 180 segundos Joe se mete `OTRA RAYITA`: aparece un aviso y una oleada de cocaína pura levanta varias lomas sobre el montón existente. Tras la primera avalancha se desbloquea `CÉLULA PÚGIL EN PRÁCTICAS`.

El primer púgil entra con guante rojo y cinta azul, calienta el brazo, atraviesa físicamente la zona de trabajo y estrena su contrato contra el borde visible de la pared con un golpe especial de doce granos. Después de cada impacto regresa a su posición de espera. Las rondas posteriores repiten ese ciclo; el punto de contacto acompaña a la pared mientras se estrecha. Cada ronda daña la pared, cuenta para desbloquear el tabique y lanza granos físicos desde el lugar exacto del golpe.

`GUANTES EMPAPADOS EN COCAÍNA` aumenta los granos desprendidos por golpe y `CAMPANA SIN DESCANSO` reduce el intervalo entre rondas. Los recolectores siguen siendo necesarios para convertir el polvo del suelo en células, por lo que producción y logística pueden mejorarse por separado.

Las compras de la fase 1 aparecen de forma escalonada según el trabajo entregado. `NUDILLOS DE QUERATINA` crea una ráfaga cada diez clics y `RITMO DE BAÑO` reduce más adelante los clics necesarios. La interfaz nunca identifica un cuello de botella: el jugador lo deduce viendo crecer el montón, observando cargas pequeñas o notando cómo se comporta la caja.

## Paso a la fosa izquierda

La primera pared derecha necesita unos 20.000 clics base. Al alcanzar 40.000 clics totales aparece `PERFORAR TABIQUE`. Al comprarla, la cámara puede entrar en la fosa izquierda y los mismos peones cruzan para continuar minando la pared adherida al otro lado.

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
