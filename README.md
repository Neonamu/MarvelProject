# MarvelProject


Arquitectura:

Se ha utilizado Clean Architecture como arquitectura base de la aplicación, junto con el patrón de diseño MVVM (Model-View-ViewModel) +  Coordinator. Las ventajas que conseguimos utilizando Clean Architecture es la separación de responsabilidades en las diferentes capas de la aplicación, haciendo que sea mucho más claro y delimitado cual es la función de cada una de ellas y de los objetos que la componen.

Hemos utilizado el patrón de diseño MVVM para tal menester, Así conseguimos una clara separación de la interficie (Vista) que puede ser fácilmente sustituible del Modelo, que compacta toda la lógica de negocio de la aplicación. El ViewModel es el intermediario entre ambas partes, que se encarga de pedir la información al Modelo para hacerla visible a la Vista. De esta manera, conseguimos separar la lógica de vista y aislarla dentro del ViewController, ayudando a resolver unos de los principales problemas que han existido en el entorno con Objective-C y Swift a la hora de crear los ViewControllers y su tamaño. Hemos utilizado un Coordinator para movernos entre las diferentes vistas.

Estructura:

Hemos separado las diferentes clases en tres grandes capas, Presentation, Domain y Data. 

- Presentation: Aquí están los diferentes archivos y objetos que intervienen en la construcción y visualización de las vistas. Tal como hemos dicho utilizamos Un ViewController para la lógica de vista; un ViewModel para la comunicación entre las vistas y la lógica de negocio y un Coordinator que nos ayudará a movernos entre las diferentes vistas de la aplicación.

- Domain: Esta capa se encarga de definir las entidades y los diferentes elementos de la lógica de negocio de nuestra app. Como motor principal, se ha utilizado el patrón Use cases, para así tener identificados los diferentes casos que se tratan dentro de la app: utilizando este modelo, podemos crear/quitar/modificar use cases dependiendo de las necesidades de la app, ya que nos aseguramos de agrupar toda la lógica necesaria para un caso de uso dentro de un objeto. Es una metodología que nos ayuda a tener una app escalable, manteniendo la legibilidad del código y permitiendo trabajar con equipos de personas medio-grandes evitando al máximo los conflictos que puedan surgir entre ellas. Aquí también se encuentran las Entidades de nuestra aplicación y la definición de los repositorios de datos, ya que nuestro objetivo es que este módulo, sea independiente de cualquier otro (muy importante, que no exista una dependencia de otro módulo dentro de éste) para que no existan problemas futuros si cambiamos alguno de los otros módulos (como la vista o el orígen de datos, etc).

- Data: se encarga de obtener los datos de las diferentes fuentes de datos, ya sean internas o externas, abstrayendo mediante repositorios el lugar de obtención de estos datos. Así conseguimos que si en un futuro, un orígen de datos cambia, los demás módulos y clases no se ven afectados.

- Core: Se ha creado un módulo especial cuya misión es dar ciertas características generales para la aplicación, como helpers o extensiones.

En todo momento, se ha intentado trabajar con los principios SOLID en mente, trabajando siempre que se ha podido con abstracciones, intentando crear el mínimo acoplamiento posible entre las diferentes partes. Hemos intentado en la medida de lo posible separar las implementaciones de las dependencias.

Utilizar esta metodología nos ayuda en gran medida para la creación de test unitarios y pruebas de integración, ya que es mucho más sencillo de probar cada parte de la aplicación.

Se ha utilizado un inyector de dependencias para así gestionar de manera más correcta y tener un código más limpio en las diferentes clases.

Eficiencia:

Se ha creado una solución, que intenta en todo momento reaprovechar los datos que ya ha obtenido para así no volver a pedirlos a las fuentes de datos (y minimizar el impacto que pueda causar en fuentes de datos externas). Se ha creado una pequeña clase de cache de imágenes (ImageCache) que reprovecha las imágenes ya bajadas para no volverlas a bajar mientras la aplicación esté activa.

Aparte, se ha implementado ambas vistas de tal manera que va pidiendo poco a poco los resultados (para no saturar la red ni obtener resultados innecesarios) y cada vez que se llega al final de la lista, se va a buscar la siguiente tanda de resultados. 

Hemos implementado las tableView de tal manera que no se regeneran enteras cada vez, sino que van añadiendo el contenido al snapshot que ya existe, consiguiendo un efecto suave para mostrar los nuevos resultados y que no afecta a resultados ya existentes.

Frameworks y librerías destacables:

- Swinject: Librería para realizar inyección de dependencias.
- Async/Await : Nuevo framework nativo para obtener resultados de redes externas de manera asíncrona. Mucho más fácil que utilizar que Combine y con una lectura de código mucho más sencilla por parte del programador. 
- Combine: Hemos utilizado Combine para la comunicación de eventos entre el ViewModel y la Vista.
- OHHTTPStub: simulación de HTTP Responses. Muy util para testeo.
- SwiftLint: Formateo de código. Se ha utilizado la plantilla estándard de Ray Wenderlich con algunas modificaciones.

