# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Bodega.create(almacen_id:"556489e7efb3d7030091bf8b",tipo:"normal")
Bodega.create(almacen_id:"556489e7efb3d7030091bffb",tipo:"normal")
Bodega.create(almacen_id:"556489e7efb3d7030091bf89",tipo:"recepcion")
Bodega.create(almacen_id:"556489e7efb3d7030091bffc",tipo:"pulmon")
Bodega.create(almacen_id:"556489e7efb3d7030091bf8a",tipo:"despacho")


Cliente.create(cliente_id:1,nombre:"Grupo1",direccion:"Mohrenstraße 82, 10117 Berlin, Germany")
Cliente.create(cliente_id:2,nombre:"Grupo2",direccion:"Denezhnyy per., 9 стр. 1, Moscow, Russia")
Cliente.create(cliente_id:3,nombre:"Grupo3",direccion:"Rigillis 15, 10674 Atenas")
Cliente.create(cliente_id:4,nombre:"Grupo4",direccion:"Nº2 Saleh Ayoub Suite 41, Zamalek, Cairo")
Cliente.create(cliente_id:5,nombre:"Grupo5",direccion:"2290 Yan An West Road. Shanghai")
Cliente.create(cliente_id:6,nombre:"Grupo6",direccion:"Calle de Lagasca, 89, 29010 Madrid, Spain")
Cliente.create(cliente_id:7,nombre:"Grupo7",direccion:"10 Culgoa CircuitO'Malley, australia")
Cliente.create(cliente_id:8,nombre:"Grupo8",direccion:"169 Garsfontein Road,  Delmondo Office Park, Sudafrica")
Cliente.create(cliente_id:9,nombre:"Mayorista Vital",direccion:"Balvanera Buenos Aires, Argentina")
Cliente.create(cliente_id:10,nombre:"Atomo",direccion:"Alvarez Condarco 740 Las Heras, Mendoza, Argentina")
Cliente.create(cliente_id:11,nombre:"Comercial S y P",direccion:"Avda Cristobal Colon 3707 Santiago")
Cliente.create(cliente_id:12,nombre:"Mercado El Bosque",direccion:"Republica de Chile 504 Jesús María, Peru")
Cliente.create(cliente_id:13,nombre:"SLUCKIS HNOS. S.A.",direccion:"Arenal Grande 2193 Montevideo, Uruguay")
Cliente.create(cliente_id:14,nombre:"DMC",direccion:"Anahí, Santa Cruz de la Sierra, Bolivia")
Cliente.create(cliente_id:15,nombre:"Fastrax S.A.",direccion:"Tte. Fariña Nº 166 esq. Yegros")
Cliente.create(cliente_id:16,nombre:"MPS",direccion:"45 CC Monterrey Locales 326 y 327 Carrera 50 # 10, Medellín, Antioquia, Colombia")
Cliente.create(cliente_id:17,nombre:"Kode-tech",direccion:"Av. Sanatorio del Ávila, Edif. Yacambú, Piso 3, Boleita Norte, Caracas, Venezuela.")
Cliente.create(cliente_id:18,nombre:"MAMBO",direccion:"Rua Deputado Lacerda Franco, 553 - Pinheiros São Paulo - SP, Brazil")
Cliente.create(cliente_id:19,nombre:"DCM",direccion:"Laguna de Mayrán 300 Anáhuac, Miguel Hidalgo, Ciudad de México, D.F., Mexico")
Cliente.create(cliente_id:20,nombre:"Greenfield USA",direccion:"5641 Dewey St Hollywood, FL, United States")
Cliente.create(cliente_id:21,nombre:"TopTen",direccion:"448 S Hill St #712 Los Angeles, CA, United States")