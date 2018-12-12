# mock-nequi
Proyecto final del ciclo 1 de CodumAcademy, prototipo basado en el servicio creado por Bancolombia para transferir dinero entre personas llamado Nequi.

### Guía para instalar y ejecutar el programa

#### Paso 0: Requisitos
Tener instalado Ruby y postgres

#### Paso 1: Clone el repositorio
```
git clone https://github.com/MockNequi/mock-nequi.git
```

#### Paso 2:  Instale bundler
Ubiquese en el directorio raíz y ejecute el siguiente comando
```
gem install bundler --no-ri --no-rdoc
```

#### Paso 3: Instale las gemas necesarias
Con el siguiente comando:
```
bundle
```

#### Paso 4: Configurar credenciales de la base de datos
Ingrese a la carpeta db y en el archivo config.yml ingrese el username y password de postgres.

#### Paso 5: Cree la base de datos
El siguiente paso es crear la base de datos
```
bundle exec rake db:create
```

#### Paso 6: Ejecute las migraciones
```
bundle exec rake db:migrate
```

#### Paso 7: Correr programa
Para iniciar el programa ejecute el siguiente comando:
```
ruby app/Main.rb
```
