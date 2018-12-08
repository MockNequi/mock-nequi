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

#### Paso 4: Cree la base de datos
El siguiente paso es crear la base de datos
```
bundle exec rake db:create
```

#### Paso 5: Ejecute las migraciones
```
bundle exec rake db:migrate
```

#### Paso 6: Correr programa
Para iniciar el programa ejecute el siguiente comando:
```
ruby app/Main.rb
```
