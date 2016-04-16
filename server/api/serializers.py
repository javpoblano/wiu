from rest_framework import serializers
from .models import *

class AlertaSerializer(serializers.Serializer):
	pk = serializers.IntegerField(read_only=True)
	latitud = serializers.CharField()
	longitud = serializers.CharField()
	tipo = serializers.IntegerField()

	def create(self,validated_data):
		return Alerta.objects.create(**validated_data)

class ZonaSerializer(serializers.Serializer):
	pk = serializers.IntegerField(read_only=True)
	latitud = serializers.CharField()
	longitud = serializers.CharField()
	radio = serializers.FloatField()
	nombre = serializers.CharField()

	def create(self,validated_data):
		return Zona.objects.create(**validated_data)

class RecorridoSerializer(serializers.Serializer):
	pk = serializers.IntegerField(read_only=True)
	nombre = serializers.CharField()
	latitudInicial = serializers.CharField()
	longitudInicial = serializers.CharField()
	latitudFinal = serializers.CharField()
	longitudFinal = serializers.CharField()