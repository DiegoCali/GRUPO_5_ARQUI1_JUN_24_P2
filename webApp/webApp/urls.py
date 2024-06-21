"""
URL configuration for webApp project.

The urlpatterns list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from fronted.views import home  # Asegúrate de que esta línea sea correcta
from fronted.views import obtener_datos  # Asegúrate de que esta línea sea correcta

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', home, name='home'),  # Asegúrate de usar name='home' si quieres referenciar esta URL en otras partes de tu código
    path('obtener_datos/', obtener_datos, name='obtener_datos'),  ]