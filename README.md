#  BusRouter - SEAT:CODE Skill Test
![Swift 5.9.2](https://img.shields.io/badge/Swift-5.9.2-orange.svg)
![Xcode 15.1](https://img.shields.io/badge/Xcode-15.1-blue.svg)
![iOS 17](https://img.shields.io/badge/iOS-17-blue.svg)
![Tests](https://img.shields.io/badge/tests-passing-brightgreen.svg)

## Notas

1. No he conseguido que el script de swift-format se ejecute, por lo que hay que ejecutar manualmente el comando "swift-format -i -r [SRCROOT]" desde Terminal. (Instalar con $  brew install swiftformat)
2. Tenía intención de escribir tests de automatización de UI usando Maestro CLI (https://maestro.mobile.dev) pero no me dio tiempo. Estaré encantado de hablar sobre el tema.
3. De las tareas 1 y 2 me siento bastante orgulloso, la tercera la terminé por dejarla entregable, pero no creo que la solución aplicada sea ni de lejos la adecuada, puesto que daba lugar a un montón de acoplamiento entre la librería de UI y las pantallas del módulo principal. Veréis soluciones chapuceras aplicadas con tal de mostrar la "StopInfo", ya que el tiempo se me echó encima.
4. El PDF menciona un par de enlaces relacionados con Google Polyline, pero parecen estar rotos, lo cual no es preocupante ya que realicé mis propias investigaciones y acabé utilizando una librería de terceros que decodifica la información y permite convetirla al Polyline de Apple. Al principio, dado que esos enlaces estaban rotos, pensé que la información del primer endpoint que contenía un array de Stops se podría usar para crear las rutas, pero tras un par de pruebas vi que estaba entendiendo mal la tarea y volví al cauce con el parámetro "route".
5. No me ha dado tiempo a aplicar Unit Testing.
6. He incluido un solo test con prisa relacionado con snapshot testing. La gracia de esta librería (y su compenetración con The Composable Architecture) es que siempre que las pantallas estén bien hechas, podremos tomar fotos de su aspecto a lo largo de toda la aplicación en cuestión de segundos, sin necesidad de que pasen los flujos y procesos como llamadas a API o cambios de estado, ya que son todos mockeables. Esta librería nos puede asegurar también que nuestra app se sigue viendo bien en todos los tamaños de pantalla siempre que los tengamos pregrabados.
7. Respecto al minimum target. Originalmente era iOS 15 ya que pienso que es la versión mínima que tiene sentido soportar; más del 90% de los dispositivos son soportados y incluye muchas herramientas nuevas y optimizaciones que merece la pena tener en cuenta. Ahora bien, en determinado punto me vi con que MapKit en SwiftUI para iOS 15 está muy limitado, por lo que con tal de dedicarme a la parte realmente importante (los ejercicios) y de paso aprender para mis proyectos personales, subí el target a iOS 17, en el que MapKit ha mejorado enormemente.
8. He separado la UI reutilizable del módulo principal en una librería SPM para demostrar que sé hacerlo y porque a nivel de tiempos de compilación es una modularización óptima, ya que permite no recompilar el código de un módulo cuyo contenido no ha sido alterado, reduciendo los tiempos de compilación tras una primera exitosa del proyecto completo.
9. Mi elección de Swift Package Manager ha sido puramente práctica. CocoaPods es un gestor de dependencias que causa muchos problemas, tanto en su uso como en compatibilidades, por no mencionar que en muchas ocasiones supone una barrera de entrada para gente más junior y llega incluso a costar horas de trabajo cuando algunos errores complejos aparecen. Carthage es una opción pero personalmente SPM es lo más sencillo, efectivo y está hecho por Apple.

## Instrucciones
1. Tras la primera apertura, deberemos esperar a que los paquetes de SPM se descarguen y compilen.
2. Cuando haya terminado de resolver las dependencias, el proyecto (tanto el esquema de la librería, como el módulo de la app o los tests) deberían ser perfectamente compilables sin ningún paso extra requerido.

