from django.shortcuts import render
from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.generics import get_object_or_404, GenericAPIView, ListCreateAPIView, CreateAPIView, ListAPIView
from rest_framework.mixins import ListModelMixin
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import Road, Car, GasStation
from .serializers import RoadSerializer, CarSerializer, GasStationSerializer


class RoadView(viewsets.ModelViewSet):
    queryset = Road.objects.all()
    serializer_class = RoadSerializer

    @action(detail=True)
    def get_stations(self, request, pk=None):
        road = self.get_object()
        stations = GasStationSerializer(road.gasstation_set.all().order_by('-location'), many=True)
        return Response(stations.data)


# Create your views here.
class CarView(viewsets.ModelViewSet):
    queryset = Car.objects.all()
    serializer_class = CarSerializer


class GasStationView(viewsets.ModelViewSet):
    queryset = GasStation.objects.all()
    serializer_class = GasStationSerializer
