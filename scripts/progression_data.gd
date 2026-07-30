extends RefCounted

const PHASES := [
	{
		"id": 1,
		"title": "UNA RAYITA PARA DESAYUNAR",
		"joe": "Joe ha decidido que el desayuno equilibrado era opcional.",
		"problem": "Aprende a limpiar, transportar y automatizar antes del primer desastre.",
		"target": 800.0
	},
	{
		"id": 2,
		"title": "¿QUIÉN HA VACIADO EL CÁRTEL?",
		"joe": "Joe ha confundido una dosis con el inventario completo.",
		"problem": "La avalancha apelmaza el polvo. Los cascos azules entran de guardia.",
		"target": 4500.0
	},
	{
		"id": 3,
		"title": "OFERTA DEL SUPERMERCADO",
		"joe": "Joe ha comprado una ganga. La ganga contiene serrín, yeso y decisiones.",
		"problem": "Las impurezas viajan con la cocaína y la caja empieza a comportarse de forma sospechosa.",
		"target": 14000.0
	},
	{
		"id": 4,
		"title": "NARIZ EN MODO VOLCÁN",
		"joe": "Joe ha descubierto que una hemorragia tampoco era una señal suficiente.",
		"problem": "Hay que limpiar y reparar al mismo tiempo. Llegan las plaquetas.",
		"target": 32000.0
	},
	{
		"id": 5,
		"title": "BIENVENIDOS AL ZOO",
		"joe": "La nariz de Joe ya figura como alojamiento rural para bacterias.",
		"problem": "Los cuidadores con guantes retiran visitas oportunistas sin convertir esto en una guerra.",
		"target": 75000.0
	}
]

const UPGRADES := [
	{"id":"nails", "phase":1, "name":"UÑAS DE QUERATINA", "desc":"Desprende piezas más valiosas de la pared.", "base":15.0, "growth":1.58, "kind":"click", "power":1.0},
	{"id":"pawn", "phase":1, "unlock_at":35.0, "name":"OTRO PEÓN BÁSICO", "desc":"Añade otro ciclo visible de raspado, recogida y transporte.", "base":45.0, "growth":1.65, "kind":"pawn", "power":1.0},
	{"id":"click_burst", "phase":1, "unlock_at":90.0, "name":"NUDILLOS DE QUERATINA", "desc":"Cada cierto ritmo de clics desprende una ráfaga de granos.", "base":140.0, "growth":1.82, "kind":"click_burst", "power":3.0, "max":5},
	{"id":"box", "phase":1, "unlock_at":150.0, "name":"TRANSPORTE VESICULAR", "desc":"Cada peón muestra y transporta una pieza adicional.", "base":180.0, "growth":1.9, "kind":"capacity", "power":1.0, "max":5},
	{"id":"shift", "phase":1, "unlock_at":230.0, "name":"MEMBRANAS REFORZADAS", "desc":"Los peones se mueven y manipulan la carga más deprisa.", "base":240.0, "growth":2.05, "kind":"speed", "power":0.18, "max":6},
	{"id":"puncher", "phase":1, "requires_puncher_unlock":true, "name":"CÉLULA PÚGIL EN PRÁCTICAS", "desc":"Contrata una célula que golpea la pared sin esperar tus clics.", "base":120.0, "growth":1.75, "kind":"autoclicker", "power":1.0, "max":8},
	{"id":"punch_power", "phase":1, "requires_upgrade":"puncher", "name":"GUANTES EMPAPADOS EN COCAÍNA", "desc":"Cada puñetazo automático desprende otro grano.", "base":500.0, "growth":2.1, "kind":"auto_power", "power":1.0, "max":5},
	{"id":"smart_clump", "phase":2, "name":"APELMAZADO INTELIGENTE", "desc":"Convierte cada seis granos transportados en una bola segura y compacta.", "base":700.0, "growth":1.0, "kind":"smart_clump", "power":6.0, "max":1},
	{"id":"click_rhythm", "phase":2, "requires_upgrade":"click_burst", "name":"RITMO DE BAÑO", "desc":"Necesitas menos clics para provocar cada ráfaga manual.", "base":800.0, "growth":2.0, "kind":"click_rhythm", "power":1.0, "max":4},
	{"id":"punch_speed", "phase":2, "requires_upgrade":"puncher", "name":"CAMPANA SIN DESCANSO", "desc":"Acorta el tiempo entre puñetazos automáticos.", "base":1200.0, "growth":2.15, "kind":"auto_speed", "power":0.16, "max":5},
	{"id":"coord", "phase":2, "requires_septum":true, "name":"TRABAJO EN CADENA", "desc":"Reparte peones entre las dos fosas y prioriza los atascos.", "base":550.0, "growth":2.4, "kind":"coordination", "power":1.0, "max":2},
	{"id":"breaker", "phase":2, "name":"CASCO AZUL REGLAMENTARIO", "desc":"Especializa peones capaces de abrir cocaína apelmazada.", "base":850.0, "growth":2.25, "kind":"specialist", "power":1.0, "max":3},
	{"id":"detector", "phase":3, "name":"QUIMIORRECEPTORES", "desc":"Reconoce impurezas antes de que se mezclen con el resto.", "base":1250.0, "growth":2.15, "kind":"detector", "power":1.0, "max":3},
	{"id":"sorting", "phase":3, "name":"RECONOCIMIENTO MOLECULAR", "desc":"Reduce la proporción de impurezas que atasca cada turno.", "base":2100.0, "growth":2.35, "kind":"sorting", "power":0.08, "max":3},
	{"id":"platelets", "phase":4, "name":"PLAQUETAS TURBO", "desc":"Convoca pequeñas heroínas coral completamente hartas de Joe.", "base":3200.0, "growth":1.85, "kind":"platelet", "power":1.0, "max":6},
	{"id":"repair", "phase":4, "name":"FAGOCITOSIS AVANZADA", "desc":"Acelera la reparación para que limpiar no tenga que detenerse.", "base":4800.0, "growth":2.05, "kind":"repair", "power":0.22, "max":5},
	{"id":"handlers", "phase":5, "name":"GUANTES DE PROTECTORA", "desc":"Cuidadores que recogen bacterias sin dejar que les muerdan.", "base":7200.0, "growth":2.0, "kind":"handler", "power":1.0, "max":4},
	{"id":"signals", "phase":5, "name":"SEÑALES QUÍMICAS", "desc":"Coordina cuidadores, plaquetas y peones sin una sola reunión.", "base":10500.0, "growth":2.2, "kind":"signals", "power":0.12, "max":3}
]
