extends RefCounted

const PHASES := [
	{
		"id": 1,
		"title": "UNA RAYITA PARA DESAYUNAR",
		"joe": "Joe ha decidido que el desayuno equilibrado era opcional.",
		"problem": "Cada 120 segundos Joe añade 1.200 unidades. Aprende a limpiar, transportar y automatizar antes de que su colocón gane la carrera.",
		"target": 1500.0
	},
	{
		"id": 2,
		"title": "¿QUIÉN HA VACIADO EL CÁRTEL?",
		"joe": "Joe ha confundido una dosis con el inventario completo.",
		"problem": "La avalancha apelmaza el polvo y Pulmones de Drogata roba el almacén cada 300 segundos. Cascos y paraguas entran de guardia.",
		"target": 12000.0
	},
	{
		"id": 3,
		"title": "OFERTA DEL SUPERMERCADO",
		"joe": "Joe ha comprado una ganga. La ganga contiene serrín, yeso y decisiones.",
		"problem": "Cada rayita trae serrín, Joe añade tiza por separado y el Spray del Bazar vuelve a pegar cocaína a la pared.",
		"target": 35000.0
	},
	{
		"id": 4,
		"title": "NARIZ EN MODO VOLCÁN",
		"joe": "Joe ha descubierto que una hemorragia tampoco era una señal suficiente.",
		"problem": "Joe se rasca periódicamente y abre heridas visibles. Hay que limpiar y reparar al mismo tiempo.",
		"target": 80000.0
	},
	{
		"id": 5,
		"title": "BIENVENIDOS AL ZOO",
		"joe": "La nariz de Joe ya figura como alojamiento rural para bacterias.",
		"problem": "Bacterias y moco aglutinante bloquean la pared. Llegan cuidadores y catapultas mucolíticas.",
		"target": 180000.0
	}
]

