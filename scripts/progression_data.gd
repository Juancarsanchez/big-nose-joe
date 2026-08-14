extends RefCounted

const PHASES := [
	{
		"id": 1,
		"title": "UNA RAYITA PARA DESAYUNAR",
		"joe": "Joe ha decidido que el desayuno equilibrado era opcional.",
		"problem": "Joe empieza con un 90% de colocón. Límpialo y, cuando baje del 70%, descubrirá una manera mucho peor de seguir drogado.",
		"trigger_high": 90.0
	},
	{
		"id": 2,
		"title": "¿QUIÉN HA VACIADO EL CÁRTEL?",
		"joe": "Joe ha confundido una dosis con el inventario completo.",
		"problem": "Al bajar del 70%, Pulmones de Drogata roba almacén, añade otra lluvia y recupera 20 puntos de colocón. Desde ahora se repetirá cada 300 segundos.",
		"trigger_high": 70.0
	},
	{
		"id": 3,
		"title": "OFERTA DEL SUPERMERCADO",
		"joe": "Joe ha comprado una ganga. La ganga contiene serrín, yeso y decisiones.",
		"problem": "Al bajar del 52%, Joe empieza a adulterar las rayitas con serrín, yeso y tiza. El almacén puede quedar completamente bloqueado.",
		"trigger_high": 52.0
	},
	{
		"id": 4,
		"title": "SPRAY NASAL DEL BAZAR",
		"joe": "Joe cree que la humedad es una ciencia y él, por desgracia, es investigador.",
		"problem": "Al bajar del 34%, el spray vuelve a pegar cocaína a la pared y el moco bloquea la minería. Esponjas y catapultas pasan a ser esenciales.",
		"trigger_high": 34.0
	},
	{
		"id": 5,
		"title": "VOLCÁN ZOOLÓGICO",
		"joe": "Joe se rasca, sangra y convierte la nariz en alojamiento rural para bacterias.",
		"problem": "Al bajar del 18%, comienzan hemorragias e infección. Desde aquí la carrera continúa con todas las locuras anteriores activas.",
		"trigger_high": 18.0
	}
]

