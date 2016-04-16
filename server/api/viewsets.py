from rest_framework import viewsets
from rest_framework.response import Response
from .models import *
from .serializers import *

class AlertaViewset(viewsets.ModelViewSet):
	serializer_class = AlertaSerializer
	queryset = Alerta.objects.all()

class ZonaViewset(viewsets.ModelViewSet):
	serializer_class = ZonaSerializer
	queryset = Zona.objects.all()

class RecorridoViewset(viewsets.ModelViewSet):
	serializer_class = RecorridoSerializer
	queryset = Recorrido.objects.all()

class ZonaCercanaViewset(viewsets.ViewSet):
	
	def list(self, request):
		query = Zona.objects.all()
		zonas = query
		lat = request.query_params.get('lat')
		lon = request.query_params.get('lon')
		if zonas.get(pk=1).cercana(lat,lon):
			serializer = ZonaSerializer(zonas)
		else:
			serializer = ZonaSerializer([])
		return Response(serializer.data)