const UPGRADES := [
	{"id":"nails", "phase":1, "name":"UÑAS DE QUERATINA", "desc":"Duplica la potencia manual completa.", "base":20.0, "growth":2.35, "kind":"click", "power":2.0, "max":8},
	{"id":"pawn", "phase":1, "unlock_at":35.0, "name":"OTRO PEÓN BÁSICO", "desc":"Añade otro ciclo visible de raspado, recogida y transporte.", "base":55.0, "growth":2.0, "kind":"pawn", "power":1.0, "max":8},
	{"id":"click_burst", "phase":1, "unlock_at":90.0, "name":"NUDILLOS DE QUERATINA", "desc":"Cada cierto ritmo de clics desprende una ráfaga de granos.", "base":140.0, "growth":1.82, "kind":"click_burst", "power":3.0, "max":5},
	{"id":"box", "phase":1, "unlock_at":150.0, "name":"TRANSPORTE VESICULAR", "desc":"Duplica la carga de todos los viajes.", "base":220.0, "growth":2.7, "kind":"capacity", "power":2.0, "max":5},
	{"id":"shift", "phase":1, "unlock_at":230.0, "name":"MEMBRANAS REFORZADAS", "desc":"Aumenta claramente toda la velocidad logística.", "base":280.0, "growth":2.45, "kind":"speed", "power":0.35, "max":6},
	{"id":"puncher", "phase":1, "requires_puncher_unlock":true, "name":"CÉLULA PÚGIL EN PRÁCTICAS", "desc":"Contrata un púgil. La cuadrilla está limitada a cuatro.", "base":180.0, "growth":2.5, "kind":"autoclicker", "power":1.0, "max":4},
	{"id":"punch_power", "phase":1, "requires_upgrade":"puncher", "name":"GUANTES EMPAPADOS EN COCAÍNA", "desc":"Duplica la potencia de cada puñetazo.", "base":650.0, "growth":3.0, "kind":"auto_power", "power":2.0, "max":6},
	{"id":"click_rhythm", "phase":2, "requires_upgrade":"click_burst", "name":"RITMO DE BAÑO", "desc":"Necesitas menos clics para provocar cada ráfaga manual.", "base":800.0, "growth":2.0, "kind":"click_rhythm", "power":1.0, "max":4},
	{"id":"punch_speed", "phase":2, "requires_upgrade":"puncher", "name":"CAMPANA SIN DESCANSO", "desc":"Reduce mucho el descanso entre asaltos.", "base":1400.0, "growth":2.6, "kind":"auto_speed", "power":0.28, "max":5},
	{"id":"coord", "phase":2, "requires_septum":true, "name":"TRABAJO EN CADENA", "desc":"Reparte peones entre las dos fosas y prioriza los atascos.", "base":550.0, "growth":2.4, "kind":"coordination", "power":1.0, "max":2},
	{"id":"breaker", "phase":2, "name":"CASCO AZUL REGLAMENTARIO", "desc":"Especializa peones capaces de abrir cocaína apelmazada.", "base":850.0, "growth":2.25, "kind":"specialist", "power":1.0, "max":3},
	{"id":"umbrella", "phase":2, "name":"PARAGUAS ROSA HOMOLOGADO", "desc":"Cada unidad rescata parte del almacén cuando Joe aspira.", "base":1800.0, "growth":3.2, "kind":"umbrella", "power":0.05, "max":3},
	{"id":"umbrella_power", "phase":2, "requires_upgrade":"umbrella", "name":"TELA ANTIPULMONES", "desc":"Refuerza todos los paraguas contra Pulmones de Drogata.", "base":9000.0, "growth":3.6, "kind":"umbrella_power", "power":0.15, "max":5},
	{"id":"detector", "phase":3, "name":"QUIMIORRECEPTORES", "desc":"Reconoce impurezas antes de que se mezclen con el resto.", "base":1250.0, "growth":2.15, "kind":"detector", "power":1.0, "max":3},
	{"id":"sorting", "phase":3, "name":"RECONOCIMIENTO MOLECULAR", "desc":"Reduce la proporción de impurezas que atasca cada turno.", "base":2100.0, "growth":2.35, "kind":"sorting", "power":0.08, "max":3},
	{"id":"sponge", "phase":3, "name":"MACRÓFAGO ESPONJA", "desc":"Absorbe spray antes de que la siguiente raya se solidifique.", "base":6500.0, "growth":4.0, "kind":"sponge", "power":0.10, "max":2},
	{"id":"sponge_power", "phase":3, "requires_upgrade":"sponge", "name":"ESPONJOSIDAD PROHIBIDA", "desc":"Hace crecer a los macrófagos y multiplica su absorción.", "base":18000.0, "growth":3.8, "kind":"sponge_power", "power":0.14, "max":5},
	{"id":"platelets", "phase":4, "name":"PLAQUETAS TURBO", "desc":"Convoca pequeñas heroínas coral completamente hartas de Joe.", "base":3200.0, "growth":1.85, "kind":"platelet", "power":1.0, "max":6},
	{"id":"repair", "phase":4, "name":"PLAQUETAS GRAPADORAS", "desc":"Duplica la reparación de todas las plaquetas.", "base":5200.0, "growth":3.0, "kind":"repair", "power":2.0, "max":5},
	{"id":"handlers", "phase":5, "name":"GUANTES DE PROTECTORA", "desc":"Cuidadores que recogen bacterias sin dejar que les muerdan.", "base":7200.0, "growth":2.0, "kind":"handler", "power":1.0, "max":4},
	{"id":"signals", "phase":5, "name":"SEÑALES QUÍMICAS", "desc":"Coordina cuidadores, plaquetas y peones sin una sola reunión.", "base":10500.0, "growth":2.2, "kind":"signals", "power":0.12, "max":3},
	{"id":"catapult", "phase":5, "name":"CATAPULTA MUCOLÍTICA", "desc":"Lanza glóbulos contra el moco que bloquea la pared.", "base":16000.0, "growth":4.2, "kind":"catapult", "power":1.0, "max":2},
	{"id":"catapult_power", "phase":5, "requires_upgrade":"catapult", "name":"TENSIÓN DE MEMBRANA", "desc":"Duplica el impacto de cada lanzamiento.", "base":42000.0, "growth":3.5, "kind":"catapult_power", "power":2.0, "max":5}
]