const UPGRADES := [
	{"id":"nails", "phase":1, "name":"UÑAS DE QUERATINA", "desc":"Duplica la potencia manual completa.", "base":20.0, "growth":2.35, "kind":"click", "power":2.0, "max":8},
	{"id":"pawn", "phase":1, "unlock_at":35.0, "name":"OTRO PEÓN BÁSICO", "desc":"Añade otro ciclo visible de raspado, recogida y transporte.", "base":55.0, "growth":2.0, "kind":"pawn", "power":1.0, "max":8},
	{"id":"continuous_sweep", "phase":1, "unlock_at":55.0, "name":"BARRIDO CONTINUO", "desc":"Mantén pulsado sobre el montón para enviar granos a la caja sin machacar el ratón.", "base":80.0, "growth":4.0, "kind":"manual_sweep", "power":1.0, "max":3},
	{"id":"click_burst", "phase":1, "unlock_at":90.0, "name":"NUDILLOS DE QUERATINA", "desc":"Cada cierto ritmo de clics repite varias veces toda tu potencia manual.", "base":140.0, "growth":1.82, "kind":"click_burst", "power":1.0, "max":5},
	{"id":"container", "phase":1, "unlock_at":150.0, "name":"CONTENEDOR DE NIEVE DE EMERGENCIA", "desc":"Sustituye el cajón de mil unidades por un almacén decente.", "base":500.0, "growth":1.0, "kind":"storage", "power":5000.0, "max":1},
	{"id":"cart", "phase":1, "requires_upgrade":"container", "name":"CARRITO VESICULAR", "desc":"Un transportista separado recoge doce unidades sin minar la pared.", "base":900.0, "growth":1.0, "kind":"transport_cart", "power":12.0, "max":1},
	{"id":"pawn_capacity", "phase":1, "requires_upgrade":"pawn", "name":"MEMBRANA CON BOLSILLOS", "desc":"Cada peón carga una bola más por viaje; también mejora los peones que compres después.", "base":700.0, "growth":2.8, "kind":"pawn_capacity", "power":1.0, "max":4},
	{"id":"puncher", "phase":1, "requires_puncher_unlock":true, "name":"CÉLULA PÚGIL EN PRÁCTICAS", "desc":"Contrata un púgil. La cuadrilla está limitada a cuatro.", "base":180.0, "growth":2.5, "kind":"autoclicker", "power":1.0, "max":4},
	{"id":"cart_reinforced", "phase":1, "requires_upgrade":"cart", "name":"EJES VESICULARES REFORZADOS", "desc":"El mismo carrito aguanta el doble sin crear otra unidad.", "base":1500.0, "growth":1.0, "kind":"transport_capacity", "power":24.0, "max":1},
	{"id":"cart_upgrade", "phase":1, "requires_upgrades":["cart_reinforced", "puncher"], "name":"CARGA VESICULAR COMPRIMIDA", "desc":"El mismo carrito transporta treinta y seis unidades por viaje.", "base":2600.0, "growth":1.0, "kind":"transport_capacity", "power":36.0, "max":1},
	{"id":"punch_union", "phase":1, "requires_upgrades":["cart", "puncher"], "name":"SINDICATO DEL PUÑO", "desc":"Dos púgiles básicos se incorporan juntos a la cuadrilla.", "base":2000.0, "growth":1.0, "kind":"punch_union", "power":2.0, "max":1},
	{"id":"shift", "phase":1, "requires_any_upgrades":["cart_upgrade", "punch_union"], "name":"AUTOVÍA LINFÁTICA", "desc":"Acelera un 60% los peones y un 35% todo el transporte terrestre.", "base":3500.0, "growth":1.0, "kind":"speed", "power":1.0, "max":1},
	{"id":"container_capacity", "phase":1, "requires_upgrades":["container", "cart"], "name":"DOBLE FONDO FARMACÉUTICO", "desc":"Amplía el contenedor existente hasta quince mil unidades.", "base":4500.0, "growth":1.0, "kind":"storage", "power":15000.0, "max":1},
	{"id":"punch_power", "phase":1, "requires_upgrade":"puncher", "name":"CARNÉ DE PESO LEUCOCITARIO", "desc":"Evoluciona a toda la cuadrilla: federado, peso pesado y demoledor.", "base":650.0, "growth":4.2, "kind":"auto_power", "power":6.0, "max":3},
	{"id":"click_rhythm", "phase":2, "requires_upgrade":"click_burst", "name":"RITMO DE BAÑO", "desc":"Necesitas menos clics para provocar cada ráfaga manual.", "base":800.0, "growth":2.0, "kind":"click_rhythm", "power":1.0, "max":4},
	{"id":"punch_speed", "phase":2, "requires_upgrade":"puncher", "name":"CAMPANA SIN DESCANSO", "desc":"Acorta el descanso de todos los púgiles sin quitarles su carrera hasta la pared.", "base":1400.0, "growth":2.8, "kind":"auto_speed", "power":0.15, "max":4},
	{"id":"coord", "phase":2, "requires_septum":true, "name":"TRABAJO EN CADENA", "desc":"Reparte peones entre las dos fosas y prioriza los atascos.", "base":550.0, "growth":2.4, "kind":"coordination", "power":1.0, "max":2},
	{"id":"breaker", "phase":1, "requires_compaction":true, "name":"CASCO AZUL REGLAMENTARIO", "desc":"Especializa peones para abrir apelmazados; cuanto más minas, más necesarios se vuelven.", "base":850.0, "growth":2.25, "kind":"specialist", "power":1.0, "max":3},
	{"id":"silo", "phase":2, "requires_upgrades":["container_capacity", "cart"], "name":"SILO DE NIEVE ESTRATÉGICA", "desc":"Almacena hasta cincuenta mil unidades para compras de verdad.", "base":12000.0, "growth":1.0, "kind":"storage", "power":50000.0, "max":1},
	{"id":"ox_convoy", "phase":2, "requires_upgrade":"silo", "name":"MUGIDÓFILO DE CARGA", "desc":"Una célula-buey tira de tres carros y transporta cuarenta unidades.", "base":12000.0, "growth":1.0, "kind":"transport_ox", "power":40.0, "max":1},
	{"id":"umbrella", "phase":2, "name":"GLÓBULO CON PARAGUAS ROSA", "desc":"Un peón normal con paraguas salva un 5% del robo de Pulmones de Drogata.", "base":1800.0, "growth":3.2, "kind":"umbrella", "power":0.05, "max":3},
	{"id":"umbrella_power", "phase":2, "requires_upgrade":"umbrella", "name":"TELA ANTIPULMONES", "desc":"Añade un 15% de protección total por nivel, hasta un máximo del 90%.", "base":9000.0, "growth":3.6, "kind":"umbrella_power", "power":0.15, "max":5},
	{"id":"detector", "phase":3, "name":"QUIMIORRECEPTORES", "desc":"Detectan serrín, yeso y tiza: los demás peones dejan de llevar basura al almacén.", "base":1250.0, "growth":2.15, "kind":"detector", "power":1.0, "max":3},
	{"id":"wall_scan", "phase":3, "requires_upgrade":"detector", "name":"RADIOGRAFÍA DE NAPIA", "desc":"Después de analizar la porquería, revela la resistencia exacta de las paredes.", "base":3500.0, "growth":1.0, "kind":"wall_scan", "power":1.0, "max":1},
	{"id":"sorting", "phase":3, "name":"RECONOCIMIENTO MOLECULAR", "desc":"Reduce la proporción de impurezas que atasca cada turno.", "base":2100.0, "growth":2.35, "kind":"sorting", "power":0.08, "max":3},
	{"id":"sponge", "phase":4, "name":"MACRÓFAGO ESPONJA", "desc":"Absorbe la película azul del spray; mientras exista, la pared no se puede minar.", "base":6500.0, "growth":4.0, "kind":"sponge", "power":40.0, "max":2},
	{"id":"sponge_power", "phase":4, "requires_upgrade":"sponge", "name":"ESPONJOSIDAD PROHIBIDA", "desc":"La esponja crece y multiplica las unidades de spray absorbidas cada segundo.", "base":18000.0, "growth":3.8, "kind":"sponge_power", "power":1.8, "max":5},
	{"id":"elephant", "phase":3, "requires_upgrade":"puncher", "name":"PAQUIDERMO LEUCOCITARIO", "desc":"Una célula-elefante avanza despacio y embiste la pared cada veinte segundos.", "base":25000.0, "growth":1.0, "kind":"elephant", "power":120000.0, "max":1},
	{"id":"elephant_power", "phase":3, "requires_upgrade":"elephant", "name":"MEMORIA DE ELEFANTE MUSCULAR", "desc":"Multiplica por cinco el cabezazo del paquidermo.", "base":60000.0, "growth":2.5, "kind":"elephant_power", "power":5.0, "max":3},
	{"id":"platelets", "phase":5, "name":"PLAQUETAS TURBO", "desc":"Convoca dos reparadoras coral que priorizan las heridas abiertas.", "base":3200.0, "growth":1.85, "kind":"platelet", "power":1.0, "max":6},
	{"id":"repair", "phase":5, "requires_upgrade":"platelets", "name":"PLAQUETAS GRAPADORAS", "desc":"Evoluciona la reparación de puntada a sutura industrial.", "base":5200.0, "growth":3.0, "kind":"repair", "power":2.5, "max":5},
	{"id":"pugilist_cannon", "phase":4, "requires_upgrade":"elephant", "name":"CAÑÓN DE CÉLULAS PÚGIL", "desc":"Dispara leucocitos de cabeza contra la pared con absoluta irresponsabilidad.", "base":75000.0, "growth":1.0, "kind":"pugilist_cannon", "power":750000.0, "max":1},
	{"id":"cannon_power", "phase":4, "requires_upgrade":"pugilist_cannon", "name":"PÓLVORA HEMATOPOYÉTICA", "desc":"Multiplica por seis cada proyectil celular.", "base":130000.0, "growth":1.9, "kind":"cannon_power", "power":6.0, "max":3},
	{"id":"plant", "phase":4, "requires_upgrade":"ox_convoy", "requires_septum":true, "name":"PLANTA DE NIEVE INDUSTRIAL", "desc":"Una refinería en la otra fosa eleva el almacén a medio millón.", "base":40000.0, "growth":1.0, "kind":"storage", "power":500000.0, "max":1},
	{"id":"handlers", "phase":5, "name":"GUANTES DE PROTECTORA", "desc":"Cuidadores que recogen bacterias sin dejar que les muerdan.", "base":7200.0, "growth":2.0, "kind":"handler", "power":1.0, "max":4},
	{"id":"signals", "phase":5, "name":"SEÑALES QUÍMICAS", "desc":"Coordina cuidadores, plaquetas y peones sin una sola reunión.", "base":10500.0, "growth":2.2, "kind":"signals", "power":0.12, "max":3},
	{"id":"catapult", "phase":4, "name":"CATAPULTA MUCOLÍTICA", "desc":"Cada máquina lanza un glóbulo y arranca 600 unidades de moco cada 2,8 segundos.", "base":75000.0, "growth":3.0, "kind":"catapult", "power":600.0, "max":2},
	{"id":"catapult_power", "phase":4, "requires_upgrade":"catapult", "name":"TENSIÓN DE MEMBRANA", "desc":"Duplica el impacto de todos los proyectiles mucolíticos.", "base":100000.0, "growth":1.45, "kind":"catapult_power", "power":2.0, "max":4},
	{"id":"supersaiyan", "phase":5, "requires_upgrade":"pugilist_cannon", "name":"LEUCOCITO SUPERSAIYAN", "desc":"Carga durante un siglo emocional y lanza un Kamehameha de daño obsceno.", "base":250000.0, "growth":1.0, "kind":"supersaiyan", "power":50000000.0, "max":1},
	{"id":"supersaiyan_power", "phase":5, "requires_upgrade":"supersaiyan", "name":"GRITOS DE CINCO EPISODIOS", "desc":"Multiplica por diez el Kamehameha. No existe ningún comité de seguridad.", "base":300000.0, "growth":1.6, "kind":"supersaiyan_power", "power":10.0, "max":2},
	{"id":"train", "phase":5, "requires_upgrade":"plant", "requires_septum":true, "name":"EXPRESO LEUCOCITARIO", "desc":"Carga en la fosa derecha y cruza por túneles hasta la planta izquierda.", "base":150000.0, "growth":1.0, "kind":"transport_train", "power":1.0, "max":1}
]
