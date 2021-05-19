# from django.urls import path
# from .views import RoadView
# app_name = "old_town_road"
# # app_name will help us do a reverse look-up latter.
# urlpatterns = [
#     path('roads/', RoadView.as_view({'get': 'list'})),
#     path('roads/<int:pk>', RoadView.as_view({'get': 'retrieve'}))
# ]

from rest_framework.routers import DefaultRouter
from .views import RoadView, CarView, GasStationView

router = DefaultRouter()
router.register(r'roads', RoadView, basename='user')
router.register(r'cars', CarView, basename='user')
router.register(r'gas_stations', GasStationView, basename='user')
urlpatterns = router.urls
