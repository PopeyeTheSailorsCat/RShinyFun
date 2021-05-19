from django.db import models
from django.contrib.postgres.forms import SimpleArrayField
from django.contrib.postgres.fields import ArrayField


# class Author(models.Model):
#     name = models.CharField(max_length=255)
#     email = models.EmailField()
#
#
# class Field(models.Model):
#     name = models.CharField(max_length=50, default="None")
#     width = models.IntegerField(default=3)
#     length = models.IntegerField(default=3)
#     cells = ArrayField(models.IntegerField())
#

# Create your models here.
class Road(models.Model):
    name = models.CharField(max_length=255)  # like M11, etc
    length = models.IntegerField(default=-1)

    def __str__(self):
        return str(self.name)


class Car(models.Model):
    name = models.CharField(max_length=255)
    liters_per_100_km = models.IntegerField(default=-1)
    petrol_V = models.IntegerField(default=-1)

    def __str__(self):
        return str(self.name)


class GasStation(models.Model):
    on_road = models.ForeignKey(Road, on_delete=models.CASCADE)
    location = models.IntegerField(default=-1)

    def __str__(self):
        return str(self.on_road) + "_" + str(self.location)
