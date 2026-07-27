# Big Nose Joe

Clicker 2D hecho con Godot 4.6. Los glóbulos blancos limpian la nariz de Joe mientras él encadena cinco decisiones progresivamente peores. Cada desastre cambia el cuello de botella y exige una adaptación concreta.

Al abrir el juego aparece una portada desde la que se puede continuar, empezar de cero —con confirmación si ya existe progreso— o salir.

## Controles

- Clic izquierdo sobre la pared: desprender cocaína.
- Barra espaciadora: clic alternativo.
- `A`, `D` o flechas: desplazar el escenario.
- Cursor en los bordes del área jugable: desplazamiento automático.
- `GUARDAR Y SALIR`: guarda la partida y cierra el juego.
- La partida se guarda cada 10 segundos y al cerrar; el progreso sin conexión está limitado a 4 horas.

## Progresión por fases

Cada cambio de fase abre un diálogo que explica el nuevo problema. La adaptación imprescindible se busca automáticamente en el laboratorio, aparece con el texto `NECESARIA PARA SUPERAR ESTA FASE` y queda rodeada por un halo azul hasta que se compra.

1. `UNA RAYITA PARA DESAYUNAR`: tutorial de clic, caída, recogida y entrega. No exige una adaptación especial.
2. `¿QUIÉN HA VACIADO EL CÁRTEL?`: los grupos densos se apelmazan en pedruscos. Solo los especialistas de `CASCO AZUL REGLAMENTARIO` pueden abrirlos y transportarlos.
3. `OFERTA DEL SUPERMERCADO`: serrín, yeso y tiza contaminan la caja lentamente. La interfaz muestra cuánto baja la velocidad de descarga y qué porcentaje de células se pierde; la caja también cambia de color. Los `QUIMIORRECEPTORES` separan las impurezas y reducen la contaminación poco a poco.
4. `NARIZ EN MODO VOLCÁN`: el fondo se enrojece, caen gotas desde el techo y comienza el medidor de daño tisular. Las `PLAQUETAS TURBO` reparan el tejido mientras continúa la limpieza.
5. `BIENVENIDOS AL ZOO`: aparecen bacterias que los peones normales ignoran por completo. Solo los cuidadores de `GUANTES DE PROTECTORA` pueden retirarlas y contener la infección.

Las fases ahora necesitan 800, 4.500, 14.000, 32.000 y 75.000 puntos de trabajo respectivamente. La barra de estabilidad muestra el progreso y la condición pendiente. La versión 5 del guardado conserva fase, contaminación, daño, infección, automatización, roles, recursos y estado del montón; las partidas anteriores se migran al cargar.

El panel `PRUEBA DE FASES`, fijado al extremo derecho, permite saltar inmediatamente a cualquiera de las cinco fases. Conserva células, mejoras y paredes, reinicia los indicadores de esa crisis y elimina los recursos futuros al volver hacia atrás.

## Cocaína, apelmazado y transporte

Cada clic crea una bolita individual que cae con suavidad y queda apoyada sobre el suelo o sobre otra pieza. El montón se recalcula por columnas después de cada caída o recogida, por lo que no quedan huecos flotantes. El tabique actúa como un límite duro: ningún grano ni pedrusco puede atravesarlo o dibujarse por encima de la pared compacta.

En la fase 2, un grano con al menos cinco vecinos cercanos forma un pedrusco de seis unidades. Los pedruscos conservan su valor, bloquean la recogida y solo los cascos azules pueden tratarlos y llevarlos.

`APELMAZADO INTELIGENTE` resuelve otro problema: cuando un peón carga seis granos normales, estos se convierten en una sola bola segura de valor seis. Esa bola de transporte no es un pedrusco y cualquier peón puede llevarla.

Los peones recorren un ciclo físico completo: salen vacíos de la caja, minan la pared, esperan la caída, levantan piezas expuestas, muestran la carga junto al cuerpo y la depositan dentro de la caja. `TRABAJO EN CADENA` solo aparece después de perforar el tabique, cuando existen dos fosas entre las que repartir el trabajo.

## Automatización de los golpes

La producción automática no depende de los peones recolectores. `CÉLULA PÚGIL EN PRÁCTICAS` añade pequeños púgiles con guante rojo y cinta azul que golpean la pared por su cuenta. Cada ronda daña la pared, cuenta para desbloquear el tabique y lanza granos físicos al montón.

`GUANTES EMPAPADOS EN COCAÍNA` aumenta los granos desprendidos por golpe y `CAMPANA SIN DESCANSO` reduce el intervalo entre rondas. Los recolectores siguen siendo necesarios para convertir el polvo del suelo en células, por lo que producción y logística pueden mejorarse por separado.

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
