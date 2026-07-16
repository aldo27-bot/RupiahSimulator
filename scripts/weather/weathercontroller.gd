extends CanvasLayer

@onready var rain_particles = $RainParticles
@onready var rain_audio = $RainAudio
@onready var overlay = $Overlay


func _ready():

	rain_particles.emitting = false
	overlay.color.a = 0

	Weathermanager.weather_changed.connect(_on_weather_changed)


func _on_weather_changed(weather):

	match weather:

		Weathermanager.Weather.CLEAR:

			stop_rain()

		Weathermanager.Weather.RAIN:

			start_rain()


func start_rain():

	rain_particles.emitting = true

	rain_audio.play()

	overlay.color = Color(0,0,0,0.18)


func stop_rain():

	rain_particles.emitting = false

	rain_audio.stop()

	overlay.color = Color(0,0,0,0)
