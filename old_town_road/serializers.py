from rest_framework import serializers
from .models import Road, Car, GasStation


class RoadSerializer(serializers.ModelSerializer):
    class Meta:
        model = Road
        fields = ('id', "name", 'length')


class CarSerializer(serializers.ModelSerializer):
    class Meta:
        model = Car
        fields = ('id', 'name', 'liters_per_100_km', 'petrol_V')
    # name = serializers.CharField(max_length=255)
    # liters_per_100_km = serializers.IntegerField()
    # petrol_V = serializers.IntegerField()
    #
    # def create(self, validated_data):
    #     return Car.objects.create(**validated_data)


class GasStationSerializer(serializers.ModelSerializer):
    class Meta:
        model = GasStation
        fields = ('id', 'on_road', 'location')
