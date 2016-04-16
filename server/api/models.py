from __future__ import unicode_literals

from django.db import models

class Alerta(models.Model):

	latitud = models.CharField(max_length=50)
	longitud = models.CharField(max_length=50)
	tipo = models.IntegerField()

	class Meta:
		verbose_name = "Alerta"
		verbose_name_plural = "Alertas"

	def __str__(self):
		pass
	
class Zona(models.Model):

	latitud = models.CharField(max_length=50)
	longitud = models.CharField(max_length=50)
	radio = models.FloatField()
	nombre = models.CharField(max_length=50)

	class Meta:
		verbose_name = "Zona"
		verbose_name_plural = "Zonas"

	def __str__(self):
		pass

	def cercana(self, lat, lon):
		if lat == 1 and lon == 2:
			return True
		return False

class Recorrido(models.Model):

	nombre = models.CharField(max_length=50)
	latitudInicial = models.CharField(max_length=50)
	longitudInicial = models.CharField(max_length=50)
	latitudFinal = models.CharField(max_length=50)
	longitudFinal = models.CharField(max_length=50)

	class Meta:
		verbose_name = "Recorrido"
		verbose_name_plural = "Recorridos"

	def __str__(self):
		pass
    